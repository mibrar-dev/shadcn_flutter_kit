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

## Files (P4, missing primitives)

- `drag_sort.dart` — drop-edge resolution (`resolveDragDropEdge`, `DragDropEdge`),
  drag clamp maths (`DragBounds`) and the reorder change model
  (`ReorderChange`, `ReorderChanges`, `reorderIndex`). Used by the `sortable`
  component and by tab drag-reorder.
- `file_value/file_value.dart`, `file_value/file_validation.dart`,
  `file_value/file_format.dart` — the file upload value types: `FileValue`,
  `FileStatus`, `FileItem`, `FileErrorCode`/`FileError`, `FileConstraints`
  (model), `validateFiles` (checks) and the loading-mode enums,
  `FileStatusLabels`, `formatFileSize` (presentation). Platform file *picking*
  stays in the `file_picker` component; no file/web package is allowed here.
- `toast_queue/toast_placement.dart`, `toast_queue/toast_entry.dart`,
  `toast_queue/toast_queue.dart` — the single toast stack:
  `ToastSwipeDirection`/`ToastPlacement`/`ToastSlot` (anchor metadata),
  `ToastEntry` (countdown, pause/resume) and `ToastQueue` (ids, slots,
  newest-first order, dismissal, and **the auto-dismiss policy both `toast` and
  `gooey_toast` must follow**). The overlay mechanism stays with
  `OverlayManager`.

## Component themes

Each primitive with theming exposes a `ComponentThemeData` subclass
(`HoverTheme`, `FocusOutlineTheme`, `BasicTheme`, `HiddenTheme`,
`FadeScrollTheme`) implementing `Mergeable`. Resolve with
`resolveComponentStyle<XTheme, XTheme>(context, select: (t) => t, defaults:
const XTheme())` and read fields through `styleValue(widgetValue: …,
themeValue: resolved.…, defaultValue: …)`.
