import 'dart:convert';
import 'dart:io';

typedef JsonMap = Map<String, dynamic>;

const String componentRegistryFolder = 'registry';

const Set<String> _excludedComponentTopLevelFiles = <String>{
  '.DS_Store',
  'GETTING_STARTED.md',
  'README.md',
  'preview.dart',
  'meta.json',
  'theme.schema.json',
};

String componentRelativePath({
  required Directory entryDir,
  required File file,
}) {
  return file.path.substring(entryDir.path.length + 1).replaceAll('\\', '/');
}

bool shouldIncludeComponentSourceFile(String relativePath) {
  final normalized = relativePath.replaceAll('\\', '/');
  final fileName = normalized.split('/').last;

  if (normalized.startsWith('$componentRegistryFolder/')) return false;
  if (_excludedComponentTopLevelFiles.contains(fileName)) return false;
  if (fileName.endsWith('_preview.dart')) return false;
  if (fileName.endsWith('.meta.json')) return false;

  return true;
}

List<String> listComponentSourceFilesRelative(Directory entryDir) {
  final files = <String>[];
  for (final entity in entryDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final rel = componentRelativePath(entryDir: entryDir, file: entity);
    if (!shouldIncludeComponentSourceFile(rel)) continue;
    files.add(rel);
  }
  files.sort();
  return files;
}

bool shouldIncludeSharedSourceFile(String relativePath) {
  final normalized = relativePath.replaceAll('\\', '/');
  final fileName = normalized.split('/').last;

  if (fileName == '.DS_Store') return false;
  if (fileName == 'README.md') return false;
  if (fileName == 'GETTING_STARTED.md') return false;
  if (normalized.startsWith('theme/generated/') &&
      fileName.endsWith('.install.txt')) {
    return false;
  }
  if (fileName == 'preview.dart' || fileName.endsWith('_preview.dart')) {
    return false;
  }

  return true;
}

List<String> listSharedSourceFilesRelative(Directory sharedDir) {
  final files = <String>[];
  for (final entity in sharedDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final rel = entity.path
        .substring(sharedDir.path.length + 1)
        .replaceAll('\\', '/');
    if (!shouldIncludeSharedSourceFile(rel)) continue;
    files.add(rel);
  }
  files.sort();
  return files;
}

class ComponentMetadataPaths {
  ComponentMetadataPaths({required this.entryDir, required this.id});

  final Directory entryDir;
  final String id;

  Directory get legacyMetadataDir =>
      Directory('${entryDir.path}/$componentRegistryFolder');

  File get canonicalMeta => File('${entryDir.path}/meta.json');
  File get legacyMeta => File('${legacyMetadataDir.path}/meta.json');

  File get canonicalReadmeMeta => File('${entryDir.path}/$id.meta.json');
  File get legacyReadmeMeta => File('${legacyMetadataDir.path}/$id.meta.json');

  File get canonicalThemeSchema => File('${entryDir.path}/theme.schema.json');
  File get legacyThemeSchema =>
      File('${legacyMetadataDir.path}/theme.schema.json');
}

File preferredFile({required File canonical, required File legacy}) {
  if (canonical.existsSync()) return canonical;
  return legacy;
}

JsonMap readJsonOrEmpty({required File canonical, required File legacy}) {
  final file = preferredFile(canonical: canonical, legacy: legacy);
  if (!file.existsSync()) return <String, dynamic>{};
  return jsonDecode(file.readAsStringSync()) as JsonMap;
}

void writeJsonMirrored({
  required File canonical,
  required File legacy,
  required Object data,
}) {
  final encoder = const JsonEncoder.withIndent('  ');
  final payload = '${encoder.convert(data)}\n';

  canonical.parent.createSync(recursive: true);
  canonical.writeAsStringSync(payload);
  if (legacy.existsSync()) {
    legacy.deleteSync();
  }
  _deleteDirIfEmpty(legacy.parent);
}

void mirrorExistingFile({required File canonical, required File legacy}) {
  if (!canonical.existsSync() && !legacy.existsSync()) return;

  final source = canonical.existsSync() ? canonical : legacy;
  final payload = source.readAsStringSync();

  canonical.parent.createSync(recursive: true);
  canonical.writeAsStringSync(payload);
  if (legacy.existsSync()) {
    legacy.deleteSync();
  }
  _deleteDirIfEmpty(legacy.parent);
}

void deleteLegacyMetadata(ComponentMetadataPaths metadata) {
  for (final file in <File>[
    metadata.legacyMeta,
    metadata.legacyReadmeMeta,
    metadata.legacyThemeSchema,
  ]) {
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
  _deleteDirIfEmpty(metadata.legacyMetadataDir);
}

void _deleteDirIfEmpty(Directory directory) {
  if (!directory.existsSync()) return;
  if (directory.listSync().isEmpty) {
    directory.deleteSync();
  }
}

Directory? findSiblingDocsRegistryRoot(Directory repoRoot) {
  final candidates = <String>{
    Directory('${repoRoot.parent.path}/docs/lib/ui/shadcn').absolute.path,
    Directory('${repoRoot.path}/../docs/lib/ui/shadcn').absolute.path,
  };
  for (final candidate in candidates) {
    final dir = Directory(candidate);
    if (dir.existsSync()) {
      return dir;
    }
  }
  return null;
}

void syncDocsRegistryMetadata({
  required Directory registryDir,
  required Directory docsRegistryRoot,
}) {
  final canonicalMetaRelativePaths = <String>{};

  void mirrorMetaTree(String bucket) {
    final canonicalRoot = Directory('${registryDir.path}/$bucket');
    final docsRoot = Directory('${docsRegistryRoot.path}/$bucket');

    if (!canonicalRoot.existsSync()) return;
    for (final entity in canonicalRoot.listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalizedPath = entity.path.replaceAll('\\', '/');
      if (!normalizedPath.endsWith('/meta.json')) continue;
      final relativePath = entity.path
          .substring(registryDir.path.length + 1)
          .replaceAll('\\', '/');
      canonicalMetaRelativePaths.add(relativePath);
      final target = File('${docsRegistryRoot.path}/$relativePath');
      target.parent.createSync(recursive: true);
      target.writeAsStringSync(entity.readAsStringSync());
    }

    if (!docsRoot.existsSync()) return;
    for (final entity in docsRoot.listSync(recursive: true)) {
      if (entity is! File) continue;
      final normalizedPath = entity.path.replaceAll('\\', '/');
      if (!normalizedPath.endsWith('/meta.json')) continue;
      final relativePath = entity.path
          .substring(docsRegistryRoot.path.length + 1)
          .replaceAll('\\', '/');
      if (canonicalMetaRelativePaths.contains(relativePath)) continue;
      entity.deleteSync();
      _deleteDirIfEmpty(entity.parent);
    }
  }

  mirrorMetaTree('components');
  mirrorMetaTree('composites');

  final manifestsDir = Directory('${registryDir.path}/manifests');
  final docsManifestsDir = Directory('${docsRegistryRoot.path}/manifests');
  docsManifestsDir.createSync(recursive: true);
  for (final fileName in const ['components.json', 'components.schema.json']) {
    final source = File('${manifestsDir.path}/$fileName');
    if (!source.existsSync()) continue;
    final target = File('${docsManifestsDir.path}/$fileName');
    target.writeAsStringSync(source.readAsStringSync());
  }
}
