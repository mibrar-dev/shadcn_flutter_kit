// The list and misc blocks of the Theme Studio canvas: the reference's
// `Recent Transactions` list and the `Distribute Track` empty state.
//
// `Avatar` (registry) supplies the row initials, and `EmptyState` supplies the
// icon container, title, copy and CTA the reference shows.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/avatar/avatar.dart';
import '../../ui/shadcn/components/badge/badge.dart';
import '../../ui/shadcn/components/empty_state/empty_state.dart';
import '../../ui/shadcn/components/table/table.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';

/// `Recent Transactions`: a list of avatar rows with a category caption.
class StudioTransactionsCard extends StatelessWidget {
  /// Creates the card.
  const StudioTransactionsCard({super.key});

  static const List<(String, String, IconData)> rows =
      <(String, String, IconData)>[
        ('Blue Bottle Coffee', 'Food & Drink', LucideIcons.coffee),
        ('Whole Foods Market', 'Groceries', LucideIcons.shoppingCart),
        ('Stripe Payout', 'Income', LucideIcons.landmark),
        ('Uber Technologies', 'Transport', LucideIcons.car),
      ];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return StudioCard(
      title: 'Recent Transactions',
      subtitle: 'Your latest account activity.',
      child: Column(
        children: <Widget>[
          for (final (String name, String category, IconData icon) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: <Widget>[
                  Avatar(initials: _initials(name), size: 32),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name, style: theme.typography.small),
                        Text(
                          category,
                          style: theme.typography.small.copyWith(
                            fontSize: 12,
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(icon, size: 14, color: theme.colors.mutedForeground),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// `Distribute Track`: the reference's empty state with its CTA.
class StudioEmptyCard extends StatelessWidget {
  /// Creates the card.
  const StudioEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const StudioCard(
      padding: EdgeInsets.all(0),
      child: EmptyState(
        variant: EmptyStateVariant.empty,
        size: EmptyStateSize.compact,
        icon: Icon(LucideIcons.plus, size: 18),
        title: Text('Distribute Track'),
        description: Text(
          'Upload your first master to start reaching listeners on Spotify, '
          'Apple Music, and more.',
          textAlign: TextAlign.center,
        ),
        primaryAction: EmptyStateAction(label: 'Create Release'),
      ),
    );
  }
}

/// A compact registry table block (rows, header and badges).
class StudioTableCard extends StatelessWidget {
  /// Creates the card.
  const StudioTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      padding: const EdgeInsets.all(0),
      title: 'Team',
      child: const ShadcnTable(
        defaultColumnWidth: FlexTableSize(),
        rows: <ShadcnTableRow>[
          ShadcnTableHeader(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Member')),
              ShadcnTableCell(child: Text('Role')),
              ShadcnTableCell(child: Text('Status')),
            ],
          ),
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Maya')),
              ShadcnTableCell(child: Text('Admin')),
              ShadcnTableCell(child: Text('Active')),
            ],
          ),
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(child: Text('Leo')),
              ShadcnTableCell(child: Text('Editor')),
              ShadcnTableCell(child: Text('Invited')),
            ],
          ),
        ],
      ),
    );
  }
}

/// Two small badge chips, so a preset that changes `secondary`/`outline` shows.
class StudioBadgeCard extends StatelessWidget {
  /// Creates the card.
  const StudioBadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Status',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: const <Widget>[
          Badge(variant: BadgeVariant.secondary, child: Text('Draft')),
          Badge(variant: BadgeVariant.outline, child: Text('Review')),
          Badge(variant: BadgeVariant.destructive, child: Text('Overdue')),
        ],
      ),
    );
  }
}

String _initials(String name) => name
    .split(' ')
    .where((String part) => part.isNotEmpty)
    .take(2)
    .map((String part) => part[0])
    .join()
    .toUpperCase();
