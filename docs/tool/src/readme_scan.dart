// README + CLI-snapshot scanning for the docs codegen.
//
// Extracts fenced code blocks, heuristic keyboard/a11y rows and the
// hand-maintained CLI snapshot (docs/tool/cli_snapshot.txt). The keyboard
// heuristic is deliberately conservative: it only reads sections whose
// heading matches keyboard/a11y/accessib/behavio(u)r and only accepts
// Markdown-table key cells or backticked/bold key tokens; everything else is
// reported as a gap (docs_tables.dart `kKeyboardGaps`), never invented.

/// One fenced code block of a README.
class ReadmeBlock {
  /// Creates the block.
  const ReadmeBlock({
    required this.language,
    required this.code,
    required this.line,
  });

  /// Fence language (`dart`, `bash`, …), lower-cased; empty when unlabelled.
  final String language;

  /// Block content without the fences.
  final String code;

  /// 1-based line of the opening fence (for the report).
  final int line;
}

/// One Markdown section (`## Heading` … next heading).
class ReadmeSection {
  /// Creates the section.
  const ReadmeSection({
    required this.heading,
    required this.level,
    required this.body,
  });

  /// Heading text without `#` markers.
  final String heading;

  /// Number of `#` markers.
  final int level;

  /// Raw lines of the section body.
  final List<String> body;
}

/// Parsed `README.md`.
class ReadmeDoc {
  /// Creates the doc.
  const ReadmeDoc({required this.blocks, required this.sections});

  /// Fenced code blocks in reading order.
  final List<ReadmeBlock> blocks;

  /// Sections in reading order.
  final List<ReadmeSection> sections;
}

/// Parses [markdown] into blocks and sections.
ReadmeDoc parseReadme(String markdown) {
  final List<String> lines = markdown.split('\n');
  final List<ReadmeBlock> blocks = <ReadmeBlock>[];
  final List<ReadmeSection> sections = <ReadmeSection>[];

  ReadmeSection? section;
  bool inFence = false;
  String fenceLanguage = '';
  List<String> fenceBody = const <String>[];
  int fenceLine = 0;

  void closeSection() {
    if (section != null) {
      sections.add(section!);
      section = null;
    }
  }

  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i];
    final String trimmed = line.trimLeft();
    if (trimmed.startsWith('```')) {
      if (!inFence) {
        inFence = true;
        fenceLanguage = trimmed.substring(3).trim().toLowerCase();
        fenceBody = <String>[];
        fenceLine = i + 1;
      } else {
        inFence = false;
        blocks.add(
          ReadmeBlock(
            language: fenceLanguage,
            code: fenceBody.join('\n'),
            line: fenceLine,
          ),
        );
      }
      continue;
    }
    if (inFence) {
      fenceBody.add(line);
      continue;
    }
    final RegExpMatch? heading = RegExp(r'^(#+)\s+(.*)$').firstMatch(line);
    if (heading != null) {
      closeSection();
      section = ReadmeSection(
        heading: heading.group(2)!.trim(),
        level: heading.group(1)!.length,
        body: <String>[],
      );
      continue;
    }
    section?.body.add(line);
  }
  closeSection();
  return ReadmeDoc(blocks: blocks, sections: sections);
}

/// One keyboard row parsed from a README section.
class KeyboardRowFacts {
  /// Creates the row.
  const KeyboardRowFacts({
    required this.keys,
    required this.action,
    required this.source,
  });

  /// Key or key combination (`ArrowDown / ArrowUp`).
  final String keys;

  /// What the key does.
  final String action;

  /// Heading the row came from (`Keyboard`, `Behaviour`).
  final String source;
}

final RegExp _keyboardHeading = RegExp(
  r'keyboard|a11y|accessib|behavio',
  caseSensitive: false,
);
final RegExp _keyName = RegExp(
  r'^(esc|escape|enter|return|tab|space|spacebar|home|end|page ?up|page ?down|'
  r'arrow ?up|arrow ?down|arrow ?left|arrow ?right|backspace|delete|insert|'
  r'shift|ctrl|control|cmd|command|meta|alt|option|fn|caps ?lock|'
  r'f([1-9]|1[0-2]))$',
  caseSensitive: false,
);
final RegExp _keySymbols = RegExp(r'^[⌘⌥⌃⇧][A-Za-z0-9]?$');
final RegExp _backtickToken = RegExp(r'`([^`\n]+)`');
final RegExp _boldToken = RegExp(r'\*\*([^*\n]+)\*\*');

/// Conservative keyboard/a11y rows from sections whose heading matches.
List<KeyboardRowFacts> keyboardRows(ReadmeDoc doc) {
  final List<KeyboardRowFacts> rows = <KeyboardRowFacts>[];
  final Set<String> seen = <String>{};
  for (final ReadmeSection section in doc.sections) {
    if (!_keyboardHeading.hasMatch(section.heading)) {
      continue;
    }
    for (final String rawLine in section.body) {
      final String line = rawLine.trim();
      if (line.isEmpty) {
        continue;
      }
      if (line.startsWith('|')) {
        final KeyboardRowFacts? row = _tableRow(line, section.heading);
        if (row != null && seen.add('${row.keys}|${row.action}')) {
          rows.add(row);
        }
        continue;
      }
      final KeyboardRowFacts? row = _proseRow(line, section.heading);
      if (row != null && seen.add('${row.keys}|${row.action}')) {
        rows.add(row);
      }
    }
  }
  return rows;
}

KeyboardRowFacts? _tableRow(String line, String source) {
  final List<String> cells = line
      .split('|')
      .map((String cell) => cell.trim())
      .toList();
  if (cells.length < 3) {
    return null;
  }
  final String keyCell = cells[1];
  if (RegExp(r'^[-: ]+$').hasMatch(keyCell)) {
    return null; // separator row (|---|---|)
  }
  if (!isKeyCell(keyCell)) {
    return null;
  }
  final String action = _cleanMarkdown(cells.sublist(2).join(' '));
  if (action.isEmpty) {
    return null;
  }
  return KeyboardRowFacts(
    keys: _cleanMarkdown(keyCell),
    action: action,
    source: source,
  );
}

KeyboardRowFacts? _proseRow(String line, String source) {
  final List<String> keys = <String>[];
  final StringBuffer stripped = StringBuffer();
  int cursor = 0;
  for (final RegExpMatch match in _backtickToken.allMatches(line)) {
    stripped.write(line.substring(cursor, match.start));
    final String token = match.group(1)!.trim();
    if (isKeyToken(token)) {
      keys.add(token);
    } else {
      stripped.write(match.group(0));
    }
    cursor = match.end;
  }
  stripped.write(line.substring(cursor));
  String text = stripped.toString();
  for (final RegExpMatch match in _boldToken.allMatches(line)) {
    final String token = match.group(1)!.trim();
    if (isKeyToken(token)) {
      keys.add(token);
      text = text.replaceFirst(match.group(0)!, ' ');
    }
  }
  if (keys.isEmpty) {
    return null;
  }
  final String action = _cleanMarkdown(text);
  if (action.isEmpty) {
    return null;
  }
  return KeyboardRowFacts(
    keys: keys.toSet().join(' / '),
    action: action,
    source: source,
  );
}

/// Whether a Markdown table cell is a key or key combination.
bool isKeyCell(String text) {
  final String cleaned = text.replaceAll(RegExp(r'[`*]'), '').trim();
  if (cleaned.isEmpty || cleaned.length > 24) {
    return false;
  }
  final List<String> parts = cleaned
      .split(RegExp(r'\s*[/+]\s*'))
      .where((String part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty || parts.length > 4) {
    return false;
  }
  return parts.every(isKeyToken);
}

/// Whether one token names a keyboard key or key combo.
bool isKeyToken(String token) {
  final String cleaned = token.trim();
  return _keyName.hasMatch(cleaned) ||
      _keySymbols.hasMatch(cleaned) ||
      RegExp(r'^[⌘⌥⌃⇧]?[A-Z]$').hasMatch(cleaned);
}

String _cleanMarkdown(String text) {
  final String cleaned = text
      .replaceAll(RegExp(r'`'), '')
      .replaceAll(RegExp(r'\*\*|\*'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceFirst(RegExp(r'^[:—–-]+\s*'), '')
      .replaceFirst(RegExp(r'\s*[:—–]$'), '')
      .trim();
  return cleaned;
}

// ---------------------------------------------------------------------------
// CLI snapshot.
// ---------------------------------------------------------------------------

/// One flag of a CLI command section.
class CliFlagFacts {
  /// Creates the flag.
  const CliFlagFacts({
    required this.name,
    this.alias,
    this.placeholder,
    required this.description,
  });

  /// Long flag name (`--dry-run`).
  final String name;

  /// Short alias (`-h`), or null.
  final String? alias;

  /// Value placeholder (`<path>`), or null for boolean flags.
  final String? placeholder;

  /// One-line description.
  final String description;
}

/// One `$ flutter_shadcn …` section of `cli_snapshot.txt`.
class CliCommandFacts {
  /// Creates the command facts.
  const CliCommandFacts({
    required this.invocation,
    required this.label,
    required this.usage,
    required this.summary,
    required this.helpText,
    required this.flags,
  });

  /// Full invocation line without the `$ ` prefix.
  final String invocation;

  /// Invocation without the trailing `--help` (`flutter_shadcn add`).
  final String label;

  /// The `Usage:` string.
  final String usage;

  /// First description line of the section.
  final String summary;

  /// Section body verbatim (renders in `CodeSnippet`).
  final String helpText;

  /// Parsed flag rows.
  final List<CliFlagFacts> flags;
}

final RegExp _cliFlagLine = RegExp(
  r'^\s{2,}(?:(-[A-Za-z]), )?(--[a-z][a-z0-9-]*)(=<[^>]+>)?\s{2,}(.+)$',
);

/// Parses the hand-maintained CLI snapshot; see `cli_snapshot.txt`.
List<CliCommandFacts> parseCliSnapshot(String text) {
  final List<String> lines = text.split('\n');
  final List<CliCommandFacts> commands = <CliCommandFacts>[];
  List<String> body = <String>[];
  String? invocation;

  void flush() {
    if (invocation == null) {
      return;
    }
    final List<String> content = body
        .where((String line) => !line.startsWith('#'))
        .toList(growable: false);
    final String usage =
        content
            .where((String line) => line.startsWith('Usage:'))
            .map((String line) => line.substring(6).trim())
            .firstOrNull ??
        '';
    final String summary =
        content
            .where(
              (String line) =>
                  line.trim().isNotEmpty &&
                  !line.startsWith('Usage:') &&
                  !line.startsWith('Available') &&
                  !line.startsWith('Run "') &&
                  !_cliFlagLine.hasMatch(line),
            )
            .map((String line) => line.trim())
            .firstOrNull ??
        '';
    final List<CliFlagFacts> flags = <CliFlagFacts>[];
    for (final String line in content) {
      final RegExpMatch? match = _cliFlagLine.firstMatch(line);
      if (match == null) {
        continue;
      }
      flags.add(
        CliFlagFacts(
          name: match.group(2)!,
          alias: match.group(1),
          placeholder: match.group(3)?.substring(1),
          description: match.group(4)!.trim(),
        ),
      );
    }
    commands.add(
      CliCommandFacts(
        invocation: invocation!,
        label: invocation!.replaceFirst(RegExp(r'\s+--help$'), ''),
        usage: usage,
        summary: summary,
        helpText: content.join('\n').trim(),
        flags: flags,
      ),
    );
    body = <String>[];
    invocation = null;
  }

  for (final String line in lines) {
    if (line.startsWith(r'$ ')) {
      flush();
      invocation = line.substring(2).trim();
      continue;
    }
    if (invocation != null) {
      body.add(line);
    }
  }
  flush();
  return commands;
}
