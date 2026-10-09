// Gallery preview for the `button` component: every variant, size and state,
// icon buttons and connected groups in light and dark. Widgets-only; the docs
// app embeds [ButtonPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'button.dart';

/// Renders the button gallery.
class ButtonPreview extends StatelessWidget {
  /// Creates the preview.
  const ButtonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  'Variants',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final variant in ButtonVariant.values)
                        Button(
                          variant: variant,
                          onPressed: () {},
                          child: Text(variant.name),
                        ),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Sizes',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      for (final size in ButtonSize.values)
                        Button(
                          size: size,
                          onPressed: () {},
                          child: Text(size.name),
                        ),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Leading / trailing',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      Button(
                        leading: const Icon(LucideIcons.plus, size: 16),
                        onPressed: () {},
                        child: const Text('Add item'),
                      ),
                      Button(
                        variant: ButtonVariant.outline,
                        trailing: const Icon(
                          LucideIcons.chevronRight,
                          size: 16,
                        ),
                        onPressed: () {},
                        child: const Text('Next'),
                      ),
                      Button(
                        size: ButtonSize.icon,
                        variant: ButtonVariant.ghost,
                        onPressed: () {},
                        child: const Icon(LucideIcons.settings, size: 16),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'States',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      Button(onPressed: () {}, child: const Text('Enabled')),
                      const Button(child: Text('No onPressed')),
                      const Button(enabled: false, child: Text('Disabled')),
                      Button(
                        autofocus: true,
                        variant: ButtonVariant.outline,
                        onPressed: () {},
                        child: const Text('Autofocus'),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Groups',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ButtonGroup(
                        children: <Widget>[
                          Button(
                            variant: ButtonVariant.outline,
                            onPressed: () {},
                            child: const Text('Left'),
                          ),
                          Button(
                            variant: ButtonVariant.outline,
                            onPressed: () {},
                            child: const Text('Middle'),
                          ),
                          Button(
                            variant: ButtonVariant.outline,
                            onPressed: () {},
                            child: const Text('Right'),
                          ),
                        ],
                      ),
                      const Gap(12),
                      ButtonGroup.vertical(
                        children: <Widget>[
                          Button(
                            variant: ButtonVariant.secondary,
                            onPressed: () {},
                            child: const Text('Top'),
                          ),
                          Button(
                            variant: ButtonVariant.secondary,
                            onPressed: () {},
                            child: const Text('Bottom'),
                          ),
                        ],
                      ),
                      const Gap(12),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ButtonGroup(
                          children: <Widget>[
                            Button(
                              variant: ButtonVariant.outline,
                              onPressed: () {},
                              child: const Text('يمين'),
                            ),
                            Button(
                              variant: ButtonVariant.outline,
                              onPressed: () {},
                              child: const Text('يسار'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                _section(
                  'Dark',
                  ShadcnTheme(
                    data: const ShadcnThemeData(
                      colors: ShadcnColors.darkFallback,
                    ),
                    child: ColoredBox(
                      color: ShadcnColors.darkFallback.background,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            Button(
                              onPressed: () {},
                              child: const Text('Primary'),
                            ),
                            Button(
                              variant: ButtonVariant.destructive,
                              onPressed: () {},
                              child: const Text('Delete'),
                            ),
                            const Button(
                              variant: ButtonVariant.outline,
                              child: Text('Disabled'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
