/// Thrown when the registry tree cannot produce a valid manifest.
class ManifestBuildException implements Exception {
  ManifestBuildException(this.message);

  final String message;

  @override
  String toString() => 'registry manifest: $message';
}
