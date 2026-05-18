import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'components manifest does not install font assets as shared lib files',
    () {
      final manifest =
          jsonDecode(
                File(
                  'lib/registry/manifests/components.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;

      final shared = (manifest['shared'] as List<dynamic>)
          .whereType<Map<String, dynamic>>();
      final fontFiles = <String>[];
      for (final entry in shared) {
        final files = (entry['files'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>();
        for (final file in files) {
          final source = file['source'];
          final destination = file['destination'];
          if (source is String && source.startsWith('registry/shared/fonts/')) {
            fontFiles.add(source);
          }
          if (destination is String &&
              destination.contains('{sharedPath}/fonts')) {
            fontFiles.add(destination);
          }
        }
      }

      expect(fontFiles, isEmpty);
    },
  );
}
