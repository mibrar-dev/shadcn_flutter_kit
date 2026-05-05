import 'dart:io';

import 'registry_barrel.dart';

void main() {
  final root = findRegistryRoot(Directory.current);
  if (root == null) {
    stderr.writeln(
      'Unable to locate flutter_shadcn_kit root from ${Directory.current.path}.',
    );
    exitCode = 1;
    return;
  }

  final output = File('${root.path}/lib/flutter_shadcn_kit.dart');
  output.writeAsStringSync(buildRootBarrel(root));
  stdout.writeln('Generated ${output.path}.');
}
