import 'dart:io';
import 'dart:convert';

void main() async {
  final rootDir = Directory.current;
  final registryPath = '${rootDir.path}/lib/registry';

  final files = _findDartFiles(registryPath);
  stdout.writeln('Scanning ${files.length} Dart files...');

  final hardcodedFindings = <ColorFinding>[];
  final staleCaptureFindings = <StaleCapture>[];
  final alphaFindings = <AlphaIssue>[];

  for (final file in files) {
    final content = await File(file).readAsString();
    final lines = content.split('\n');

    // Find hardcoded colors
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNum = i + 1;

      // Color(0x...)
      final colorHexMatches = RegExp(
        r'Color\((0x[0-9A-Fa-f]+)\)',
      ).allMatches(line);
      for (final match in colorHexMatches) {
        final value = match.group(1)!;
        // Skip transparent
        if (value == '0x00000000' || value == '0x0') continue;
        // Check if this is in allowed context (overlay, barrier, dialog)
        final context = _getContext(lines, i);
        if (value == '0xFF000000' || value == '0xFFFFFFFF') {
          if (context.contains('barrier') ||
              context.contains('overlay') ||
              context.contains('modal') ||
              context.contains('dialog') ||
              context.contains('shadow')) {
            continue;
          }
        }
        hardcodedFindings.add(
          ColorFinding(
            file: file,
            line: lineNum,
            type: 'Color(0x...)',
            value: value,
            context: context,
          ),
        );
      }

      // Color.fromARGB / Color.fromRGBO
      final colorFactoryMatches = RegExp(
        r'Color\.(fromARGB|fromRGBO)\([^)]+\)',
      ).allMatches(line);
      for (final match in colorFactoryMatches) {
        final context = _getContext(lines, i);
        hardcodedFindings.add(
          ColorFinding(
            file: file,
            line: lineNum,
            type: 'Color.${match.group(1)}',
            value: match.group(0)!,
            context: context,
          ),
        );
      }

      // Colors.* constants
      final colorsConstMatches = RegExp(r'Colors\.[a-zA-Z]+').allMatches(line);
      for (final match in colorsConstMatches) {
        final context = _getContext(lines, i);
        hardcodedFindings.add(
          ColorFinding(
            file: file,
            line: lineNum,
            type: 'Colors.*',
            value: match.group(0)!,
            context: context,
          ),
        );
      }

      // Check for const Color field defaults
      final constColorMatches = RegExp(
        r'(const|final)\s+Color\s+\w+\s*=\s*Color\([^)]+\)',
      ).allMatches(line);
      for (final match in constColorMatches) {
        final context = _getContext(lines, i);
        hardcodedFindings.add(
          ColorFinding(
            file: file,
            line: lineNum,
            type: 'const Color default',
            value: match.group(0)!,
            context: context,
          ),
        );
      }

      // Check for stale captures in initState / didChangeDependencies
      if (line.contains('initState') ||
          line.contains('didChangeDependencies')) {
        // Look ahead for color assignments
        for (int j = i; j < (i + 30).clamp(0, lines.length); j++) {
          final l = lines[j];
          // Look for assignments to color-related fields
          final assignMatch = RegExp(
            r'(\w*(?:color|foreground|background|fill|border)\w*)\s*=\s*.*(?:ShadcnTheme\.of|Theme\.of|\.resolve\(|\.colors)',
          ).firstMatch(l);
          if (assignMatch != null) {
            final context = _getContext(lines, j);
            staleCaptureFindings.add(
              StaleCapture(
                file: file,
                line: j + 1,
                field: assignMatch.group(1)!,
                method: line.contains('initState')
                    ? 'initState'
                    : 'didChangeDependencies',
                value: assignMatch.group(0)!,
                context: context,
              ),
            );
          }
        }
      }

      // Check for alpha issues (withOpacity, withValues)
      final alphaMatches = RegExp(
        r'\.(withOpacity|withValues)\([^)]+\)',
      ).allMatches(line);
      for (final match in alphaMatches) {
        final context = _getContext(lines, i);
        alphaFindings.add(
          AlphaIssue(
            file: file,
            line: lineNum,
            method: match.group(1)!,
            value: match.group(0)!,
            context: context,
          ),
        );
      }
    }
  }

  // Filter out allowed patterns
  final filteredFindings = hardcodedFindings.where((f) {
    // Allow transparent (0x00000000) - it's used for "no background"
    if (f.value == '0x00000000' || f.value == '0x0') return false;
    // Allow black/white for overlays (dialog barriers, etc.)
    if (f.value == '0xFF000000' || f.value == '0xFFFFFFFF') {
      // Check context for overlay/barrier
      if (f.context.contains('barrier') ||
          f.context.contains('overlay') ||
          f.context.contains('modal') ||
          f.context.contains('dialog') ||
          f.context.contains('shadow')) {
        return false;
      }
    }
    return true;
  }).toList();

  // Output results
  final output = {
    'hardcoded': filteredFindings.map((f) => f.toJson()).toList(),
    'stale_captures': staleCaptureFindings.map((f) => f.toJson()).toList(),
    'alpha_issues': alphaFindings.map((f) => f.toJson()).toList(),
  };

  final outputPath = '${rootDir.path}/../rearch/reports/p6_theme_audit.json';
  await File(
    outputPath,
  ).writeAsString(JsonEncoder.withIndent('  ').convert(output));
  stdout.writeln('Written to $outputPath');
  stdout.writeln('Hardcoded colors: ${filteredFindings.length}');
  stdout.writeln('Stale captures: ${staleCaptureFindings.length}');
  stdout.writeln('Alpha issues: ${alphaFindings.length}');
}

List<String> _findDartFiles(String dir) {
  final files = <String>[];
  final dirEntity = Directory(dir);
  if (!dirEntity.existsSync()) return files;

  for (final entity in dirEntity.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // Skip generated files and test files
      if (!entity.path.contains('.g.dart') &&
          !entity.path.contains('.freezed.dart') &&
          !entity.path.contains('/test/') &&
          !entity.path.contains('_test.dart')) {
        files.add(entity.path);
      }
    }
  }
  return files;
}

String _getContext(List<String> lines, int index) {
  final start = (index - 2).clamp(0, lines.length - 1);
  final end = (index + 2).clamp(0, lines.length - 1);
  return lines.sublist(start, end + 1).join('\n');
}

class ColorFinding {
  final String file;
  final int line;
  final String type;
  final String value;
  final String context;

  ColorFinding({
    required this.file,
    required this.line,
    required this.type,
    required this.value,
    required this.context,
  });

  Map<String, dynamic> toJson() => {
    'file': file,
    'line': line,
    'type': type,
    'value': value,
    'context': context,
  };
}

class StaleCapture {
  final String file;
  final int line;
  final String field;
  final String method;
  final String value;
  final String context;

  StaleCapture({
    required this.file,
    required this.line,
    required this.field,
    required this.method,
    required this.value,
    required this.context,
  });

  Map<String, dynamic> toJson() => {
    'file': file,
    'line': line,
    'field': field,
    'method': method,
    'value': value,
    'context': context,
  };
}

class AlphaIssue {
  final String file;
  final int line;
  final String method;
  final String value;
  final String context;

  AlphaIssue({
    required this.file,
    required this.line,
    required this.method,
    required this.value,
    required this.context,
  });

  Map<String, dynamic> toJson() => {
    'file': file,
    'line': line,
    'method': method,
    'value': value,
    'context': context,
  };
}
