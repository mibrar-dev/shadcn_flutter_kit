---
name: flutter-shadcn-kit
description: Build Flutter UI screens and pages using the flutter_shadcn_kit component registry — a shadcn/ui-inspired widget library. Use this skill whenever the user is working in the flutter_shadcn_kit project or a project that depends on it, when they ask to build screens/pages using shadcn components, when they want to use ShadCN-style widgets in Flutter (buttons, cards, dialogs, tabs, text fields, badges, etc.), or when they ask to compose pages from the registry. Trigger on: "use shadcn components", "build a page with shadcn", "flutter shadcn", "add a card/button/dialog/tab", "use the registry", "flutter_shadcn_kit".
---

# Flutter ShadCN Kit

A shadcn/ui-inspired component registry for Flutter with 133+ widgets in 7 categories. Install components into your app with the `flutter_shadcn` CLI and use them directly.

## Quick start: App setup

Wrap your app root in the shadcn theme system:

```dart
import 'package:flutter/material.dart' as material;
import 'package:flutter_shadcn_kit/flutter_shadcn_kit.dart' as shadcn;

void main() {
  material.runApp(const MyApp());
}

class MyApp extends material.StatelessWidget {
  const MyApp({super.key});

  @override
  material.Widget build(material.BuildContext context) {
    return material.MaterialApp(
      home: shadcn.Theme(
        data: const shadcn.ThemeData(),
        child: const ShadcnLayer(
          child: material.Material(
            type: material.MaterialType.transparency,
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
```

After CLI install, components live at `lib/ui/shadcn/components/` and shared code at `lib/ui/shadcn/shared/`.

## Core import rule

Always `hide Card, TextField` from material when using shadcn versions to avoid naming conflicts:

```dart
import 'package:flutter/material.dart' hide Card, TextField;
```

---

## Key components

### Button — 6 variants

```dart
PrimaryButton(onPressed: () {}, child: const Text('Submit'))
SecondaryButton(onPressed: () {}, child: const Text('Cancel'))
OutlineButton(onPressed: () {}, child: const Text('Outline'))
GhostButton(onPressed: () {}, child: const Text('Ghost'))
DestructiveButton(onPressed: () {}, child: const Text('Delete'))
LinkButton(onPressed: () {}, child: const Text('Learn more'))
```

Optional params: `leading`, `trailing` (Widget icons), `enabled`, `size` (ButtonSize), `density`, `shape`.

### Card

```dart
Card(
  padding: const EdgeInsets.all(24),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [ ... ],
  ),
)
```

### TextField

```dart
TextField(placeholder: const Text('Enter value'))

TextField(
  placeholder: const Text('Search...'),
  features: [InputFeature.clear()],
)

TextField(
  placeholder: const Text('Password'),
  obscureText: true,
  features: [InputFeature.passwordToggle(), InputFeature.clear()],
)
```

### Dialog

Import aliased to avoid Flutter conflict:
```dart
import 'package:<app>/ui/shadcn/components/overlay/dialog/dialog.dart' as shadcn_dialog;

shadcn_dialog.showDialog<void>(
  context: context,
  builder: (context) => Card(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Title'),
        const SizedBox(height: 12),
        const Text('Body text.'),
        const SizedBox(height: 20),
        Row(children: [
          const Spacer(),
          OutlineButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          const SizedBox(width: 8),
          PrimaryButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Confirm')),
        ]),
      ],
    ),
  ),
);
```

### Tabs

```dart
// Requires StatefulWidget — track index with setState
Tabs(
  index: _selectedIndex,
  onChanged: (i) => setState(() => _selectedIndex = i),
  children: const [
    TabItem(child: Text('Overview')),
    TabItem(child: Text('Settings')),
  ],
),
IndexedStack(
  index: _selectedIndex,
  children: [OverviewContent(), SettingsContent()],
),
```

### Badge

```dart
PrimaryBadge(child: const Text('New'))
SecondaryBadge(child: const Text('Beta'))
DestructiveBadge(child: const Text('Error'))
OutlineBadge(child: const Text('Draft'))
```

### Select (dropdown)

Uses a popup builder pattern — not a simple `items` list:

```dart
Select<String>(
  value: selectedValue,
  onChanged: (v) => setState(() => selectedValue = v),
  placeholder: const Text('Select a category'),
  itemBuilder: (context, item) => Text(item),
  popup: const SelectPopup(
    items: SelectItemList(
      children: [
        SelectItemButton(value: 'design', child: Text('Design')),
        SelectItemButton(value: 'engineering', child: Text('Engineering')),
      ],
    ),
  ).call,
)
```

### Alert

```dart
Alert(
  title: const Text('Alert title'),
  content: const Text('Body text.'),
  leading: const Icon(Icons.info_outline),
)

Alert.destructive(
  title: const Text('Error'),
  content: const Text('Something went wrong.'),
  leading: const Icon(Icons.error_outline),
)
```

### Text styling extensions

Requires importing `display/text/text.dart` — chainable:

```dart
const Text('Section title').semiBold()
const Text('Helper text').muted()
const Text('Caption').muted().small()
const Text('Label').semiBold().small()
```

---

## Standard page layout pattern

```dart
Scaffold(
  body: SafeArea(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [ ... ],
            ),
          ),
        ),
      ),
    ),
  ),
)
```

---

## Component categories (133 total)

| Category | Count | Key components |
|---|---|---|
| control | 6 | Button, Scrollbar, Command |
| display | 27 | Badge, Avatar, Skeleton, Spinner, Text, Calendar, Carousel |
| form | 33 | TextField, Checkbox, Select, DatePicker, Slider, RadioGroup, Switch |
| layout | 27 | Card, Accordion, Alert, Table, Steps, Resizable |
| navigation | 11 | Tabs, Breadcrumb, Pagination, NavigationMenu |
| overlay | 19 | Dialog, Drawer, Toast, Tooltip, Popover, ContextMenu |
| utility | 14 | Async, Image, FocusOutline |

For full component APIs read `references/components-catalog.md`.
For complete runnable example pages read `references/example-pages.md`.

---

## Registry file layout

```
lib/registry/components/<category>/<component_id>/
├── <component_id>.dart      # Public API — import this
├── preview.dart             # Working usage demo — read to learn the API
├── meta.json                # Dependencies
└── _impl/                   # Private — never import directly
```

When you need to understand any component's full API, read its `preview.dart` — it's always a working example with real constructor calls.
