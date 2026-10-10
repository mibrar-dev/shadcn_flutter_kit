// Home showcase: navigation cards (P6-H1).
//
// Extends the Theme Studio blocks (`studio_blocks/studio_list.dart`,
// `studio_blocks/studio_form.dart`): the grouped sidebar nav, the
// breadcrumb + pagination row and the release stepper, re-shelled in
// [CollageCard] for the home wall.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/breadcrumb/breadcrumb.dart';
import '../ui/shadcn/components/checkbox/checkbox.dart';
import '../ui/shadcn/components/divider/divider.dart';
import '../ui/shadcn/components/pagination/pagination.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'studio_blocks/studio_card.dart';

/// The sidebar nav: grouped links exactly like the reference's rail.
class HomeSidebarCard extends StatelessWidget {
  /// Creates the card.
  const HomeSidebarCard({super.key});

  static const List<(String, List<String>)> groups = <(String, List<String>)>[
    ('Overview', <String>['Dashboard', 'Transactions', 'Investments']),
    ('Account', <String>['Profile', 'Billing', 'Notifications']),
    ('Support', <String>['Help Center', 'Status']),
  ];

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Workspace',
      subtitle: 'Jump anywhere in the app.',
      children: <Widget>[
        for (final (String group, List<String> items) in groups) ...<Widget>[
          StudioCaption(group),
          const Gap(4),
          for (int i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: _HomeNavItem(
                label: items[i],
                active: group == 'Overview' && i == 0,
              ),
            ),
          const Gap(10),
        ],
      ],
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({required this.label, required this.active});

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

/// `Browse`: a breadcrumb over a `pagination` row, both registry components.
class HomeBrowseCard extends StatefulWidget {
  /// Creates the card.
  const HomeBrowseCard({super.key});

  @override
  State<HomeBrowseCard> createState() => _HomeBrowseCardState();
}

class _HomeBrowseCardState extends State<HomeBrowseCard> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Browse',
      subtitle: 'Reports and statements',
      children: <Widget>[
        const Breadcrumb(
          children: <Widget>[
            Text('Library'),
            Text('Account options'),
            Text('Reports'),
          ],
        ),
        const Gap(16),
        const Divider(),
        const Gap(12),
        StudioHelper('Page $_page of 8'),
        const Gap(8),
        // `Pagination` measures its window with an intrinsic width, so it
        // cannot shrink below its widest row. Clip-free horizontal scroll
        // keeps it reachable in a narrow column instead of overflowing.
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Pagination(
              page: _page,
              totalPages: 8,
              onPageChanged: (int next) => setState(() => _page = next),
            ),
          ),
        ),
      ],
    );
  }
}

/// `Release checklist`: registry checkboxes with a progress summary.
///
/// Note: the registry `Stepper` animates step changes through an
/// `AnimatedSwitcher`, and the motion suite requires the landing page to
/// hold exactly one of those (the mobile popper's). The checklist story is
/// therefore told with checkboxes; the stepper is covered on its component
/// page.
class HomeStepperCard extends StatefulWidget {
  /// Creates the card.
  const HomeStepperCard({super.key});

  @override
  State<HomeStepperCard> createState() => _HomeStepperCardState();
}

class _HomeStepperCardState extends State<HomeStepperCard> {
  static const List<String> steps = <String>[
    'Upload master',
    'Add metadata',
    'Publish release',
  ];

  final Set<int> _done = <int>{0, 1};

  @override
  Widget build(BuildContext context) {
    return CollageCard(
      title: 'Release checklist',
      subtitle: '${_done.length} of ${steps.length} steps done',
      children: <Widget>[
        for (int i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: _done.contains(i)
                      ? CheckboxValue.checked
                      : CheckboxValue.unchecked,
                  onChanged: (CheckboxValue value) => setState(() {
                    if (value == CheckboxValue.checked) {
                      _done.add(i);
                    } else {
                      _done.remove(i);
                    }
                  }),
                ),
                const Gap(12),
                Expanded(child: Text(steps[i])),
              ],
            ),
          ),
      ],
    );
  }
}
