// Finds the public widget class of a block entry file with
// `package:analyzer` (never regex), so the deferred preview registry can only
// point at a class that exists.
//
// A block's public widget IS its preview (P6-B1): `dashboard-01` ships
// `Dashboard01` from `dashboard_01.dart` and nothing else public. The lookup
// therefore takes the first public `StatelessWidget`/`StatefulWidget`
// declaration in the entry file and fails loudly when the file ships none —
// the docs preview would otherwise silently render nothing.

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'registry_scan.dart';

/// The block widget class declared in [source].
String findBlockWidgetClass({required String source, required String blockId}) {
  final ParseStringResult result = parseString(
    content: source,
    throwIfDiagnostics: false,
  );
  for (final CompilationUnitMember member in result.unit.declarations) {
    if (member is! ClassDeclaration) {
      continue;
    }
    final String name = member.namePart.typeName.lexeme;
    if (name.startsWith('_')) {
      continue;
    }
    final String base = member.extendsClause?.superclass.toSource() ?? '';
    if (base == 'StatelessWidget' || base == 'StatefulWidget') {
      return name;
    }
  }
  throw RegistryScanException(
    'block $blockId: no public widget class in the entry file',
  );
}
