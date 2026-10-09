// `/themes` — the themes customizer (spec §2.7): a 192 px left rail (preset
// list, radius slider, mode toggle, footer actions) beside a live preview of
// registry components re-theming through AnimatedShadcnTheme (300 ms colour
// tween). The welcome dialog from the reference is omitted — the rail is the
// primary interaction and a dialog would obscure the live preview.

import 'package:flutter/widgets.dart';

import '../routing/docs_router.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/foundation/gap.dart';
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
    // Below `sm` the 192 px rail would squeeze the preview cards into
    // overflow, so the panes stack (rail on top, preview below).
    if (MediaQuery.sizeOf(context).width < 640) {
      return ColoredBox(
        color: theme.colors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 12),
              child: SizedBox(height: 440, child: ThemeRail(state: state)),
            ),
            const Gap(24),
            Expanded(child: LivePreview(state: state)),
          ],
        ),
      );
    }
    return ColoredBox(
      color: theme.colors.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Spec §2.7: the rail is a floating 192 px card (24 px from the
          // left edge, 12 px below the header, 24 px above the bottom).
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 12, bottom: 24),
            child: ThemeRail(state: state),
          ),
          Expanded(child: LivePreview(state: state)),
        ],
      ),
    );
  }
}
