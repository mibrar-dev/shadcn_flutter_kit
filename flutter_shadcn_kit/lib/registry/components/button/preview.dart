// Named examples for the `button` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'button.dart';

Widget _buttonExample(
  BuildContext context,
  ButtonVariant variant,
  String label,
) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Button(variant: variant, onPressed: () {}, child: Text(label)),
  );
}

Widget _buttonDefault(BuildContext context) =>
    _buttonExample(context, ButtonVariant.primary, 'Button');

Widget _buttonSecondary(BuildContext context) =>
    _buttonExample(context, ButtonVariant.secondary, 'Secondary');

Widget _buttonOutline(BuildContext context) =>
    _buttonExample(context, ButtonVariant.outline, 'Outline');

Widget _buttonGhost(BuildContext context) =>
    _buttonExample(context, ButtonVariant.ghost, 'Ghost');

Widget _buttonLink(BuildContext context) =>
    _buttonExample(context, ButtonVariant.link, 'Link');

Widget _buttonDestructive(BuildContext context) =>
    _buttonExample(context, ButtonVariant.destructive, 'Delete');

/// Icon-only button (shadcn `size="icon"`).
Widget _buttonIcon(BuildContext context) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Button(
      size: ButtonSize.icon,
      variant: ButtonVariant.outline,
      onPressed: () {},
      child: const Icon(LucideIcons.settings, size: 16),
    ),
  );
}

/// Leading and trailing icon buttons.
Widget _buttonWithIcon(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.sm,
    children: <Widget>[
      Button(
        leading: const Icon(LucideIcons.plus, size: 16),
        onPressed: () {},
        child: const Text('Add item'),
      ),
      Button(
        variant: ButtonVariant.outline,
        trailing: const Icon(LucideIcons.chevronRight, size: 16),
        onPressed: () {},
        child: const Text('Next'),
      ),
    ],
  );
}

/// The size scale in one row (shadcn shows the sizes together).
Widget _buttonSizes(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.sm,
    runSpacing: spacing.sm,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      for (final size in ButtonSize.values)
        if (size != ButtonSize.icon)
          Button(size: size, onPressed: () {}, child: Text(size.name)),
    ],
  );
}

/// A pending button: disabled with a loader glyph, the shadcn pattern.
Widget _buttonLoading(BuildContext context) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Button(
      enabled: false,
      leading: const Icon(LucideIcons.loaderCircle, size: 16),
      child: const Text('Loading...'),
    ),
  );
}

/// A disabled button.
Widget _buttonDisabled(BuildContext context) {
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Button(enabled: false, child: const Text('Disabled')),
  );
}

/// Named docs examples for `button`; the first entry is the default.
const List<ComponentPreview> buttonPreviews = <ComponentPreview>[
  ComponentPreview('Default', _buttonDefault),
  ComponentPreview('Secondary', _buttonSecondary),
  ComponentPreview('Outline', _buttonOutline),
  ComponentPreview('Ghost', _buttonGhost),
  ComponentPreview('Link', _buttonLink),
  ComponentPreview('Destructive', _buttonDestructive),
  ComponentPreview('Icon', _buttonIcon),
  ComponentPreview('With icon', _buttonWithIcon),
  ComponentPreview('Sizes', _buttonSizes),
  ComponentPreview('Loading', _buttonLoading),
  ComponentPreview('Disabled', _buttonDisabled),
];
