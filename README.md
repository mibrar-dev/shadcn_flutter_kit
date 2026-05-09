# shadcn_flutter_kit

An end-to-end shadcn/ui ecosystem for Flutter: **registry components**, a **docs
app (Widget Catalog)**, and a **CLI** to install and sync components.

[![GitHub Repo](https://img.shields.io/badge/GitHub-shadcn_flutter_kit-black?style=for-the-badge&logo=github)](https://github.com/ibrar-x/shadcn_flutter_kit)
[![Docs](https://img.shields.io/badge/Docs-Widget%20Catalog-blue?style=for-the-badge&logo=google-chrome&logoColor=white)](https://ibrar-x.github.io/shadcn_flutter_kit/)
[![CLI on pub.dev](https://img.shields.io/badge/pub.dev-flutter_shadcn_cli-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://pub.dev/packages/flutter_shadcn_cli)
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/ibrar-x/shadcn_flutter_kit/docs-deploy.yml?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/ibrar-x/shadcn_flutter_kit/actions)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](https://github.com/ibrar-x/shadcn_flutter_kit/blob/main/LICENSE)
[![Stars](https://img.shields.io/github/stars/ibrar-x/shadcn_flutter_kit?style=for-the-badge&logo=github)](https://github.com/ibrar-x/shadcn_flutter_kit/stargazers)

Docs URL verification:
- The workflow builds with `baseHref: /shadcn_flutter_kit/`, so the GitHub Pages URL is:
  `https://ibrar-x.github.io/shadcn_flutter_kit/`

---

## What's in this repo

- **Registry components**: A copy/paste friendly component library organized
  under `registry/` with metadata, examples, and shared tokens.
- **Docs app (Widget Catalog)**: A Flutter web app under `docs/` that showcases
  the registry components, examples, and usage patterns.
- **Validator app**: `flutter_shadcn_kit/` validates the registry (schema,
  dependencies, metadata).
- **CLI support**: Install and sync components into your own projects using
  `flutter_shadcn_cli`.

This repository focuses on **registry-first** development: everything you see in
the docs app comes from the registry components.

---

## Quick start (CLI)

1) Install the CLI:

```bash
dart pub global activate flutter_shadcn_cli
```

2) Initialize your project:

```bash
flutter_shadcn init --yes
```

3) Add components:

```bash
flutter_shadcn add button badge accordion
flutter analyze
```

4) Open the complete install and command guide:

- Website: `/#/complete-guide`
- CLI markdown: `flutter_shadcn_cli/docs/user/complete-guide.md`

---

## Docs app (Widget Catalog)

From the repo root:

```bash
cd docs
flutter run -d chrome
```

The docs app is the **widget catalog** and is intended to mirror the original
shadcn_flutter docs while using registry components.

---

## Project structure

```
docs/                           # Flutter web docs app (Widget Catalog)
flutter_shadcn_kit/             # Registry source + validator app
shadcn_flutter_cli/             # CLI source (in this mono-repo)
```

---

## Using components in your app

Once synced or installed by CLI, import from the registry path you configured.

Example (typical layout):

```dart
import 'package:your_app/ui/shadcn/shadcn_ui.dart';
```

The registry is **Material‑optional**. You can embed components inside existing
Material/Cupertino apps or go all‑in with the shadcn theme tokens.

---

## Registry-first docs

This repo intentionally updates the docs to match the **registry components**
instead of directly using the original shadcn_flutter package. That means:

- Examples live in the docs app under `docs/lib/pages/docs/components/...`
- Components are imported from `docs/lib/ui/shadcn/` (synced from registry)
- The catalog is the source of truth for component usage

---

## Contributing

Contributions are welcome. Please keep changes registry‑first and ensure the
docs app uses the registry components. If you add or remove components, update:

- `registry/manifests/components.json`
- `registry/manifests/components.schema.json`
- docs pages/examples as needed

For a contributor onboarding flow (setup, scripts, validation, and docs refresh),
see [`REGISTRY_CONTRIBUTING.md`](REGISTRY_CONTRIBUTING.md).

---


## Attribution

This project is inspired by and partially derived from
[shadcn_flutter](https://github.com/sunarya-thito/shadcn_flutter) by Sunarya Thito.

Some components and patterns originated from the shadcn_flutter codebase and
have been adapted, reorganized, and extended into a registry-first architecture
with additional tooling (CLI, schema validation, and docs).

The original shadcn_flutter project is licensed under the BSD 3-Clause License.
A copy of that license is included in this repository under `licenses/`.


## License

This project is licensed under the MIT License.

Copyright (c) 2026 Muhammad Ibrar Javid

Third-party code adapted from other projects (such as
[shadcn_flutter](https://github.com/sunarya-thito/shadcn_flutter)) remains under
its original license terms. See the `licenses/` directory for details.

See the [LICENSE](LICENSE) file for the full MIT license text.

---

## Component highlights

The widget catalog includes a large set of components across categories:

- **Control**: Button, Toggle, Command, Hover
- **Disclosure**: Accordion, Collapsible
- **Display**: Avatar, Chat Bubble, Code Snippet, Tracker
- **Feedback**: Alert, Dialog, Toast, Progress, Skeleton
- **Form**: AutoComplete, Chip Input, Color Picker, Date Picker, Select, Slider
- **Layout**: Card, Carousel, Divider, Resizable, Stepper, Timeline
- **Navigation**: Breadcrumb, Menu Bar, Navigation Menu, Tabs, Tree
- **Overlay**: Drawer, Hover Card, Popover, Sheet, Tooltip
- **Utility**: Badge, Calendar, Command, Context Menu, Dropdown Menu

See the **Widget Catalog** for the full list and live examples:
https://ibrar-x.github.io/shadcn_flutter_kit/

---

## Components gallery

Each image links to the live component page in the Widget Catalog.

### Animation
[![AnimatedValueBuilder](docs/assets/docs_images/animatedvaluebuilder.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/animated_value_builder)
[![Number Ticker](docs/assets/docs_images/number_ticker.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/number_ticker)
[![Repeated Animation Builder](docs/assets/docs_images/repeatedanimationbuilder.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/repeated_animation_builder)

### Disclosure
[![Accordion](docs/assets/docs_images/accordion.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/accordion)
[![Collapsible](docs/assets/docs_images/collapsible.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/collapsible)

### Feedback
[![Alert](docs/assets/docs_images/alert.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/alert)
[![Alert Dialog](docs/assets/docs_images/alert_dialog.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/alert_dialog)
[![Circular Progress](docs/assets/docs_images/circular_progress.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/circular_progress)
[![Progress](docs/assets/docs_images/progress.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/progress)
[![Skeleton](docs/assets/docs_images/skeleton.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/skeleton)
[![Toast](docs/assets/docs_images/toast.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/toast)

### Form
[![Button](docs/assets/docs_images/button.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/button)
[![Checkbox](docs/assets/docs_images/checkbox.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/checkbox)
[![Chip Input](docs/assets/docs_images/chip_input.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/chip_input)
[![Color Picker](docs/assets/docs_images/colorpicker.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/color_picker)
[![Date Picker](docs/assets/docs_images/datepicker.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/date_picker)
[![Form](docs/assets/docs_images/form.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/form)
[![Input](docs/assets/docs_images/input.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/input)
[![Input OTP](docs/assets/docs_images/inputotp.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/input_otp)
[![Phone Input](docs/assets/docs_images/phone_input.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/phone_input)
[![Radio Group](docs/assets/docs_images/radiogroup.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/radio_group)
[![Select](docs/assets/docs_images/select.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/select)
[![Slider](docs/assets/docs_images/slider.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/slider)
[![Star Rating](docs/assets/docs_images/star_rating.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/star_rating)
[![Switch](docs/assets/docs_images/switch.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/switch)
[![Text Area](docs/assets/docs_images/textarea.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/text_area)
[![Time Picker](docs/assets/docs_images/time_picker.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/time_picker)
[![Toggle](docs/assets/docs_images/toggle.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/toggle)

### Layout
[![Card](docs/assets/docs_images/card.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/card)
[![Carousel](docs/assets/docs_images/carousel.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/carousel)
[![Divider](docs/assets/docs_images/divider.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/divider)
[![Resizable](docs/assets/docs_images/resizable.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/resizable)
[![Stepper](docs/assets/docs_images/stepper.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/stepper)
[![Steps](docs/assets/docs_images/steps.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/steps)
[![Timeline](docs/assets/docs_images/timeline.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/timeline)

### Navigation
[![Breadcrumb](docs/assets/docs_images/breadcrumb.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/breadcrumb)
[![Menubar](docs/assets/docs_images/menubar.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/menubar)
[![Navigation Menu](docs/assets/docs_images/navigation_menu.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/navigation_menu)
[![Pagination](docs/assets/docs_images/pagination.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/pagination)
[![Tabs](docs/assets/docs_images/tabs.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/tabs)
[![Tab List](docs/assets/docs_images/tablist.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/tab_list)
[![Tree](docs/assets/docs_images/tree.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/tree)

### Overlay
[![Dialog](docs/assets/docs_images/dialog.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/dialog)
[![Drawer](docs/assets/docs_images/drawer.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/drawer)
[![Hover Card](docs/assets/docs_images/hover_card.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/hover_card)
[![Popover](docs/assets/docs_images/popover.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/popover)
[![Sheet](docs/assets/docs_images/sheet.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/sheet)
[![Tooltip](docs/assets/docs_images/tooltip.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/tooltip)

### Utility
[![Badge](docs/assets/docs_images/badge.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/badge)
[![Calendar](docs/assets/docs_images/calendar.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/calendar)
[![Command](docs/assets/docs_images/command.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/command)
[![Context Menu](docs/assets/docs_images/context_menu.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/context_menu)
[![Dropdown Menu](docs/assets/docs_images/dropdown_menu.png)](https://ibrar-x.github.io/shadcn_flutter_kit/docs/#/components/dropdown_menu)
