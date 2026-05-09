// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Table;

import '../table/table.dart' as shadcn;

/// TablePreview defines a reusable type for this registry module.
class TablePreview extends StatelessWidget {
  const TablePreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 420,
          child: shadcn.Table(
            rows: [
              /// Creates a `shadcn.TableHeader` instance.
              shadcn.TableHeader(
                cells: [
                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Name')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Role')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Status')),
                ],
              ),

              /// Creates a `shadcn.TableRow` instance.
              shadcn.TableRow(
                cells: [
                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Avery')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Designer')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Active')),
                ],
              ),

              /// Creates a `shadcn.TableRow` instance.
              shadcn.TableRow(
                cells: [
                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Jordan')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Engineer')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Active')),
                ],
              ),

              /// Creates a `shadcn.TableRow` instance.
              shadcn.TableRow(
                cells: [
                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Casey')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('PM')),

                  /// Creates a `shadcn.TableCell` instance.
                  shadcn.TableCell(child: const Text('Away')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
