// Named examples for the `tooltip` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'tooltip.dart';

/// Label tooltip after the default delay.
Widget _default(BuildContext context) {
  return _anchor(context, LucideIcons.info, 'Details');
}

/// Label tooltip with no delay.
Widget _instant(BuildContext context) {
  return _anchor(
    context,
    LucideIcons.zap,
    'Instant',
    waitDuration: Duration.zero,
  );
}

/// Title plus description in one tooltip.
Widget _rich(BuildContext context) {
  return Tooltip(
    tooltip: (BuildContext context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text('Deployment', style: TextStyle(fontWeight: FontWeight.w600)),
        Text('Ships when the checks pass.'),
      ],
    ),
    child: Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: ShadcnTheme.of(context).colors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        LucideIcons.rocket,
        size: 16,
        color: ShadcnTheme.of(context).colors.foreground,
      ),
    ),
  );
}

/// The container on its own, without hover behaviour.
Widget _container(BuildContext context) {
  return const TooltipContainer(child: Text('Primary surface'));
}

Widget _anchor(
  BuildContext context,
  IconData icon,
  String label, {
  Duration waitDuration = kTooltipWaitDuration,
}) {
  final theme = ShadcnTheme.of(context);
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Tooltip(
      waitDuration: waitDuration,
      tooltip: (BuildContext context) => Text(label),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: theme.colors.foreground),
      ),
    ),
  );
}

/// Named docs examples for `tooltip`; the first entry is the default.
const List<ComponentPreview> tooltipPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Instant', _instant),
  ComponentPreview('Rich content', _rich),
  ComponentPreview('Container', _container),
];
