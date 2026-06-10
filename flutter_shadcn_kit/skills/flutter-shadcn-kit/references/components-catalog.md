# Flutter ShadCN Kit — Component Catalog

Full reference for all 133 components. Each entry shows the import path (relative to `lib/registry/`) and key API.

## CONTROL

### button
Import: `components/control/button/button.dart`

Variants: `PrimaryButton`, `SecondaryButton`, `OutlineButton`, `GhostButton`, `DestructiveButton`, `LinkButton`

Shared params:
- `child` (Widget, required)
- `onPressed` (VoidCallback?)
- `enabled` (bool?, default true)
- `leading` / `trailing` (Widget? — for icons)
- `size` (ButtonSize: `normal`, `sm`, `lg`, `icon`)
- `density` (ButtonDensity: `normal`, `comfortable`, `compact`, `icon`)
- `shape` (ButtonShape: `rectangle`, `circle`)
- `focusNode` (FocusNode?)
- `disableTransition` (bool)
- Gesture callbacks: `onHover`, `onFocus`, `onTapDown`, `onTapUp`, `onLongPress`, etc.

### scrollbar
Import: `components/control/scrollbar/scrollbar.dart`
Shadcn-styled scrollbar overlay.

### command
Import: `components/control/command/command.dart`
Command palette / search overlay component.

---

## DISPLAY

### badge
Import: `components/display/badge/badge.dart`

Variants: `PrimaryBadge`, `SecondaryBadge`, `DestructiveBadge`, `OutlineBadge`

Params:
- `child` (Widget, required)
- `leading` / `trailing` (Widget?)
- `onPressed` (VoidCallback? — makes it tappable)
- `style` (AbstractButtonStyle?)

### avatar
Import: `components/display/avatar/avatar.dart`

### badge
See above.

### calendar
Import: `components/display/calendar/calendar.dart`

### carousel
Import: `components/display/carousel/carousel.dart`

### chip
Import: `components/display/chip/chip.dart`

### skeleton
Import: `components/display/skeleton/skeleton.dart`
Loading placeholder shimmer widget.

### spinner
Import: `components/display/spinner/spinner.dart`
Circular loading indicator.

### text
Import: `components/display/text/text.dart`

Extension methods on `Text`:
- `.semiBold()` — font weight 600
- `.bold()` — font weight 700
- `.muted()` — muted/secondary color
- `.small()` — smaller font size
- `.large()` — larger font size
- `.italic()` — italic style
- `.underline()` — underline decoration

These are chainable: `const Text('Label').semiBold().muted()`.

### markdown
Import: `components/display/markdown/markdown.dart`

### progress
Import: `components/display/progress/progress.dart`

### tracker
Import: `components/display/tracker/tracker.dart`

### tree
Import: `components/display/tree/tree.dart`

---

## FORM

### text_field
Import: `components/form/text_field/text_field.dart`

```dart
TextField(
  placeholder: const Text('placeholder'),
  obscureText: false,
  features: [InputFeature.clear(), InputFeature.passwordToggle()],
  onChanged: (v) { },
  controller: myController,
)
```

`InputFeature` options:
- `InputFeature.clear()` — clear button (X)
- `InputFeature.passwordToggle()` — eye icon for password fields
- `InputFeature.leading(widget)` — leading widget
- `InputFeature.trailing(widget)` — trailing widget

### checkbox
Import: `components/form/checkbox/checkbox.dart`

```dart
Checkbox(
  state: checked ? CheckboxState.checked : CheckboxState.unchecked,
  onChanged: (state) { },
)
```

### select
Import: `components/form/select/select.dart`
Dropdown select component.

### date_picker
Import: `components/form/date_picker/date_picker.dart`

### slider
Import: `components/form/slider/slider.dart`

### radio_group
Import: `components/form/radio_group/radio_group.dart`

### switch (toggle)
Import: `components/form/switch/switch.dart`

```dart
Switch(
  value: isEnabled,
  onChanged: (v) => setState(() => isEnabled = v),
)
```

### text_area
Import: `components/form/text_area/text_area.dart`
Multi-line text input.

### star_rating
Import: `components/form/star_rating/star_rating.dart`

### chip_input
Import: `components/form/chip_input/chip_input.dart`
Tag/chip input with add/remove.

### form + form_field
Import: `components/form/form/form.dart` and `components/form/form_field/form_field.dart`
Form validation wrapper components.

---

## LAYOUT

### card
Import: `components/layout/card/card.dart`

```dart
Card(
  padding: const EdgeInsets.all(24),
  filled: true,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [ BoxShadow(...) ],
  child: ...,
)
```

### accordion
Import: `components/layout/accordion/accordion.dart`
Collapsible sections.

### alert
Import: `components/layout/alert/alert.dart`

### table
Import: `components/layout/table/table.dart`

### steps
Import: `components/layout/steps/steps.dart`
Step progress indicator.

### resizable
Import: `components/layout/resizable/resizable.dart`
Resizable panel layout.

### scaffold
Import: `components/layout/scaffold/scaffold.dart`

```dart
Scaffold(
  headers: [AppBar(...)],
  footers: [BottomBar(...)],
  loadingProgress: null,
  child: ...,
)
```

### timeline
Import: `components/layout/timeline/timeline.dart`

### flex / group / basic
Layout primitives for arranging children.

---

## NAVIGATION

### tabs
Import: `components/navigation/tabs/tabs.dart`

```dart
// Stateful pattern:
Tabs(
  index: _index,
  onChanged: (i) => setState(() => _index = i),
  children: const [
    TabItem(child: Text('Tab 1')),
    TabItem(child: Text('Tab 2')),
  ],
),
IndexedStack(
  index: _index,
  children: [ Widget1(), Widget2() ],
),
```

### breadcrumb
Import: `components/navigation/breadcrumb/breadcrumb.dart`

### pagination
Import: `components/navigation/pagination/pagination.dart`

### navigation_menu
Import: `components/navigation/navigation_menu/navigation_menu.dart`

### navigation_bar
Import: `components/navigation/navigation_bar/navigation_bar.dart`

### stepper
Import: `components/navigation/stepper/stepper.dart`

---

## OVERLAY

### dialog
Import: `components/overlay/dialog/dialog.dart` — usually aliased as `shadcn_dialog`

```dart
import '../../overlay/dialog/dialog.dart' as shadcn_dialog;

shadcn_dialog.showDialog<T>(
  context: context,
  builder: (context) => Card(
    padding: const EdgeInsets.all(24),
    child: ...,
  ),
);
```

### toast
Import: `components/overlay/toast/toast.dart`

```dart
showToast(context, child: const Text('Saved successfully'));
```

### drawer
Import: `components/overlay/drawer/drawer.dart`

### tooltip
Import: `components/overlay/tooltip/tooltip.dart`

```dart
Tooltip(
  tooltip: const Text('Helpful description'),
  child: const Icon(Icons.info),
)
```

### popover
Import: `components/overlay/popover/popover.dart`

### context_menu
Import: `components/overlay/context_menu/context_menu.dart`

### dropdown_menu
Import: `components/overlay/dropdown_menu/dropdown_menu.dart`

### alert_dialog
Import: `components/overlay/alert_dialog/alert_dialog.dart`
Simpler dialog variant with title/description/actions structure.

---

## UTILITY

### async
Import: `components/utility/async/async.dart`
Async state wrapper widget for loading/error/data states.

### image
Import: `components/utility/image/image.dart`
Enhanced image widget with loading/error states.

### focus_outline
Import: `components/utility/focus_outline/focus_outline.dart`
Accessible focus ring primitive.

---

## Theme presets

44+ presets are available in `lib/registry/themes_preset/`. Apply one:

```dart
import 'package:flutter_shadcn_kit/registry/themes_preset/blue_theme.dart';

shadcn.Theme(
  data: blueThemeData(),
  child: ...,
)
```

Available color families: blue, green, red, purple, orange, zinc, slate, stone, gray, neutral, rose, violet, yellow, indigo — each with light and dark variants.
