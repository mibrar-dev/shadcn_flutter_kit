import 'dart:convert';
import 'dart:io';

/// Registry manifest audit that catches known production hazards.
///
/// Run from the repo root:
///   dart run flutter_shadcn_kit/tool/registry_manifest_audit.dart
void main() async {
  final audit = RegistryManifestAudit();
  final failures = await audit.run();

  if (failures.isEmpty) {
    print('Registry manifest audit passed. No hazards found.');
    exit(0);
  } else {
    print('');
    print('Registry manifest audit FAILED with ${failures.length} hazard(s):');
    print('');
    for (final f in failures) {
      print('  [${f.severity}] ${f.category}: ${f.message}');
    }
    print('');
    exit(1);
  }
}

class AuditFailure {
  final String severity;
  final String category;
  final String message;

  AuditFailure({required this.severity, required this.category, required this.message});
}

class RegistryManifestAudit {
  final List<AuditFailure> _failures = [];

  List<AuditFailure> get failures => List.unmodifiable(_failures);

  Future<List<AuditFailure>> run() async {
    await _checkComponentsJson();
    await _checkRegistriesJson();
    await _checkComponentManifests();
    await _checkThemeInstallEntries();
    return failures;
  }

  void _fail(String category, String message, {String severity = 'ERROR'}) {
    _failures.add(AuditFailure(severity: severity, category: category, message: message));
  }

  // --------------------------------------------------------------------------
  // 1. components.json checks
  // --------------------------------------------------------------------------

  Future<void> _checkComponentsJson() async {
    final file = File('flutter_shadcn_kit/lib/registry/manifests/components.json');
    if (!file.existsSync()) {
      _fail('components.json', 'components.json not found at expected path');
      return;
    }

    final content = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final shared = content['shared'] as List<dynamic>? ?? [];

    for (final item in shared) {
      final itemMap = item as Map<String, dynamic>;
      final id = itemMap['id'] as String? ?? '<unknown>';
      final files = itemMap['files'] as List<dynamic>? ?? [];

      for (final f in files) {
        final fileMap = f as Map<String, dynamic>;
        final dest = fileMap['destination'] as String? ?? '';
        if (dest.contains('{sharedPath}/fonts') ||
            RegExp(r'registry/shared/fonts/.*\.(ttf|otf|woff2?)').hasMatch(dest)) {
          final ext = _fontExtension(dest);
          if (ext != null) {
            _fail(
              'components.json',
              'Shared item "$id" declares font binary at shared path: $dest. '
              'Font assets must not be installed under {sharedPath}/fonts/.',
            );
          }
        }
      }
    }
  }

  String? _fontExtension(String path) {
    final lower = path.toLowerCase();
    for (final ext in ['.ttf', '.otf', '.woff', '.woff2']) {
      if (lower.endsWith(ext)) return ext;
    }
    return null;
  }

  // --------------------------------------------------------------------------
  // 2. registries.json checks
  // --------------------------------------------------------------------------

  Future<void> _checkRegistriesJson() async {
    final file = File('../../registry-directory/branch-v1-registry-minimal-init-actions/registries/registries.json');
    if (!file.existsSync()) {
      _fail('registries.json', 'registries.json not found at expected path');
      return;
    }

    final content = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final registries = content['registries'] as List<dynamic>? ?? [];

    for (final reg in registries) {
      final regMap = reg as Map<String, dynamic>;
      final regId = regMap['id'] as String? ?? '<unknown>';
      final init = regMap['init'] as Map<String, dynamic>?;
      if (init == null) continue;

      // No defaultComponents
      if (init.containsKey('defaultComponents')) {
        final dc = init['defaultComponents'];
        if (dc is List && dc.isNotEmpty) {
          _fail(
            'registries.json',
            'Registry "$regId" init declares defaultComponents: ${dc.join(', ')}. '
            'Init must not declare defaultComponents.',
          );
        }
      }

      final actions = init['actions'] as List<dynamic>? ?? [];

      // Check init is minimal
      int copyFileCount = 0;
      for (final action in actions) {
        final act = action as Map<String, dynamic>;
        final type = act['type'] as String? ?? '';

        if (type == 'copyFiles' || type == 'copyDir') {
          final files = act['files'] as List<dynamic>? ?? [];
          copyFileCount += files.length;

          // Check for broad shared/component tree copies
          final base = act['base'] as String? ?? '';
          final destBase = act['destBase'] as String? ?? '';

          if (type == 'copyDir' && (base.contains('shared') || base.contains('components'))) {
            _fail(
              'registries.json',
              'Registry "$regId" init copies entire directory: $base -> $destBase. '
              'Init must not copy broad shared/component trees.',
            );
          }

          // Font/icon assets must go to assets/fonts
          if (_isFontRelated(base) || _isFontRelatedList(files)) {
            final to = act['to'] as String? ?? destBase;
            if (!to.startsWith('assets/fonts') && !destBase.startsWith('assets/fonts')) {
              _fail(
                'registries.json',
                'Registry "$regId" init installs font/icon assets to "$to" instead of assets/fonts/.',
              );
            }
          }
        }

        // Check optional groups default-off
        if (type == 'copyFiles' && act['optional'] == true) {
          final groups = act['groups'] as List<dynamic>? ?? [];
          for (final g in groups) {
            final group = g as Map<String, dynamic>;
            if (group['default'] == true) {
              _fail(
                'registries.json',
                'Registry "$regId" optional group "${group['label']}" has default:true. '
                'Optional font/icon groups must be default-off.',
              );
            }
          }
        }
      }

      if (copyFileCount > 10) {
        _fail(
          'registries.json',
          'Registry "$regId" init copies $copyFileCount files. '
          'Init should be minimal (only path/config messages and required dependency merge).',
          severity: 'WARN',
        );
      }
    }
  }

  bool _isFontRelated(String path) {
    final lower = path.toLowerCase();
    return lower.contains('font') || lower.contains('icon');
  }

  bool _isFontRelatedList(List<dynamic> files) {
    for (final f in files) {
      final path = f.toString().toLowerCase();
      if (path.contains('font') || path.contains('icon')) return true;
      if (_fontExtension(path) != null) return true;
    }
    return false;
  }

  // --------------------------------------------------------------------------
  // 3. Component manifest checks
  // --------------------------------------------------------------------------

  Future<void> _checkComponentManifests() async {
    final componentsDir = Directory('flutter_shadcn_kit/lib/registry/components');
    if (!componentsDir.existsSync()) {
      _fail('component_manifests', 'Components directory not found');
      return;
    }

    // Collect all component ids from meta.json files
    final componentDirs = <String, Directory>{};
    final manifestData = <String, Map<String, dynamic>>{};

    for (final categoryDir in componentsDir.listSync().whereType<Directory>()) {
      for (final compDir in categoryDir.listSync().whereType<Directory>()) {
        final compId = compDir.path.split('/').last;
        final metaFile = File('${compDir.path}/meta.json');
        if (metaFile.existsSync()) {
          componentDirs[compId] = compDir;
          try {
            manifestData[compId] = jsonDecode(await metaFile.readAsString()) as Map<String, dynamic>;
          } catch (e) {
            _fail('component_manifests', 'Failed to parse meta.json for $compId: $e');
          }
        }
      }
    }

    // Check each component's Dart files for imports against manifest
    for (final entry in componentDirs.entries) {
      final compId = entry.key;
      final compDir = entry.value;
      final manifest = manifestData[compId];
      if (manifest == null) continue;

      final legacyDeps = manifest['dependencies'] as Map<String, dynamic>?;
      final declaredShared = _stringList(manifest['shared']) ?? _stringList(legacyDeps?['shared']);
      final declaredDependsOn = _stringList(manifest['dependsOn']) ?? _stringList(legacyDeps?['components']);
      // declaredFiles available for future manifest validation

      // Ensure install-source fields exist (accept legacy nested structure as valid)
      final hasFiles = manifest.containsKey('files');
      final hasShared = manifest.containsKey('shared') || legacyDeps?.containsKey('shared') == true;
      final hasDependsOn = manifest.containsKey('dependsOn') || legacyDeps?.containsKey('components') == true;
      final hasPubspec = manifest.containsKey('pubspec') || legacyDeps?.containsKey('pubspec') == true;
      final hasAssets = manifest.containsKey('assets');
      final hasFonts = manifest.containsKey('fonts');

      if (!hasFiles) {
        _fail('component_manifests', '$compId meta.json missing "files" field', severity: 'WARN');
      }
      if (!hasShared) {
        _fail('component_manifests', '$compId meta.json missing "shared" field', severity: 'WARN');
      }
      if (!hasDependsOn) {
        _fail('component_manifests', '$compId meta.json missing "dependsOn" field', severity: 'WARN');
      }
      if (!hasPubspec) {
        _fail('component_manifests', '$compId meta.json missing "pubspec" field', severity: 'WARN');
      }
      if (!hasAssets) {
        _fail('component_manifests', '$compId meta.json missing "assets" field', severity: 'WARN');
      }
      if (!hasFonts) {
        _fail('component_manifests', '$compId meta.json missing "fonts" field', severity: 'WARN');
      }

      // Scan Dart imports
      final dartFiles = compDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));

      for (final dartFile in dartFiles) {
        final lines = await dartFile.readAsLines();
        for (final line in lines) {
          final trimmed = line.trim();
          if (!trimmed.startsWith('import ')) continue;

          // Check shared imports
          final sharedMatch = RegExp(r'''import\s+['"].*../../../shared/([^'"]+)['"]''').firstMatch(trimmed);
          if (sharedMatch != null) {
            final importedShared = sharedMatch.group(1);
            if (importedShared != null) {
              // Map imported path fragment to shared id heuristically
              final sharedId = _guessSharedIdFromPath(importedShared);
              if (sharedId != null && declaredShared != null && !declaredShared.contains(sharedId)) {
                _fail(
                  'component_manifests',
                  '$compId imports shared/$importedShared but manifest "shared" does not contain "$sharedId".',
                );
              }
            }
          }

          // Check component imports
          final compMatch = RegExp(r'''import\s+['"].*\.\./([^'"]+)['"]''').firstMatch(trimmed);
          if (compMatch != null) {
            final importPath = compMatch.group(1)!;
            // Heuristic: if import goes up to another component category
            if (importPath.startsWith('../') || importPath.startsWith('../../')) {
              final parts = importPath.split('/');
              if (parts.length >= 2) {
                final maybeCompId = parts.lastWhere(
                  (p) => p.isNotEmpty && !p.endsWith('.dart'),
                  orElse: () => '',
                );
                if (maybeCompId.isNotEmpty &&
                    maybeCompId != compId &&
                    componentDirs.containsKey(maybeCompId) &&
                    declaredDependsOn != null &&
                    !declaredDependsOn.contains(maybeCompId)) {
                  _fail(
                    'component_manifests',
                    '$compId imports component "$maybeCompId" but manifest "dependsOn" does not contain it.',
                  );
                }
              }
            }
          }
        }
      }
    }
  }

  List<String>? _stringList(dynamic value) {
    if (value is List) return value.whereType<String>().toList();
    if (value == null) return null;
    return [];
  }

  String? _guessSharedIdFromPath(String path) {
    // Heuristic mapping from common paths to shared ids
    final normalized = path.toLowerCase().replaceAll('.dart', '');
    if (normalized.contains('/theme/') || normalized == 'theme') return 'theme';
    if (normalized.contains('/color_extensions') || normalized == 'color_extensions') return 'color_extensions';
    if (normalized.contains('/clickable') || normalized == 'clickable') return 'clickable';
    if (normalized.contains('/form_control') || normalized == 'form_control') return 'form_control';
    if (normalized.contains('/form_value_supplier') || normalized == 'form_value_supplier') return 'form_value_supplier';
    if (normalized.contains('/menu_group') || normalized == 'menu_group') return 'menu_group';
    if (normalized.contains('/style_value') || normalized == 'style_value') return 'style_value';
    if (normalized.contains('/border_utils') || normalized == 'border_utils') return 'border_utils';
    if (normalized.contains('/constants') || normalized == 'constants') return 'constants';
    if (normalized.contains('/animation_queue') || normalized == 'animation_queue') return 'animation_queue';
    if (normalized.contains('/wrap_utils') || normalized == 'wrap_utils') return 'wrap_utils';
    if (normalized.contains('/animated_value_builder') || normalized == 'animated_value_builder') return 'animated_value_builder';
    if (normalized.contains('/slider_value') || normalized == 'slider_value') return 'slider_value';
    if (normalized.contains('/util') || normalized == 'util') return 'util';
    if (normalized.contains('/controlled_animation') || normalized == 'controlled_animation') return 'controlled_animation';
    if (normalized.contains('/text_input_utils') || normalized == 'text_input_utils') return 'text_input_utils';
    if (normalized.contains('/chip_utils') || normalized == 'chip_utils') return 'chip_utils';
    if (normalized.contains('/geometry_extensions') || normalized == 'geometry_extensions') return 'geometry_extensions';
    if (normalized.contains('/hidden') || normalized == 'hidden') return 'hidden';
    if (normalized.contains('/overlay') || normalized == 'overlay') return 'overlay';
    if (normalized.contains('/hover') || normalized == 'hover') return 'hover';
    if (normalized.contains('/subfocus') || normalized == 'subfocus') return 'subfocus';
    if (normalized.contains('/basic_layout') || normalized == 'basic_layout') return 'basic_layout';
    if (normalized.contains('/text_modifiers') || normalized == 'text_modifiers') return 'text_modifiers';
    if (normalized.contains('/icon_extensions') || normalized == 'icon_extensions') return 'icon_extensions';
    if (normalized.contains('/localizations') || normalized == 'localizations') return 'localizations';
    if (normalized.contains('/localizations_extensions') || normalized == 'localizations_extensions') return 'localizations_extensions';
    if (normalized.contains('/fade_scroll') || normalized == 'fade_scroll') return 'fade_scroll';
    if (normalized.contains('/keyboard_shortcut_utils') || normalized == 'keyboard_shortcut_utils') return 'keyboard_shortcut_utils';
    if (normalized.contains('/resizer') || normalized == 'resizer') return 'resizer';
    if (normalized.contains('/lucide_icons') || normalized == 'lucide_icons') return 'lucide_icons';
    if (normalized.contains('/radix_icons') || normalized == 'radix_icons') return 'radix_icons';
    if (normalized.contains('/outlined_container') || normalized == 'outlined_container') return 'outlined_container';
    if (normalized.contains('/sheet_overlay') || normalized == 'sheet_overlay') return 'sheet_overlay';
    if (normalized.contains('/focus_outline') || normalized == 'focus_outline') return 'focus_outline';
    if (normalized.contains('/axis') || normalized == 'axis') return 'axis';
    if (normalized.contains('/phone_number') || normalized == 'phone_number') return 'phone_number';
    return null;
  }

  // --------------------------------------------------------------------------
  // 4. Theme install entries check
  // --------------------------------------------------------------------------

  Future<void> _checkThemeInstallEntries() async {
    final file = File('flutter_shadcn_kit/lib/registry/manifests/components.json');
    if (!file.existsSync()) return;

    final content = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final shared = content['shared'] as List<dynamic>? ?? [];

    for (final item in shared) {
      final itemMap = item as Map<String, dynamic>;
      final id = itemMap['id'] as String? ?? '';
      if (!id.contains('theme') && !id.contains('preset')) continue;

      final files = itemMap['files'] as List<dynamic>? ?? [];
      bool copiesEntireFolder = false;
      String? folderPath;

      for (final f in files) {
        final fileMap = f as Map<String, dynamic>;
        final source = fileMap['source'] as String? ?? '';
        // If it copies many files from the same generated theme folder
        if (source.contains('theme/generated/') && source.endsWith('.dart')) {
          final parts = source.split('/');
          if (parts.length > 3) {
            final themeFolder = parts.sublist(0, parts.length - 1).join('/');
            if (folderPath == null) {
              folderPath = themeFolder;
            } else if (folderPath != themeFolder) {
              copiesEntireFolder = true;
            }
          }
        }
      }

      if (copiesEntireFolder) {
        _fail(
          'theme_install',
          'Shared item "$id" appears to copy files from multiple generated theme folders. '
          'Theme installation should write only the selected theme manifest files.',
          severity: 'WARN',
        );
      }
    }
  }
}
