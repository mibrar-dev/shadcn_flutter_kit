// Gallery preview for the `toggle` component: controlled, controller-driven
// and disabled states plus a notched icon toggle, in light and dark.
// Widgets-only; the docs app embeds [TogglePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'toggle.dart';

/// Renders the toggle gallery.
class TogglePreview extends StatefulWidget {
  /// Creates the preview.
  const TogglePreview({super.key});

  @override
  State<TogglePreview> createState() => _TogglePreviewState();
}

class _TogglePreviewState extends State<TogglePreview> {
  final ToggleController _controller = ToggleController();
  bool _controlled = false;
  bool _iconToggle = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  context,
                  'Controlled',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      Toggle(
                        value: _controlled,
                        onChanged: (value) {
                          setState(() => _controlled = value);
                        },
                        child: const Text('Controlled'),
                      ),
                      Toggle(
                        value: _controlled,
                        onChanged: (value) {
                          setState(() => _controlled = value);
                        },
                        activeStyle: const ToggleStyle(
                          background: StateValue(
                            rest: ThemedColor.ref(ColorRef.secondary),
                            hovered: ThemedColor.ref(
                              ColorRef.secondary,
                              alpha: 0.8,
                            ),
                            pressed: ThemedColor.ref(
                              ColorRef.secondary,
                              alpha: 0.8,
                            ),
                          ),
                        ),
                        child: const Text('Secondary active'),
                      ),
                    ],
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(
                  context,
                  'Controller',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      Toggle(
                        controller: _controller,
                        child: const Text('Controller driven'),
                      ),
                      Toggle(
                        controller: _controller,
                        child: const Icon(LucideIcons.bell, size: 16),
                      ),
                    ],
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(
                  context,
                  'States',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      const Toggle(value: true, child: Text('On (disabled)')),
                      const Toggle(
                        value: false,
                        onChanged: null,
                        child: Text('Off (disabled)'),
                      ),
                      Toggle(
                        value: _iconToggle,
                        onChanged: (value) {
                          setState(() => _iconToggle = value);
                        },
                        child: const Icon(LucideIcons.star, size: 16),
                      ),
                    ],
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(
                  context,
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
                            Toggle(
                              value: true,
                              onChanged: (_) {},
                              child: const Text('On'),
                            ),
                            Toggle(
                              value: false,
                              onChanged: (_) {},
                              child: const Text('Off'),
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

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
