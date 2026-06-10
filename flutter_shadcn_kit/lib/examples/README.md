# Flutter ShadCN Kit — Example Pages

Complete, runnable example screens built from registry components. Each file is self-contained and can be used as a starting point or reference.

## Pages

| File | Description | Components used |
|---|---|---|
| [login_page.dart](login_page.dart) | Sign-in form with social login | Button, Card, TextField, Divider, Text |
| [settings_page.dart](settings_page.dart) | Tabbed settings with profile/notifications/security | Tabs, Card, TextField, Switch, Button, Divider |
| [dashboard_page.dart](dashboard_page.dart) | Overview dashboard with stats and project list | Card, Badge, Button, Text, LinearProgressIndicator |
| [create_project_page.dart](create_project_page.dart) | Create form with confirm-discard dialog | Card, TextField, TextArea, Select, Dialog, Alert, Button |
| [onboarding_page.dart](onboarding_page.dart) | Multi-step wizard with animated transitions | Card, Button, TextField, AnimatedSwitcher |

## Usage

Import any page and use it as a route target. All examples import from `../registry/components/` using relative paths.

For a consuming app with CLI-installed components, replace the import paths with:
```dart
import 'package:<your_app>/ui/shadcn/components/<category>/<component>/<component>.dart';
```

## Key patterns shown

- `hide Card, TextField` — prevents naming conflict with Flutter's built-in widgets
- `.semiBold()`, `.muted()`, `.small()` — text styling extension methods from `display/text/text.dart`
- `InputFeature.clear()`, `InputFeature.passwordToggle()` — TextField input features
- `import '..../dialog/dialog.dart' as shadcn_dialog` — dialog import alias to avoid conflict with `showDialog`
- `Select` with `SelectPopup` + `SelectItemList` + `SelectItemButton` — the correct select API
- `Alert(title:, content:, leading:)` and `Alert.destructive(...)` — alert variants
- `Tabs` + `IndexedStack` — tab navigation pattern
