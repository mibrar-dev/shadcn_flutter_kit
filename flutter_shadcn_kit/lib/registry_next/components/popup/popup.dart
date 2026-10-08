// The `popup` component: an anchored floating surface for arbitrary
// content. The surface itself is the menu component's `MenuPopup`
// (re-exported here); this file adds the generic show helper with Escape
// and outside-tap dismissal.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/overlay.dart';
import '../../primitives/popover.dart';
import '../menu/menu.dart';

export '../menu/menu.dart' show MenuPopup, MenuPopupTheme, menuPopupDefaults;

/// Shows [builder]'s content on a [MenuPopup] surface anchored to [context].
///
/// This is the generic popup: unlike `showShadcnMenu` the content is not a
/// menu (no roving focus, no rows), and unlike [showShadcnContextMenu] it is
/// anchored rather than pointer-positioned. Escape and an outside tap close
/// it while [modal] keeps the content behind non-interactive.
Future<T?> showShadcnPopup<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  AlignmentGeometry alignment = Alignment.topCenter,
  AlignmentGeometry? anchorAlignment,
  Offset offset = const Offset(0, 4),
  PopoverConstraint widthConstraint = PopoverConstraint.flexible,
  PopoverConstraint heightConstraint = PopoverConstraint.flexible,
  bool modal = true,
  bool consumeOutsideTaps = true,
  MenuPopupTheme? theme,
}) {
  return showPopover<T>(
    context: context,
    handler: OverlayHandler.popover,
    alignment: alignment,
    anchorAlignment: anchorAlignment,
    offset: offset,
    widthConstraint: widthConstraint,
    heightConstraint: heightConstraint,
    modal: modal,
    consumeOutsideTaps: consumeOutsideTaps,
    builder: (context) => Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              closeOverlay(context);
              return null;
            },
          ),
        },
        child: MenuPopup(
          theme: theme,
          children: <Widget>[
            Focus(autofocus: true, child: Builder(builder: builder)),
          ],
        ),
      ),
    ),
  ).future;
}
