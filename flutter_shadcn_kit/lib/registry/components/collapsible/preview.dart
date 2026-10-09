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
                _section('Uncontrolled', _uncontrolled()),
                const Gap(24),
                _section('Controlled', _controlledSection()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _uncontrolled() {
    return SizedBox(
      width: 360,
      child: Collapsible(
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Recent activity')),
          const Gap(8),
          _row('@mibrar-dev/shadcn_flutter_kit'),
          CollapsibleContent(
            child: Column(
              children: <Widget>[
                const Gap(8),
                _row('@flutter/flutter'),
                const Gap(8),
                _row('@dart-lang/sdk'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlledSection() {
    return SizedBox(
      width: 360,
      child: Collapsible(
        isExpanded: _controlled,
        onExpansionChanged: (value) => setState(() => _controlled = value),
        children: <Widget>[
          const CollapsibleTrigger(child: Text('Controlled section')),
          const Gap(8),
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

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: _uncontrolled(),
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
