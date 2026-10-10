// Gallery preview for the `collapsible` component: uncontrolled and
// controlled sections plus the dark palette.
// Widgets-only; the docs app embeds [CollapsiblePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'collapsible.dart';

/// Renders the collapsible gallery.
class CollapsiblePreview extends StatefulWidget {
  /// Creates the preview.
  const CollapsiblePreview({super.key});

  @override
  State<CollapsiblePreview> createState() => _CollapsiblePreviewState();
}

class _CollapsiblePreviewState extends State<CollapsiblePreview> {
  bool _controlled = false;

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
                _section(context, 'Uncontrolled', _uncontrolled(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Controlled', _controlledSection(context)),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _uncontrolled(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Collapsible(
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Recent activity')),
          Gap(ShadcnTheme.of(context).spacing.sm),
          _row('@mibrar-dev/shadcn_flutter_kit'),
          CollapsibleContent(
            child: Column(
              children: <Widget>[
                Gap(ShadcnTheme.of(context).spacing.sm),
                _row('@flutter/flutter'),
                Gap(ShadcnTheme.of(context).spacing.sm),
                _row('@dart-lang/sdk'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlledSection(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Collapsible(
        isExpanded: _controlled,
        onExpansionChanged: (value) => setState(() => _controlled = value),
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Controlled section')),
          Gap(ShadcnTheme.of(context).spacing.sm),
          CollapsibleContent(child: _row('Toggled by the parent')),
        ],
      ),
    );
  }

  Widget _row(String label) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.borderRadiusLg,
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: Text(label)),
    );
  }

  Widget _dark(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: _uncontrolled(context),
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
