// `/themes` — the themes customizer (spec §2.7): a 192 px left rail (preset
// list, radius slider, mode toggle, footer actions) beside a live preview of
// registry components re-theming through AnimatedShadcnTheme (300 ms colour
// tween). The welcome dialog from the reference is omitted — the rail is the
// primary interaction and a dialog would obscure the live preview.

import 'package:flutter/widgets.dart';

import '../routing/docs_router.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/theme/theme.dart';
import '../widgets/live_preview.dart';
import '../widgets/theme_rail.dart';

/// `/themes` — the customizer.
class ThemesPage extends StatelessWidget {
  /// Creates the themes page.
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final DocsState state = DocsRouterScope.of(context).state;
    return ColoredBox(
      color: theme.colors.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ThemeRail(state: state),
          Expanded(child: LivePreview(state: state)),
        ],
      ),
    );
  }
}
