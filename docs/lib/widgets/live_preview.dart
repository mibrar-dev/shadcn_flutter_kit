// The live preview area of the themes page (spec §2.7): a grid of registry
// cards (button, input, switch, badge, card) that re-theme live through
// AnimatedShadcnTheme when the preset, mode or radius changes. The preview
// is the proof that the theme layer drives every component.

import 'package:flutter/widgets.dart';

import '../state/docs_state.dart';
import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/card/card.dart';
import '../ui/shadcn/components/input/input.dart';
import '../ui/shadcn/components/switch/switch.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import '../motion/ease.dart';
import '../motion/motion_scope.dart';

/// The live preview area: registry components re-theming live.
class LivePreview extends StatelessWidget {
  /// Creates the preview.
  const LivePreview({super.key, required this.state});

  /// The docs theme state.
  final DocsState state;

  @override
  Widget build(BuildContext context) {
    // The preview shares the viewport with the 192 px rail, so below `sm`
    // (375 px checklist) every horizontal row switches to wrapping/stacked
    // layout instead of overflowing.
    final bool narrow = MediaQuery.sizeOf(context).width < 640;
    return AnimatedShadcnTheme(
      data: state.theme,
      duration: context.motionDuration(kDurationTheme),
      curve: kEaseOutExpo,
      child: ColoredBox(
        color: state.theme.colors.background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: EdgeInsets.all(narrow ? 16 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Card row.
                  Card(
                    padding: EdgeInsets.all(narrow ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Create project',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: state.theme.colors.foreground,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Deploy your new project in one click.',
                          style: TextStyle(
                            fontSize: 14,
                            color: state.theme.colors.mutedForeground,
                          ),
                        ),
                        const Gap(16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            Button(
                              variant: ButtonVariant.outline,
                              onPressed: () {},
                              child: const Text('Cancel'),
                            ),
                            Button(
                              variant: ButtonVariant.primary,
                              onPressed: () {},
                              child: const Text('Deploy'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  // Form row.
                  if (narrow) ...<Widget>[
                    const Input(hintText: 'Project name'),
                    const Gap(8),
                    Row(
                      children: <Widget>[
                        Switch(value: true, onChanged: (_) {}),
                        const Gap(8),
                        const Badge(
                          variant: BadgeVariant.secondary,
                          child: Text('New'),
                        ),
                      ],
                    ),
                  ] else
                    Row(
                      children: <Widget>[
                        Expanded(child: Input(hintText: 'Project name')),
                        const Gap(8),
                        Switch(value: true, onChanged: (_) {}),
                        const Gap(8),
                        const Badge(
                          variant: BadgeVariant.secondary,
                          child: Text('New'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
