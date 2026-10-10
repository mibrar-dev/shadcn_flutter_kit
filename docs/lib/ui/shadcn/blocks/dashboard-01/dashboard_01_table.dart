// The `dashboard-01` block, part 2: the recent-transactions table and the
// status pill it uses. Imported by `dashboard_01.dart`; a block never imports
// another block.

import 'package:flutter/widgets.dart';

import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/input/input.dart';
import '../../components/table/table.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

class Dashboard01Recent extends StatelessWidget {
  const Dashboard01Recent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Card(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Transactions',
                    style: theme.typography.textLarge,
                  ),
                ),
                Gap(spacing.lg),
                const SizedBox(
                  width: 220,
                  child: Input(hintText: 'Filter transactions'),
                ),
              ],
            ),
          ),
          const Divider(),
          ShadcnTable(
            defaultRowHeight: const FixedTableSize(48),
            columnWidths: const <int, TableSize>{
              0: FlexTableSize(flex: 2),
              1: FlexTableSize(),
              2: FlexTableSize(),
              3: FixedTableSize(110),
            },
            rows: const <ShadcnTableRow>[
              ShadcnTableHeader(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Customer')),
                  ShadcnTableCell(child: Text('Status')),
                  ShadcnTableCell(child: Text('Method')),
                  ShadcnTableCell(child: Text('Amount')),
                ],
              ),
              ShadcnTableRow(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Olivia Martin')),
                  ShadcnTableCell(
                    child: _Dashboard01Pill('Paid', chartIndex: 1),
                  ),
                  ShadcnTableCell(child: Text('Visa')),
                  ShadcnTableCell(child: Text('\$1,999.00')),
                ],
              ),
              ShadcnTableRow(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Jackson Lee')),
                  ShadcnTableCell(
                    child: _Dashboard01Pill('Pending', chartIndex: 2),
                  ),
                  ShadcnTableCell(child: Text('Mastercard')),
                  ShadcnTableCell(child: Text('\$39.00')),
                ],
              ),
              ShadcnTableRow(
                cells: <ShadcnTableCell>[
                  ShadcnTableCell(child: Text('Isabella Nguyen')),
                  ShadcnTableCell(
                    child: _Dashboard01Pill('Refunded', chartIndex: 0),
                  ),
                  ShadcnTableCell(child: Text('PayPal')),
                  ShadcnTableCell(child: Text('\$299.00')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A status pill: a chart-token tint on a transparent fill, so it re-themes
/// with the preset instead of hard-coding a colour.
class _Dashboard01Pill extends StatelessWidget {
  const _Dashboard01Pill(this.label, {required this.chartIndex});

  final String label;

  /// Index into `theme.colors.chartColors`.
  final int chartIndex;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colors.chartColors[chartIndex % 5].withValues(alpha: 0.16),
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.chartColors[chartIndex % 5]),
      ),
      child: Text(
        label,
        style: theme.typography.xSmall.copyWith(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
