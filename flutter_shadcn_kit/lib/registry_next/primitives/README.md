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
  `ToastEntry` (countdown, pause/resume, the `isExiting` phase) and
  `ToastQueue` (ids, slots, newest-first order, dismissal, and **the
  auto-dismiss policy both `toast` and `gooey_toast` must follow**). The
  overlay mechanism stays with `OverlayManager`.
- `toast_queue/toast_exit.dart` — `ToastExitTransition`: the shared exit
  animation (fade + slide + optional collapse, `easeIn`, 200 ms) both toast
  components wrap their cards in. It removes the entry through
  `ToastQueue.remove` when the animation ends, so the queue stays the single
  source of truth; `MediaQuery.disableAnimations` removes after one frame.
- `gooey/` — the metaball notification surface used by the `gooey_toast`
  component: `gooey_shape` (silhouette geometry, painting, backdrop clip),
  `gooey_frame` (per-frame composition), `gooey_surface` (expand/autopilot/
  morph state machine), `gooey_content` (pill, body, measure, state icon,
  action chip), `gooey_swipe` (directional swipe-to-dismiss) and `gooey_stack`
  (anchored stack over a `ToastQueue`, including the slot pause policy).

- `fractional_align_box.dart` (P4-B17) — `FractionalAlignBox`: lays its child
  out at most `factor` of the incoming width and aligns it, forwarding
  intrinsic queries (the `LayoutBuilder` + `Align` + `ConstrainedBox` pattern
  cannot, which breaks `IntrinsicHeight`/`IntrinsicWidth`). Used by `chat`
  bubbles for `widthFactor`.
- `overlap_layout.dart` (P4-B17) — `OverlapLayout` (+ `OverlapCorner`,
  `OverlapParentData`): hangs an overlap (a badge, a row of chips) over one
  corner of a primary child, widens the primary child when the overlap is
  wider (`extraWidth`) and aligns the union to a side of the incoming width,
  with working intrinsics and hit tests. Used by `chat` reactions.
- `roving_group.dart` (P4-B08) — the arrow-key roving-focus bookkeeping a
  single-select or tabbed container needs: `RovingItem` (one member's
  registration), `RovingGroupRegistry` (ordered members, `move(delta)` that
  skips disabled ones and wraps, and the `shortcuts`/`actions` maps) and
  `RovingGroupScope`. The traversal **maps live on the registry, not on a
  `Shortcuts` above the members**: `Clickable` binds the arrow keys to
  directional focus and the nearest `Shortcuts` wins, so a group-level
  `Shortcuts` is unreachable. Used by `radio_group`; `select`, `menu` and
  `tabs` need the same.
- `selectable_radio/selectable_radio.dart` (P4-B08) — the selectable row shared
  by the single-select components: `RadioItem<T>`, `RadioIndicator` (the circle),
  the `SelectableData`/`SelectableDataScope` selection scope, and the lookup keys
  `kRadioIndicatorKey` and `kRadioIndicatorDotKey`.
  `selectable_radio/selectable_radio_theme.dart` owns the matching
  `ComponentThemeData` classes (`SelectableRadioTheme`, the `RadioIndicatorStyle`
  slice) and their token-derived defaults.
  Created for `radio_group`; `select`, `menu` and `tabs` need the same rows. The
  **card** item shape is deliberately *not* here: a card is a component-layer
  surface, so a layer 2 file may not import `Card`. `radio_group` owns
  `RadioCard` and `SelectableCardTheme`.

## Component themes

Each primitive with theming exposes a `ComponentThemeData` subclass
(`HoverTheme`, `FocusOutlineTheme`, `BasicTheme`, `HiddenTheme`,
`FadeScrollTheme`) implementing `Mergeable`. Resolve with
`resolveComponentStyle<XTheme, XTheme>(context, select: (t) => t, defaults:
const XTheme())` and read fields through `styleValue(widgetValue: …,
themeValue: resolved.…, defaultValue: …)`.
