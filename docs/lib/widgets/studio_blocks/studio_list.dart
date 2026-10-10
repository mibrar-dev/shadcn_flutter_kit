// The list blocks of the Theme Studio canvas: `avatar`-led rows, a role
// select, a notification list with switches, the sidebar nav and the upcoming
// payments list.
//
// `Avatar`, `Select` and `Switch` are the registry components doing the work;
// the rows themselves are layout only.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/components/avatar/avatar.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/select/select.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_card.dart';

/// `Recent Transactions`: a list of avatar rows with a category caption.
class StudioTransactionsCard extends StatelessWidget {
  /// Creates the card.
  const StudioTransactionsCard({super.key});

  static const List<(String, String, IconData, String, bool)> rows =
      <(String, String, IconData, String, bool)>[
        (
          'Blue Bottle Coffee',
          'Food & Drink',
          LucideIcons.coffee,
          r'Today, 10:24 AM -$6.50',
          false,
        ),
        (
          'Whole Foods Market',
          'Groceries',
          LucideIcons.shoppingCart,
          r'Yesterday -$142.30',
          false,
        ),
        (
          'Stripe Payout',
          'Income',
          LucideIcons.landmark,
          r'Oct 12 +$4,200.00',
          true,
        ),
        (
          'Uber Technologies',
          'Transport',
          LucideIcons.car,
          r'Oct 11 -$24.10',
          false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Recent Transactions',
      subtitle: 'Your latest account activity.',
      trailing: const Button(
        variant: ButtonVariant.ghost,
        size: ButtonSize.sm,
        onPressed: null,
        child: Text('View All'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: _StudioRowDivider(),
              ),
            _TransactionRow(entry: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.entry});

  final (String, String, IconData, String, bool) entry;

  @override
  Widget build(BuildContext context) {
    final String name = entry.$1;
    final String category = entry.$2;
    final IconData icon = entry.$3;
    final String amount = entry.$4;
    final bool inbound = entry.$5;
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Avatar(initials: _initials(name), size: 32),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(name, style: theme.typography.small),
                Text(
                  category,
                  style: theme.typography.small.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Icon(icon, size: 14, color: theme.colors.mutedForeground),
          const Gap(12),
          SizedBox(
            width: 96,
            child: Text(
              amount,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.typography.small.copyWith(
                fontWeight: inbound ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A hairline between rows, themed like the divider component's default.
class _StudioRowDivider extends StatelessWidget {
  const _StudioRowDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: ColoredBox(color: ShadcnTheme.of(context).colors.border),
    );
  }
}

/// `Team Members`: avatars with a role `Select` per row.
class StudioTeamMembersCard extends StatelessWidget {
  /// Creates the card.
  const StudioTeamMembersCard({super.key});

  static const List<(String, String)> members = <(String, String)>[
    ('Maya Okafor', 'Admin'),
    ('Leo Marchetti', 'Editor'),
  ];

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      title: 'Team Members',
      subtitle: 'Four people have access to this workspace.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final (String name, String role) in members)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  Avatar(initials: _initials(name), size: 34),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(12),
                  SizedBox(width: 116, child: _StudioRoleSelect(role: role)),
                ],
              ),
            ),
          const Gap(8),
          const Button(
            variant: ButtonVariant.outline,
            size: ButtonSize.sm,
            onPressed: null,
            child: Text('Invite teammate'),
          ),
        ],
      ),
    );
  }
}

class _StudioRoleSelect extends StatefulWidget {
  const _StudioRoleSelect({required this.role});

  final String role;

  @override
  State<_StudioRoleSelect> createState() => _StudioRoleSelectState();
}

class _StudioRoleSelectState extends State<_StudioRoleSelect> {
  static const List<String> roles = <String>[
    'Admin',
    'Editor',
    'Analyst',
    'Viewer',
  ];

  late String _role = widget.role;

  @override
  Widget build(BuildContext context) {
    return Select<String>(
      value: _role,
      onChanged: (String? next) => setState(() => _role = next ?? _role),
      items: <Widget>[
        for (final String role in roles)
          SelectItem<String>(value: role, child: Text(role)),
      ],
      itemBuilder: (BuildContext context, String value) => Text(value),
    );
  }
}

/// The sidebar nav: grouped links exactly like the reference's rail.
class StudioSidebarNavCard extends StatelessWidget {
  /// Creates the card.
  const StudioSidebarNavCard({super.key});

  static const List<(String, List<String>)> groups = <(String, List<String>)>[
    ('Overview', <String>['Dashboard', 'Transactions', 'Investments']),
    ('Account', <String>['Profile', 'Billing', 'Notifications']),
    ('Support', <String>['Help Center', 'Status']),
  ];

  @override
  Widget build(BuildContext context) {
    return StudioCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final (String group, List<String> items) in groups) ...<Widget>[
            StudioCaption(group),
            const Gap(4),
            for (int i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: _StudioNavItem(
                  label: items[i],
                  active: group == 'Overview' && i == 0,
                ),
              ),
            const Gap(10),
          ],
        ],
      ),
    );
  }
}

class _StudioNavItem extends StatelessWidget {
  const _StudioNavItem({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? theme.colors.accent : null,
          borderRadius: theme.borderRadiusSm,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: theme.typography.small.copyWith(
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active
                        ? theme.colors.accentForeground
                        : theme.colors.mutedForeground,
                  ),
                ),
              ),
              if (active)
                Icon(
                  LucideIcons.chevronRight,
                  size: 14,
                  color: theme.colors.accentForeground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The two-letter initials an `Avatar` falls back to.
String _initials(String name) => name
    .split(' ')
    .where((String part) => part.isNotEmpty)
    .take(2)
    .map((String part) => part[0])
    .join()
    .toUpperCase();
