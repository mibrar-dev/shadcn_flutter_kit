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

class _Dashboard01Order {
  const _Dashboard01Order(this.customer, this.status, this.method, this.amount);

  final String customer;
  final String status;
  final String method;
  final String amount;

  /// Index into `theme.colors.chartColors` for the status pill.
  int get chartIndex => switch (status) {
    'Paid' => 1,
    'Pending' => 2,
    _ => 0,
  };
}

const List<_Dashboard01Order> _dashboard01Orders = <_Dashboard01Order>[
  _Dashboard01Order('Olivia Martin', 'Paid', 'Visa', '\$1,999.00'),
  _Dashboard01Order('Jackson Lee', 'Pending', 'Mastercard', '\$39.00'),
  _Dashboard01Order('Isabella Nguyen', 'Refunded', 'PayPal', '\$299.00'),
  _Dashboard01Order('William Kim', 'Paid', 'Visa', '\$99.00'),
  _Dashboard01Order('Sofia Davis', 'Paid', 'Amex', '\$499.00'),
];

/// Recent transactions with a working customer filter.
class Dashboard01Recent extends StatefulWidget {
  /// Creates the table card.
  const Dashboard01Recent({super.key});

  @override
  State<Dashboard01Recent> createState() => _Dashboard01RecentState();
}

class _Dashboard01RecentState extends State<Dashboard01Recent> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String needle = _filter.trim().toLowerCase();
    final List<_Dashboard01Order> rows = needle.isEmpty
        ? _dashboard01Orders
        : _dashboard01Orders
              .where(
                (_Dashboard01Order order) =>
                    order.customer.toLowerCase().contains(needle),
              )
              .toList();
    return Card(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget filter = SizedBox(
                  width: 220,
                  child: Input(
                    hintText: 'Filter transactions',
                    onChanged: (String value) =>
                        setState(() => _filter = value),
                  ),
                );
                // The title and the 220px filter share one row from 560px;
                // below that the filter takes its own row instead of
                // squeezing the title off-screen.
                if (constraints.maxWidth >= 560) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Transactions',
                          style: theme.typography.textLarge,
                        ),
                      ),
                      Gap(theme.spacing.lg),
                      filter,
                    ],
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Transactions', style: theme.typography.textLarge),
                    Gap(theme.spacing.md),
                    filter,
                  ],
                );
              },
            ),
          ),
          const Divider(),
          if (rows.isEmpty)
            Padding(
              padding: EdgeInsets.all(theme.spacing.xl),
              child: Text(
                'No transactions match "$_filter".',
                style: theme.typography.textSmall.copyWith(
                  color: theme.colors.mutedForeground,
                ),
              ),
            )
          else
            ShadcnTable(
              defaultRowHeight: const FixedTableSize(48),
              columnWidths: const <int, TableSize>{
                0: FlexTableSize(flex: 2),
                1: FlexTableSize(),
                2: FlexTableSize(),
                3: FixedTableSize(110),
              },
              rows: <ShadcnTableRow>[
                const ShadcnTableHeader(
                  cells: <ShadcnTableCell>[
                    ShadcnTableCell(child: Text('Customer')),
                    ShadcnTableCell(child: Text('Status')),
                    ShadcnTableCell(child: Text('Method')),
                    ShadcnTableCell(child: Text('Amount')),
                  ],
                ),
                for (final _Dashboard01Order order in rows)
                  ShadcnTableRow(
                    cells: <ShadcnTableCell>[
                      ShadcnTableCell(child: Text(order.customer)),
                      ShadcnTableCell(
                        child: _Dashboard01Pill(
                          order.status,
                          chartIndex: order.chartIndex,
                        ),
                      ),
                      ShadcnTableCell(child: Text(order.method)),
                      ShadcnTableCell(child: Text(order.amount)),
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
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
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
