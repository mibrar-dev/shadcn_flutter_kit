# primitives/ (layer 2)

Interaction, overlay, animation and layout primitives shared by components.
Widgets-only; no Material/Cupertino.

## Import rule

Allowed: `../foundation/*`, `../theme/*`, sibling `primitives/*` files and
Flutter non-Material libraries. No third-party packages (except `intl` /
`flutter_localizations` inside `localizations/`).

## Files (P2-E1)

- `clickable.dart` / `clickable_state.dart` — `Clickable` interaction target.
- `widget_states.dart` — `StatedWidget`, `WidgetStatesData/Provider`,
  `WidgetStateExtension`.
- `hover.dart` — `Hover`, `HoverActivity`, `HoverTheme`.
- `focus_outline.dart` — animated focus ring + theme.
- `subfocus.dart` / `subfocus_item.dart` / `subfocus_scope.dart` — hierarchical
  focus navigation (`SubFocus`, `SubFocusScope`).
- `overlay.dart` — `OverlayCompleter`, `OverlayHandler`, `OverlayBarrier`,
  `OverlayHandlerStateMixin`, `closeOverlay`.
- `overlay_manager.dart` / `overlay_manager_layer.dart` — app-level overlay
  stack (`OverlayManager`, `ShadcnLayer`, `OverlayManagerLayer`).
- `popover.dart`, `popover_controller.dart`, `popover_layout.dart`,
  `popover_layout_render.dart`, `popover_overlay_widget.dart`,
  `popover_overlay_state.dart`, `popover_overlay_handler.dart` — popovers.
- `sheet_overlay.dart` — sheet context marker.
- `animated_value_builder.dart`, `animation_queue.dart`, `animation.dart` —
  animation helpers.
- `layout.dart`, `basic_layout.dart`, `label.dart` — `Basic`, `BasicLayout`,
  `Label` + `BasicTheme`.
- `hidden.dart` — animated hide/collapse.
- `fade_scroll.dart` — scroll-edge fade.
- `menu_group.dart`, `slider_value.dart`, `phone_number.dart` — value types.
- `extensions.dart` — icon/widget/flex extensions, `SeparatedFlex`.
- `form_core/`, `text/`, `localizations/` — sibling primitives (P2-E2).

## Component themes

Each primitive with theming exposes a `ComponentThemeData` subclass
(`HoverTheme`, `FocusOutlineTheme`, `BasicTheme`, `HiddenTheme`,
`FadeScrollTheme`) implementing `Mergeable`. Resolve with
`resolveComponentStyle<XTheme, XTheme>(context, select: (t) => t, defaults:
const XTheme())` and read fields through `styleValue(widgetValue: …,
themeValue: resolved.…, defaultValue: …)`.
