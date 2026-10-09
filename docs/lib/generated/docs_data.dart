// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/manifests/registry.json
//   * flutter_shadcn_kit/lib/registry/themes/index.json
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// Every component, preset, category and stat is derived from the
// registry manifest; docs pages never hard-code registry facts.

/// One installable component, generated from the registry manifest.
class DocsComponent {
  /// Creates a component entry.
  const DocsComponent({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.install,
    required this.import,
    required this.fileCount,
    required this.stability,
  });

  /// Registry id / directory name.
  final String id;

  /// Display name.
  final String name;

  /// Manifest category (`form`, `overlay`, `display`, …).
  final String category;

  /// One-line description from the manifest.
  final String description;

  /// `flutter_shadcn add <id>` from the manifest.
  final String install;

  /// Corrected import line for the installed layout.
  final String import;

  /// Installed Dart files: manifest `files` + user-owned theme file.
  final int fileCount;

  /// `stable` for every component — the manifest has no stability
  /// field yet; this is a docs-site presentation constant.
  final String stability;
}

/// One theme preset, generated from `themes/index.json`.
class DocsPreset {
  /// Creates a preset entry.
  const DocsPreset({required this.id, required this.name, required this.modes});

  /// Preset id (`modern-minimal`).
  final String id;

  /// Display name (`Modern Minimal`).
  final String name;

  /// Supported modes in declaration order (`light`, `dark`).
  final List<String> modes;
}

/// A catalog category with its component count.
class DocsCategory {
  /// Creates a category entry.
  const DocsCategory({required this.id, required this.count});

  /// Category id (`form`).
  final String id;

  /// Number of components in the category.
  final int count;
}

/// Compact link-grid row: id + name only (components index).
class DocsComponentLink {
  /// Creates a link row.
  const DocsComponentLink({required this.id, required this.name});

  /// Registry id / route segment (`/docs/components/<id>`).
  final String id;

  /// Display name.
  final String name;
}

/// Landing stats band values, each derived from the registry.
class DocsStats {
  /// Creates the stats block.
  const DocsStats({
    required this.components,
    required this.presets,
    required this.materialImports,
    required this.modes,
  });

  /// Installable component count: manifest `components` entries.
  final int components;

  /// Preset count: `themes/index.json` entries.
  final int presets;

  /// Material/Cupertino import directives found across the
  /// registry Dart files (must be 0).
  final int materialImports;

  /// Distinct preset modes (2: light + dark).
  final int modes;
}

/// All 118 installable components, ordered by category then id.
const List<DocsComponent> kComponents = <DocsComponent>[
  DocsComponent(
    id: 'button',
    name: 'Button',
    category: 'control',
    description:
        'Pressable action control with seven variants and five fixed sizes, plus a connected ButtonGroup.',
    install: 'flutter_shadcn add button',
    import:
        "import 'package:<your_app>/ui/shadcn/components/button/button.dart';",
    fileCount: 4,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'command',
    name: 'Command',
    category: 'control',
    description:
        'Command palette with a debounced async result stream, keyboard navigation and a dialog entry point.',
    install: 'flutter_shadcn add command',
    import:
        "import 'package:<your_app>/ui/shadcn/components/command/command.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'patch',
    name: 'ClickDetector',
    category: 'control',
    description:
        'Counts consecutive taps inside a time and distance window for double/triple-click gestures.',
    install: 'flutter_shadcn add patch',
    import:
        "import 'package:<your_app>/ui/shadcn/components/patch/patch.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'scrollbar',
    name: 'Scrollbar',
    category: 'control',
    description:
        "Themeable scrollbar wrapper around Flutter's RawScrollbar with token-derived thumb, thickness and radius.",
    install: 'flutter_shadcn add scrollbar',
    import:
        "import 'package:<your_app>/ui/shadcn/components/scrollbar/scrollbar.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'scrollview',
    name: 'Scroll View Interceptor',
    category: 'control',
    description:
        'Middle-button drag-to-scroll interceptor for desktop and web pointer devices.',
    install: 'flutter_shadcn add scrollview',
    import:
        "import 'package:<your_app>/ui/shadcn/components/scrollview/scrollview.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'toggle',
    name: 'Toggle',
    category: 'control',
    description:
        'On/off button with a controlled and a controller-driven mode, plus form participation.',
    install: 'flutter_shadcn add toggle',
    import:
        "import 'package:<your_app>/ui/shadcn/components/toggle/toggle.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'avatar',
    name: 'Avatar',
    category: 'display',
    description:
        'Image or initials tile with an optional badge and overlapping group.',
    install: 'flutter_shadcn add avatar',
    import:
        "import 'package:<your_app>/ui/shadcn/components/avatar/avatar.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'badge',
    name: 'Badge',
    category: 'display',
    description:
        'Small rounded label or status dot with four variants, optionally pressable.',
    install: 'flutter_shadcn add badge',
    import:
        "import 'package:<your_app>/ui/shadcn/components/badge/badge.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'border_loading',
    name: 'Border Loading',
    category: 'display',
    description:
        'Animated gradient border around a child: sweep ring, travelling tracers, determinate progress or a static outline.',
    install: 'flutter_shadcn add border_loading',
    import:
        "import 'package:<your_app>/ui/shadcn/components/border_loading/border_loading.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'calendar',
    name: 'Calendar',
    category: 'display',
    description:
        'Date, month and year grids with single, range and multi selection, roving-tabindex keyboard navigation and per-day semantic dates; the selection value types live in the date_math primitive.',
    install: 'flutter_shadcn add calendar',
    import:
        "import 'package:<your_app>/ui/shadcn/components/calendar/calendar.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'carousel',
    name: 'Carousel',
    category: 'display',
    description:
        'Paged carousel with a sliding or fading transition, drag, autoplay and a controller that drives the dot row.',
    install: 'flutter_shadcn add carousel',
    import:
        "import 'package:<your_app>/ui/shadcn/components/carousel/carousel.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'chat',
    name: 'Chat',
    category: 'display',
    description:
        'Chat bubbles and groups: plain, tailed or sharp-corner bubbles aligned to their side of the row, with optional avatars.',
    install: 'flutter_shadcn add chat',
    import: "import 'package:<your_app>/ui/shadcn/components/chat/chat.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'chip',
    name: 'Chip',
    category: 'display',
    description:
        'Compact deletable-token control plus the borderless control embedded inside a chip.',
    install: 'flutter_shadcn add chip',
    import: "import 'package:<your_app>/ui/shadcn/components/chip/chip.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'code_snippet',
    name: 'CodeSnippet',
    category: 'display',
    description:
        'Scrollable code block with optional top-right action buttons.',
    install: 'flutter_shadcn add code_snippet',
    import:
        "import 'package:<your_app>/ui/shadcn/components/code_snippet/code_snippet.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'country_flag',
    name: 'CountryFlag',
    category: 'display',
    description:
        'Flag tile for a country looked up by ISO code, currency or dial prefix, with an emoji fallback.',
    install: 'flutter_shadcn add country_flag',
    import:
        "import 'package:<your_app>/ui/shadcn/components/country_flag/country_flag.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'divider',
    name: 'Divider',
    category: 'display',
    description:
        'Themed rule in either orientation, optionally carrying a centred label.',
    install: 'flutter_shadcn add divider',
    import:
        "import 'package:<your_app>/ui/shadcn/components/divider/divider.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'dot_indicator',
    name: 'DotIndicator',
    category: 'display',
    description:
        'Animated row or column of dots showing the active index of a carousel, stepper or pager.',
    install: 'flutter_shadcn add dot_indicator',
    import:
        "import 'package:<your_app>/ui/shadcn/components/dot_indicator/dot_indicator.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'empty_state',
    name: 'EmptyState',
    category: 'display',
    description:
        'A block that stands in for missing content: muted icon, title, description and up to three actions, in an inline or route-level scale.',
    install: 'flutter_shadcn add empty_state',
    import:
        "import 'package:<your_app>/ui/shadcn/components/empty_state/empty_state.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'feature_carousel',
    name: 'Feature Carousel',
    category: 'display',
    description:
        'Animated feature-card carousel with autoplay, swipe, keyboard navigation, nav arrows and a call to action.',
    install: 'flutter_shadcn add feature_carousel',
    import:
        "import 'package:<your_app>/ui/shadcn/components/feature_carousel/feature_carousel.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'file_diff_viewer',
    name: 'File Diff Viewer',
    category: 'display',
    description:
        'Renders unified or split file diffs with line gutters, coloured additions/deletions, collapsible unchanged hunks and a copy-patch action.',
    install: 'flutter_shadcn add file_diff_viewer',
    import:
        "import 'package:<your_app>/ui/shadcn/components/file_diff_viewer/file_diff_viewer.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'icon',
    name: 'Icon',
    category: 'display',
    description:
        'Theme-driven icon size/colour modifiers and a filled icon container.',
    install: 'flutter_shadcn add icon',
    import: "import 'package:<your_app>/ui/shadcn/components/icon/icon.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'image',
    name: 'ShadcnImage',
    category: 'display',
    description:
        'Themed rounded image slot with a placeholder while loading and a caller-supplied error slot on failure.',
    install: 'flutter_shadcn add image',
    import:
        "import 'package:<your_app>/ui/shadcn/components/image/image.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'keyboard_shortcut',
    name: 'KeyboardShortcut',
    category: 'display',
    description:
        'Renders a keyboard shortcut as a row of small key caps, from explicit keys or from a ShortcutActivator, with an optional app-wide label override.',
    install: 'flutter_shadcn add keyboard_shortcut',
    import:
        "import 'package:<your_app>/ui/shadcn/components/keyboard_shortcut/keyboard_shortcut.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'markdown',
    name: 'Markdown',
    category: 'display',
    description:
        'Text-only markdown renderer with a shadcn theme, tap callbacks and an image preview overlay.',
    install: 'flutter_shadcn add markdown',
    import:
        "import 'package:<your_app>/ui/shadcn/components/markdown/markdown.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'number_ticker',
    name: 'NumberTicker',
    category: 'display',
    description:
        'Animated number with a formatter or custom builder, plus flip-clock character rollers.',
    install: 'flutter_shadcn add number_ticker',
    import:
        "import 'package:<your_app>/ui/shadcn/components/number_ticker/number_ticker.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'pinned_sheet',
    name: 'Pinned Sheet',
    category: 'display',
    description:
        'In-tree sheet that slides in from an edge, drags, and snaps between snap stages.',
    install: 'flutter_shadcn add pinned_sheet',
    import:
        "import 'package:<your_app>/ui/shadcn/components/pinned_sheet/pinned_sheet.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'progress',
    name: 'Progress',
    category: 'display',
    description:
        'Determinate and indeterminate linear progress bar, widgets-only.',
    install: 'flutter_shadcn add progress',
    import:
        "import 'package:<your_app>/ui/shadcn/components/progress/progress.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'selectable',
    name: 'SelectableText',
    category: 'display',
    description:
        'Read-only selectable text with widgets-only selection controls.',
    install: 'flutter_shadcn add selectable',
    import:
        "import 'package:<your_app>/ui/shadcn/components/selectable/selectable.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'skeleton',
    name: 'Skeleton',
    category: 'display',
    description:
        'Widgets-only loading placeholder with a repeating shimmer sweep; replaces the banned skeletonizer package.',
    install: 'flutter_shadcn add skeleton',
    import:
        "import 'package:<your_app>/ui/shadcn/components/skeleton/skeleton.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'spinner',
    name: 'Spinner',
    category: 'display',
    description:
        'Indeterminate circular indicator with a rotating arc, widgets-only.',
    install: 'flutter_shadcn add spinner',
    import:
        "import 'package:<your_app>/ui/shadcn/components/spinner/spinner.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'text_animate',
    name: 'TextAnimate',
    category: 'display',
    description:
        'Stream-aware animated text renderer for incremental updates, plus a streaming markdown tail.',
    install: 'flutter_shadcn add text_animate',
    import:
        "import 'package:<your_app>/ui/shadcn/components/text_animate/text_animate.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'tracker',
    name: 'Tracker',
    category: 'display',
    description:
        'A row of coloured activity segments, each with a hover tooltip.',
    install: 'flutter_shadcn add tracker',
    import:
        "import 'package:<your_app>/ui/shadcn/components/tracker/tracker.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'tree',
    name: 'Tree',
    category: 'display',
    description:
        'Immutable hierarchical list with expand/collapse, selection and themed indent guides.',
    install: 'flutter_shadcn add tree',
    import: "import 'package:<your_app>/ui/shadcn/components/tree/tree.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'triple_dots',
    name: 'TripleDots',
    category: 'display',
    description: 'Row or column of small round dots, used as an ellipsis.',
    install: 'flutter_shadcn add triple_dots',
    import:
        "import 'package:<your_app>/ui/shadcn/components/triple_dots/triple_dots.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'autocomplete',
    name: 'AutoComplete',
    category: 'form',
    description:
        'Input feature that turns the field text into a popover-backed suggestion list with keyboard navigation and three replacement modes.',
    install: 'flutter_shadcn add autocomplete',
    import:
        "import 'package:<your_app>/ui/shadcn/components/autocomplete/autocomplete.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'checkbox',
    name: 'Checkbox',
    category: 'form',
    description:
        'Tri-state form checkbox with controlled and controller-driven modes, keyboard activation and form participation.',
    install: 'flutter_shadcn add checkbox',
    import:
        "import 'package:<your_app>/ui/shadcn/components/checkbox/checkbox.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'chip_input',
    name: 'ChipInput',
    category: 'form',
    description:
        'Token field: a widgets-only input whose values render as removable chips, with suggestion, validation and clipboard round-trips.',
    install: 'flutter_shadcn add chip_input',
    import:
        "import 'package:<your_app>/ui/shadcn/components/chip_input/chip_input.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'color_field',
    name: 'Color Field',
    category: 'form',
    description:
        'Custom-painted HSV/HSL gradient area with an optional transparency checkerboard and a themed ring.',
    install: 'flutter_shadcn add color_field',
    import:
        "import 'package:<your_app>/ui/shadcn/components/color_field/color_field.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'color_input',
    name: 'ColorInput',
    category: 'form',
    description:
        'Compact colour field: a colour well plus an editable hex text input that opens the full color_picker in a popover (desktop) or dialog.',
    install: 'flutter_shadcn add color_input',
    import:
        "import 'package:<your_app>/ui/shadcn/components/color_input/color_input.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'color_picker',
    name: 'ColorPicker',
    category: 'form',
    description:
        'Full colour picker: HSV/HSL pad, hue/alpha bars, RGB/HSL/HSV/HEX fields, optional alpha, colour history and screen sampling.',
    install: 'flutter_shadcn add color_picker',
    import:
        "import 'package:<your_app>/ui/shadcn/components/color_picker/color_picker.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'date_picker',
    name: 'DatePicker',
    category: 'form',
    description:
        'Single-date and date-span fields opening a calendar sheet (DatePickerDialog with month/year stepper) in a dialog or a popover, wired into the form system.',
    install: 'flutter_shadcn add date_picker',
    import:
        "import 'package:<your_app>/ui/shadcn/components/date_picker/date_picker.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'dropzone',
    name: 'Dropzone',
    category: 'form',
    description:
        'An upload surface: outline, upload icon, localized status line, optional hint and a browse button. Presentational — it takes a state, it does not listen to a drag stream.',
    install: 'flutter_shadcn add dropzone',
    import:
        "import 'package:<your_app>/ui/shadcn/components/dropzone/dropzone.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'file_picker',
    name: 'File Picker',
    category: 'form',
    description:
        'File selection surface (dropzone, tile or compact trigger) with validation, a concurrent upload queue and the FileUploadRow list — list or grid layout, caller-keyed groups, per-file icons.',
    install: 'flutter_shadcn add file_picker',
    import:
        "import 'package:<your_app>/ui/shadcn/components/file_picker/file_picker.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'form',
    name: 'ShadcnForm',
    category: 'form',
    description:
        'ShadcnForm scope, labelled field layouts, validators, controller and submission flow.',
    install: 'flutter_shadcn add form',
    import: "import 'package:<your_app>/ui/shadcn/components/form/form.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'formatted_input',
    name: 'FormattedInput',
    category: 'form',
    description:
        'Masked/segmented field (phone, date, card) built from static separators and small editable parts.',
    install: 'flutter_shadcn add formatted_input',
    import:
        "import 'package:<your_app>/ui/shadcn/components/formatted_input/formatted_input.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'formatter',
    name: 'Formatter',
    category: 'form',
    description:
        'Reusable text input formatters (uppercase/lowercase, numeric, math, HEX, time) plus selection clipping helpers.',
    install: 'flutter_shadcn add formatter',
    import:
        "import 'package:<your_app>/ui/shadcn/components/formatter/formatter.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'history',
    name: 'Color History',
    category: 'form',
    description: 'Recent-colour storage plus the swatch grid that reuses them.',
    install: 'flutter_shadcn add history',
    import:
        "import 'package:<your_app>/ui/shadcn/components/history/history.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'hsl',
    name: 'HSL Color Slider',
    category: 'form',
    description:
        'Gradient slider that controls hue, saturation, lightness, or alpha for HSL colours.',
    install: 'flutter_shadcn add hsl',
    import: "import 'package:<your_app>/ui/shadcn/components/hsl/hsl.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'hsv',
    name: 'HSV Color Slider',
    category: 'form',
    description:
        'Gradient slider that controls hue, saturation, value, or alpha for HSV colours.',
    install: 'flutter_shadcn add hsv',
    import: "import 'package:<your_app>/ui/shadcn/components/hsv/hsv.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'input',
    name: 'Input',
    category: 'form',
    description:
        'Widgets-only text field wrapping EditableText, with a pluggable feature system, form participation and a widgets-only selection menu.',
    install: 'flutter_shadcn add input',
    import:
        "import 'package:<your_app>/ui/shadcn/components/input/input.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'input_otp',
    name: 'InputOtp',
    category: 'form',
    description:
        'One-time-password input: one hidden field drives a row of character slots, with separators, obscuring, validation and form participation.',
    install: 'flutter_shadcn add input_otp',
    import:
        "import 'package:<your_app>/ui/shadcn/components/input_otp/input_otp.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'item_picker',
    name: 'ItemPicker',
    category: 'form',
    description:
        'Field that edits a value by picking one item from a grid or list, in a dialog or popover.',
    install: 'flutter_shadcn add item_picker',
    import:
        "import 'package:<your_app>/ui/shadcn/components/item_picker/item_picker.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'multi_select',
    name: 'MultiSelect',
    category: 'form',
    description:
        'A multi-selection dropdown built on select: checkbox popup rows (menu MenuCheckboxItem) that stay open while toggling, and removable chips in the trigger.',
    install: 'flutter_shadcn add multi_select',
    import:
        "import 'package:<your_app>/ui/shadcn/components/multi_select/multi_select.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'multiple_choice',
    name: 'Multiple Choice',
    category: 'form',
    description:
        'Selection scopes for single-choice and multi-choice trees, controlled or controller-driven.',
    install: 'flutter_shadcn add multiple_choice',
    import:
        "import 'package:<your_app>/ui/shadcn/components/multiple_choice/multiple_choice.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'object_input',
    name: 'Object Input',
    category: 'form',
    description:
        'Typed date, time and duration fields: locale-ordered numeric segments with a calendar dialog behind the date field.',
    install: 'flutter_shadcn add object_input',
    import:
        "import 'package:<your_app>/ui/shadcn/components/object_input/object_input.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'phone_input',
    name: 'PhoneInput',
    category: 'form',
    description:
        'Searchable country selector (flag + dial code) with a national-number field, wired into the form system.',
    install: 'flutter_shadcn add phone_input',
    import:
        "import 'package:<your_app>/ui/shadcn/components/phone_input/phone_input.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'radio_group',
    name: 'RadioGroup',
    category: 'form',
    description:
        'Single-select group with controlled and controller-driven modes, row and card item shapes, roving arrow-key traversal and form participation.',
    install: 'flutter_shadcn add radio_group',
    import:
        "import 'package:<your_app>/ui/shadcn/components/radio_group/radio_group.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'select',
    name: 'Select',
    category: 'form',
    description:
        "A single-selection dropdown picker. The trigger reuses the button variant table and the popover primitive; the popup is the menu component's surface and rows; the search field is the input component.",
    install: 'flutter_shadcn add select',
    import:
        "import 'package:<your_app>/ui/shadcn/components/select/select.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'slider',
    name: 'Slider',
    category: 'form',
    description:
        'Single- and range-value sliders with snap strategies, four visual variants, and keyboard/form support. Built on widgets gestures and CustomPaint — no Material Slider.',
    install: 'flutter_shadcn add slider',
    import:
        "import 'package:<your_app>/ui/shadcn/components/slider/slider.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'star_rating',
    name: 'Star Rating',
    category: 'form',
    description:
        'Interactive star rating with half-star snapping, keyboard stepping, drag preview and form participation.',
    install: 'flutter_shadcn add star_rating',
    import:
        "import 'package:<your_app>/ui/shadcn/components/star_rating/star_rating.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'switch',
    name: 'Switch',
    category: 'form',
    description:
        'Boolean form switch with controlled and controller-driven modes, sliding thumb, keyboard activation and form participation.',
    install: 'flutter_shadcn add switch',
    import:
        "import 'package:<your_app>/ui/shadcn/components/switch/switch.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'text_area',
    name: 'TextArea',
    category: 'form',
    description:
        'Multi-line text input: an Input with three-line defaults, a multiline keyboard and vertically centred content.',
    install: 'flutter_shadcn add text_area',
    import:
        "import 'package:<your_app>/ui/shadcn/components/text_area/text_area.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'time_picker',
    name: 'TimePicker',
    category: 'form',
    description:
        'Clock-time and duration fields opening digit-field sheets (hour/minute/second plus AM/PM, day/hour/minute/second) in a dialog or a popover, wired into the form system.',
    install: 'flutter_shadcn add time_picker',
    import:
        "import 'package:<your_app>/ui/shadcn/components/time_picker/time_picker.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'accordion',
    name: 'Accordion',
    category: 'layout',
    description:
        'Single-expansion accordion with animated items, themed dividers and a keyboard-accessible trigger.',
    install: 'flutter_shadcn add accordion',
    import:
        "import 'package:<your_app>/ui/shadcn/components/accordion/accordion.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'alert',
    name: 'Alert',
    category: 'layout',
    description:
        'Bordered callout banner with base and destructive variants, a leading slot, title, content and trailing slot.',
    install: 'flutter_shadcn add alert',
    import:
        "import 'package:<your_app>/ui/shadcn/components/alert/alert.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'app',
    name: 'App',
    category: 'layout',
    description:
        'App shell over WidgetsApp that installs ShadcnTheme, ComponentThemes, the overlay manager and shadcn localizations, plus the ShadcnUI default text/icon scope.',
    install: 'flutter_shadcn add app',
    import: "import 'package:<your_app>/ui/shadcn/components/app/app.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'card',
    name: 'Card',
    category: 'layout',
    description:
        'Rounded bordered surface with the shadcn header, title, description, content and footer slots.',
    install: 'flutter_shadcn add card',
    import: "import 'package:<your_app>/ui/shadcn/components/card/card.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'card_image',
    name: 'Card Image',
    category: 'layout',
    description:
        'A pressable card pairing an image with a leading/title/subtitle/trailing text block.',
    install: 'flutter_shadcn add card_image',
    import:
        "import 'package:<your_app>/ui/shadcn/components/card_image/card_image.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'collapsible',
    name: 'Collapsible',
    category: 'layout',
    description:
        'Expandable section with a trigger, hidden content panes and controlled or uncontrolled expansion.',
    install: 'flutter_shadcn add collapsible',
    import:
        "import 'package:<your_app>/ui/shadcn/components/collapsible/collapsible.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'filter_bar',
    name: 'FilterBar',
    category: 'layout',
    description:
        'Search, sort, date-range, custom filters and chips in one bar, with a clear action and a mobile sheet presentation; backed by a typed filter engine.',
    install: 'flutter_shadcn add filter_bar',
    import:
        "import 'package:<your_app>/ui/shadcn/components/filter_bar/filter_bar.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'group',
    name: 'Group',
    category: 'layout',
    description:
        'Absolute-position layout surface that places children at explicit offsets and sizes.',
    install: 'flutter_shadcn add group',
    import:
        "import 'package:<your_app>/ui/shadcn/components/group/group.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'media_query',
    name: 'MediaQueryVisibility',
    category: 'layout',
    description:
        'Shows one child while the viewport width is inside a range and another when it is not.',
    install: 'flutter_shadcn add media_query',
    import:
        "import 'package:<your_app>/ui/shadcn/components/media_query/media_query.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'outlined_container',
    name: 'Outlined Container',
    category: 'layout',
    description:
        'Animated outlined surface with token-derived border, optional translucency and backdrop blur, plus dashed border helpers.',
    install: 'flutter_shadcn add outlined_container',
    import:
        "import 'package:<your_app>/ui/shadcn/components/outlined_container/outlined_container.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'overflow_marquee',
    name: 'Overflow Marquee',
    category: 'layout',
    description:
        'Auto-scrolls content that overflows its container, horizontally or vertically, with soft edge fades and reduced-motion support.',
    install: 'flutter_shadcn add overflow_marquee',
    import:
        "import 'package:<your_app>/ui/shadcn/components/overflow_marquee/overflow_marquee.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'resizable',
    name: 'Resizable',
    category: 'layout',
    description:
        'Split panes with draggable dividers, absolute or flexible sizing, min/max constraints, collapse and external controllers.',
    install: 'flutter_shadcn add resizable',
    import:
        "import 'package:<your_app>/ui/shadcn/components/resizable/resizable.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'scaffold',
    name: 'Scaffold',
    category: 'layout',
    description:
        'App screen shell with header/footer bars, a loading bar and keyboard avoidance, plus the AppBar title bar.',
    install: 'flutter_shadcn add scaffold',
    import:
        "import 'package:<your_app>/ui/shadcn/components/scaffold/scaffold.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'scrollable',
    name: 'Scrollable',
    category: 'layout',
    description:
        'Notification-driven edge-fade viewport for any scrollable subtree.',
    install: 'flutter_shadcn add scrollable',
    import:
        "import 'package:<your_app>/ui/shadcn/components/scrollable/scrollable.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'scrollable_client',
    name: 'Scrollable Client',
    category: 'layout',
    description:
        'Two-dimensional scroll surface with a builder that receives the current offset and viewport size.',
    install: 'flutter_shadcn add scrollable_client',
    import:
        "import 'package:<your_app>/ui/shadcn/components/scrollable_client/scrollable_client.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'sortable',
    name: 'Sortable',
    category: 'layout',
    description:
        'Drag-and-drop reordering primitives: a SortableLayer coordinates pan-driven sessions and renders the ghost, while Sortable<T> reports per-edge drop intents.',
    install: 'flutter_shadcn add sortable',
    import:
        "import 'package:<your_app>/ui/shadcn/components/sortable/sortable.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'stage_container',
    name: 'Stage Container',
    category: 'layout',
    description:
        'Responsive container that snaps content to breakpoint widths.',
    install: 'flutter_shadcn add stage_container',
    import:
        "import 'package:<your_app>/ui/shadcn/components/stage_container/stage_container.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'steps',
    name: 'Steps',
    category: 'layout',
    description: 'Vertical numbered step list joined by a connector line.',
    install: 'flutter_shadcn add steps',
    import:
        "import 'package:<your_app>/ui/shadcn/components/steps/steps.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'table',
    name: 'Table',
    category: 'layout',
    description:
        'Themed data grid with span-aware cells, frozen rows/columns, scrolling and optional column/row resizing.',
    install: 'flutter_shadcn add table',
    import:
        "import 'package:<your_app>/ui/shadcn/components/table/table.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'timeline',
    name: 'Timeline',
    category: 'layout',
    description:
        'Vertical three-column event timeline: time label, indicator dot with connector, title and content.',
    install: 'flutter_shadcn add timeline',
    import:
        "import 'package:<your_app>/ui/shadcn/components/timeline/timeline.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'window',
    name: 'Window',
    category: 'layout',
    description:
        'Desktop-style window frame with drag, resize, maximize, close, z-order, focus and edge snapping, hosted by a WindowNavigator.',
    install: 'flutter_shadcn add window',
    import:
        "import 'package:<your_app>/ui/shadcn/components/window/window.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'breadcrumb',
    name: 'Breadcrumb',
    category: 'navigation',
    description:
        'Horizontal trail of crumbs with a chevron or slash separator.',
    install: 'flutter_shadcn add breadcrumb',
    import:
        "import 'package:<your_app>/ui/shadcn/components/breadcrumb/breadcrumb.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'navigation_bar',
    name: 'Navigation Bar',
    category: 'navigation',
    description:
        'Navigation container for bars, rails and sidebars: selectable items with labels, groups, collapsibles, dividers, slots and arrow-key roving.',
    install: 'flutter_shadcn add navigation_bar',
    import:
        "import 'package:<your_app>/ui/shadcn/components/navigation_bar/navigation_bar.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'navigation_menu',
    name: 'NavigationMenu',
    category: 'navigation',
    description:
        'Horizontal navigation bar whose entries open themed popover content on hover or press.',
    install: 'flutter_shadcn add navigation_menu',
    import:
        "import 'package:<your_app>/ui/shadcn/components/navigation_menu/navigation_menu.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'page_route',
    name: 'ShadcnPageRoute',
    category: 'navigation',
    description:
        'Widgets-only page route and declarative Page with the shadcn fade + slide transition.',
    install: 'flutter_shadcn add page_route',
    import:
        "import 'package:<your_app>/ui/shadcn/components/page_route/page_route.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'pagination',
    name: 'Pagination',
    category: 'navigation',
    description:
        'Previous/next controls with a clamped window of page buttons.',
    install: 'flutter_shadcn add pagination',
    import:
        "import 'package:<your_app>/ui/shadcn/components/pagination/pagination.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'stepper',
    name: 'Stepper',
    category: 'navigation',
    description:
        'Multi-step flow with numbered indicators and connectors, horizontal or vertical, controlled or controller-driven.',
    install: 'flutter_shadcn add stepper',
    import:
        "import 'package:<your_app>/ui/shadcn/components/stepper/stepper.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'switcher',
    name: 'Switcher',
    category: 'navigation',
    description:
        'Swipeable view that animates between child widgets along a chosen axis.',
    install: 'flutter_shadcn add switcher',
    import:
        "import 'package:<your_app>/ui/shadcn/components/switcher/switcher.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'tabs',
    name: 'Tabs',
    category: 'navigation',
    description:
        'Pill tab strip with roving arrow-key navigation, plus a sortable IDE-style tab pane over a content card.',
    install: 'flutter_shadcn add tabs',
    import: "import 'package:<your_app>/ui/shadcn/components/tabs/tabs.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'alert_dialog',
    name: 'AlertDialog',
    category: 'overlay',
    description:
        'Shadcn alert dialog: icon, title, description and an action footer on top of the dialog route.',
    install: 'flutter_shadcn add alert_dialog',
    import:
        "import 'package:<your_app>/ui/shadcn/components/alert_dialog/alert_dialog.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'anchor',
    name: 'Anchor',
    category: 'overlay',
    description:
        'Describes the point an overlay positions itself against and tracks it while it moves.',
    install: 'flutter_shadcn add anchor',
    import:
        "import 'package:<your_app>/ui/shadcn/components/anchor/anchor.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'backdrop_transform',
    name: 'BackdropTransform',
    category: 'overlay',
    description:
        'Strategy describing how the content behind a sheet or drawer is transformed while it opens.',
    install: 'flutter_shadcn add backdrop_transform',
    import:
        "import 'package:<your_app>/ui/shadcn/components/backdrop_transform/backdrop_transform.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'context_menu',
    name: 'ContextMenu',
    category: 'overlay',
    description:
        'A menu shown at the pointer on right-click (long-press on touch platforms), plus the showShadcnContextMenu helper. Rows, traversal and the popup surface come from the menu component.',
    install: 'flutter_shadcn add context_menu',
    import:
        "import 'package:<your_app>/ui/shadcn/components/context_menu/context_menu.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'dialog',
    name: 'Dialog',
    category: 'overlay',
    description: 'Modal dialog route and themed card shell.',
    install: 'flutter_shadcn add dialog',
    import:
        "import 'package:<your_app>/ui/shadcn/components/dialog/dialog.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'drawer',
    name: 'Drawer',
    category: 'overlay',
    description:
        'Modal panel that slides in from a screen edge, plus an expanding sheet variant.',
    install: 'flutter_shadcn add drawer',
    import:
        "import 'package:<your_app>/ui/shadcn/components/drawer/drawer.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'drawer_container',
    name: 'Drawer Container',
    category: 'overlay',
    description:
        'Reusable drawer/sheet chrome (edge border, outer corners, drag handle, barrier wash) for pinned sheets and drawer overlays.',
    install: 'flutter_shadcn add drawer_container',
    import:
        "import 'package:<your_app>/ui/shadcn/components/drawer_container/drawer_container.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'dropdown_menu',
    name: 'DropdownMenu',
    category: 'overlay',
    description:
        'A menu surface anchored below the widget that opened it, plus the showShadcnDropdown helper. Rows, traversal and the popup surface come from the menu component.',
    install: 'flutter_shadcn add dropdown_menu',
    import:
        "import 'package:<your_app>/ui/shadcn/components/dropdown_menu/dropdown_menu.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'eye_dropper',
    name: 'Eye Dropper',
    category: 'overlay',
    description:
        'Samples any pixel of the wrapped subtree with a magnified preview and reports the picked colour (optionally into a colour history).',
    install: 'flutter_shadcn add eye_dropper',
    import:
        "import 'package:<your_app>/ui/shadcn/components/eye_dropper/eye_dropper.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'gooey_toast',
    name: 'Gooey Toast',
    category: 'overlay',
    description:
        'Gooey-style transient notifications: a compact pill whose metaball silhouette morphs into an expanded body, built on the shared toast queue.',
    install: 'flutter_shadcn add gooey_toast',
    import:
        "import 'package:<your_app>/ui/shadcn/components/gooey_toast/gooey_toast.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'hover_card',
    name: 'HoverCard',
    category: 'overlay',
    description:
        'Rich preview card shown while the pointer rests on its child, presented through the popover machinery with themed timing and placement.',
    install: 'flutter_shadcn add hover_card',
    import:
        "import 'package:<your_app>/ui/shadcn/components/hover_card/hover_card.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'menu',
    name: 'Menu',
    category: 'overlay',
    description:
        'Keyboard-navigable menu family: MenuGroup with roving focus and typeahead; MenuButton, MenuCheckboxItem, MenuRadioItem, MenuLabel, MenuShortcut, MenuSeparator and MenuSub rows; showShadcnMenu helper; MenuPopup surface. Owns MenuPopupTheme and MenubarTheme for the wave-D menu consumers.',
    install: 'flutter_shadcn add menu',
    import: "import 'package:<your_app>/ui/shadcn/components/menu/menu.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'menubar',
    name: 'Menubar',
    category: 'overlay',
    description:
        "A horizontal bar of menu triggers whose submenus open below the bar. Rows, keyboard traversal and popup surfaces are the menu component's; MenubarTheme is owned by menu and resolved here.",
    install: 'flutter_shadcn add menubar',
    import:
        "import 'package:<your_app>/ui/shadcn/components/menubar/menubar.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'overlay_configuration',
    name: 'Overlay Configuration',
    category: 'overlay',
    description:
        'Describe what overlay to show and how (popover, drawer, sheet, dialog, tooltip) behind one configuration object, plus showOverlay and OverlayController.',
    install: 'flutter_shadcn add overlay_configuration',
    import:
        "import 'package:<your_app>/ui/shadcn/components/overlay_configuration/overlay_configuration.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'popup',
    name: 'Popup',
    category: 'overlay',
    description:
        "An anchored floating surface for arbitrary content: the menu component's MenuPopup (re-exported) plus showShadcnPopup, a generic helper with Escape/outside-tap dismissal.",
    install: 'flutter_shadcn add popup',
    import:
        "import 'package:<your_app>/ui/shadcn/components/popup/popup.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'refresh_trigger',
    name: 'RefreshTrigger',
    category: 'overlay',
    description:
        'Pull-to-refresh wrapper for any scrollable, with a themed indicator pill and programmatic refresh.',
    install: 'flutter_shadcn add refresh_trigger',
    import:
        "import 'package:<your_app>/ui/shadcn/components/refresh_trigger/refresh_trigger.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'spell_check_suggestions_toolbar',
    name: 'SpellCheckSuggestionsToolbar',
    category: 'overlay',
    description:
        'Menu-backed toolbar for the spell check replacements of the misspelled word under an editable text cursor: up to three suggestion rows in the menu popup surface.',
    install: 'flutter_shadcn add spell_check_suggestions_toolbar',
    import:
        "import 'package:<your_app>/ui/shadcn/components/spell_check_suggestions_toolbar/spell_check_suggestions_toolbar.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'swiper',
    name: 'Swiper',
    category: 'overlay',
    description: 'Swipe-to-open wrapper that reveals a drawer or sheet panel.',
    install: 'flutter_shadcn add swiper',
    import:
        "import 'package:<your_app>/ui/shadcn/components/swiper/swiper.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'toast',
    name: 'Toast',
    category: 'overlay',
    description:
        'Transient, non-blocking notifications anchored to a screen edge.',
    install: 'flutter_shadcn add toast',
    import:
        "import 'package:<your_app>/ui/shadcn/components/toast/toast.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'tooltip',
    name: 'Tooltip',
    category: 'overlay',
    description:
        'Delayed hover label presented through the popover machinery, plus the themed TooltipContainer surface and the tooltip overlay handler.',
    install: 'flutter_shadcn add tooltip',
    import:
        "import 'package:<your_app>/ui/shadcn/components/tooltip/tooltip.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'alpha',
    name: 'Alpha',
    category: 'utility',
    description: 'Checkerboard painter for transparency indicators.',
    install: 'flutter_shadcn add alpha',
    import:
        "import 'package:<your_app>/ui/shadcn/components/alpha/alpha.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'async',
    name: 'FutureOrBuilder',
    category: 'utility',
    description:
        'Renders a value that may already be available or may still be loading through one builder.',
    install: 'flutter_shadcn add async',
    import:
        "import 'package:<your_app>/ui/shadcn/components/async/async.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'color',
    name: 'Color',
    category: 'utility',
    description:
        'The ColorDerivative colour model shared by the colour components: space-preserving RGB/HSV/HSL edits and hex parsing.',
    install: 'flutter_shadcn add color',
    import:
        "import 'package:<your_app>/ui/shadcn/components/color/color.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'error_system',
    name: 'Error System',
    category: 'utility',
    description:
        'Structured error models, rule-based mapping, app/screen error channels and the matching UI surfaces.',
    install: 'flutter_shadcn add error_system',
    import:
        "import 'package:<your_app>/ui/shadcn/components/error_system/error_system.dart';",
    fileCount: 3,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'locale_utils',
    name: 'Locale Utils',
    category: 'utility',
    description:
        'Byte-size formatting against a configurable unit table (decimal, binary or custom).',
    install: 'flutter_shadcn add locale_utils',
    import:
        "import 'package:<your_app>/ui/shadcn/components/locale_utils/locale_utils.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
  DocsComponent(
    id: 'timeline_animation',
    name: 'Timeline Animation',
    category: 'utility',
    description:
        "Typed keyframe timeline: turns an AnimationController's 0..1 progress into values segment by segment.",
    install: 'flutter_shadcn add timeline_animation',
    import:
        "import 'package:<your_app>/ui/shadcn/components/timeline_animation/timeline_animation.dart';",
    fileCount: 1,
    stability: 'stable',
  ),
];

/// The 42 theme presets in `themes/index.json` order.
const List<DocsPreset> kPresets = <DocsPreset>[
  DocsPreset(
    id: 'amber-minimal',
    name: 'Amber Minimal',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'amethyst-haze',
    name: 'Amethyst Haze',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'bold-tech',
    name: 'Bold Tech',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'bubblegum',
    name: 'Bubblegum',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'caffeine',
    name: 'Caffeine',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'candyland',
    name: 'Candyland',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'catppuccin',
    name: 'Catppuccin',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(id: 'claude', name: 'Claude', modes: <String>['light', 'dark']),
  DocsPreset(
    id: 'claymorphism',
    name: 'Claymorphism',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'clean-slate',
    name: 'Clean Slate',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'cosmic-night',
    name: 'Cosmic Night',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'cyberpunk',
    name: 'Cyberpunk',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'darkmatter',
    name: 'Darkmatter',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(id: 'doom-64', name: 'Doom 64', modes: <String>['light', 'dark']),
  DocsPreset(
    id: 'elegant-luxury',
    name: 'Elegant Luxury',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'graphite',
    name: 'Graphite',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'kodama-grove',
    name: 'Kodama Grove',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'midnight-bloom',
    name: 'Midnight Bloom',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'mocha-mousse',
    name: 'Mocha Mousse',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'modern-minimal',
    name: 'Modern Minimal',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(id: 'mono', name: 'Mono', modes: <String>['light', 'dark']),
  DocsPreset(id: 'nature', name: 'Nature', modes: <String>['light', 'dark']),
  DocsPreset(
    id: 'neo-brutalism',
    name: 'Neo Brutalism',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'northern-lights',
    name: 'Northern Lights',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'notebook',
    name: 'Notebook',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'ocean-breeze',
    name: 'Ocean Breeze',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'pastel-dreams',
    name: 'Pastel Dreams',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'perpetuity',
    name: 'Perpetuity',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'quantum-rose',
    name: 'Quantum Rose',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'retro-arcade',
    name: 'Retro Arcade',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'sage-garden',
    name: 'Sage Garden',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'soft-pop',
    name: 'Soft Pop',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'solar-dusk',
    name: 'Solar Dusk',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'starry-night',
    name: 'Starry Night',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'sunset-horizon',
    name: 'Sunset Horizon',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'supabase',
    name: 'Supabase',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(id: 't3-chat', name: 'T3 Chat', modes: <String>['light', 'dark']),
  DocsPreset(
    id: 'tangerine',
    name: 'Tangerine',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(id: 'twitter', name: 'Twitter', modes: <String>['light', 'dark']),
  DocsPreset(id: 'vercel', name: 'Vercel', modes: <String>['light', 'dark']),
  DocsPreset(
    id: 'vintage-paper',
    name: 'Vintage Paper',
    modes: <String>['light', 'dark'],
  ),
  DocsPreset(
    id: 'violet-bloom',
    name: 'Violet Bloom',
    modes: <String>['light', 'dark'],
  ),
];

/// All 118 components as index-grid links, alphabetical by name.
const List<DocsComponentLink> kComponentLinks = <DocsComponentLink>[
  DocsComponentLink(id: 'accordion', name: 'Accordion'),
  DocsComponentLink(id: 'alert', name: 'Alert'),
  DocsComponentLink(id: 'alert_dialog', name: 'AlertDialog'),
  DocsComponentLink(id: 'alpha', name: 'Alpha'),
  DocsComponentLink(id: 'anchor', name: 'Anchor'),
  DocsComponentLink(id: 'app', name: 'App'),
  DocsComponentLink(id: 'autocomplete', name: 'AutoComplete'),
  DocsComponentLink(id: 'avatar', name: 'Avatar'),
  DocsComponentLink(id: 'backdrop_transform', name: 'BackdropTransform'),
  DocsComponentLink(id: 'badge', name: 'Badge'),
  DocsComponentLink(id: 'border_loading', name: 'Border Loading'),
  DocsComponentLink(id: 'breadcrumb', name: 'Breadcrumb'),
  DocsComponentLink(id: 'button', name: 'Button'),
  DocsComponentLink(id: 'calendar', name: 'Calendar'),
  DocsComponentLink(id: 'card', name: 'Card'),
  DocsComponentLink(id: 'card_image', name: 'Card Image'),
  DocsComponentLink(id: 'carousel', name: 'Carousel'),
  DocsComponentLink(id: 'chat', name: 'Chat'),
  DocsComponentLink(id: 'checkbox', name: 'Checkbox'),
  DocsComponentLink(id: 'chip', name: 'Chip'),
  DocsComponentLink(id: 'chip_input', name: 'ChipInput'),
  DocsComponentLink(id: 'patch', name: 'ClickDetector'),
  DocsComponentLink(id: 'code_snippet', name: 'CodeSnippet'),
  DocsComponentLink(id: 'collapsible', name: 'Collapsible'),
  DocsComponentLink(id: 'color', name: 'Color'),
  DocsComponentLink(id: 'color_field', name: 'Color Field'),
  DocsComponentLink(id: 'history', name: 'Color History'),
  DocsComponentLink(id: 'color_input', name: 'ColorInput'),
  DocsComponentLink(id: 'color_picker', name: 'ColorPicker'),
  DocsComponentLink(id: 'command', name: 'Command'),
  DocsComponentLink(id: 'context_menu', name: 'ContextMenu'),
  DocsComponentLink(id: 'country_flag', name: 'CountryFlag'),
  DocsComponentLink(id: 'date_picker', name: 'DatePicker'),
  DocsComponentLink(id: 'dialog', name: 'Dialog'),
  DocsComponentLink(id: 'divider', name: 'Divider'),
  DocsComponentLink(id: 'dot_indicator', name: 'DotIndicator'),
  DocsComponentLink(id: 'drawer', name: 'Drawer'),
  DocsComponentLink(id: 'drawer_container', name: 'Drawer Container'),
  DocsComponentLink(id: 'dropdown_menu', name: 'DropdownMenu'),
  DocsComponentLink(id: 'dropzone', name: 'Dropzone'),
  DocsComponentLink(id: 'empty_state', name: 'EmptyState'),
  DocsComponentLink(id: 'error_system', name: 'Error System'),
  DocsComponentLink(id: 'eye_dropper', name: 'Eye Dropper'),
  DocsComponentLink(id: 'feature_carousel', name: 'Feature Carousel'),
  DocsComponentLink(id: 'file_diff_viewer', name: 'File Diff Viewer'),
  DocsComponentLink(id: 'file_picker', name: 'File Picker'),
  DocsComponentLink(id: 'filter_bar', name: 'FilterBar'),
  DocsComponentLink(id: 'formatted_input', name: 'FormattedInput'),
  DocsComponentLink(id: 'formatter', name: 'Formatter'),
  DocsComponentLink(id: 'async', name: 'FutureOrBuilder'),
  DocsComponentLink(id: 'gooey_toast', name: 'Gooey Toast'),
  DocsComponentLink(id: 'group', name: 'Group'),
  DocsComponentLink(id: 'hover_card', name: 'HoverCard'),
  DocsComponentLink(id: 'hsl', name: 'HSL Color Slider'),
  DocsComponentLink(id: 'hsv', name: 'HSV Color Slider'),
  DocsComponentLink(id: 'icon', name: 'Icon'),
  DocsComponentLink(id: 'input', name: 'Input'),
  DocsComponentLink(id: 'input_otp', name: 'InputOtp'),
  DocsComponentLink(id: 'item_picker', name: 'ItemPicker'),
  DocsComponentLink(id: 'keyboard_shortcut', name: 'KeyboardShortcut'),
  DocsComponentLink(id: 'locale_utils', name: 'Locale Utils'),
  DocsComponentLink(id: 'markdown', name: 'Markdown'),
  DocsComponentLink(id: 'media_query', name: 'MediaQueryVisibility'),
  DocsComponentLink(id: 'menu', name: 'Menu'),
  DocsComponentLink(id: 'menubar', name: 'Menubar'),
  DocsComponentLink(id: 'multiple_choice', name: 'Multiple Choice'),
  DocsComponentLink(id: 'multi_select', name: 'MultiSelect'),
  DocsComponentLink(id: 'navigation_bar', name: 'Navigation Bar'),
  DocsComponentLink(id: 'navigation_menu', name: 'NavigationMenu'),
  DocsComponentLink(id: 'number_ticker', name: 'NumberTicker'),
  DocsComponentLink(id: 'object_input', name: 'Object Input'),
  DocsComponentLink(id: 'outlined_container', name: 'Outlined Container'),
  DocsComponentLink(id: 'overflow_marquee', name: 'Overflow Marquee'),
  DocsComponentLink(id: 'overlay_configuration', name: 'Overlay Configuration'),
  DocsComponentLink(id: 'pagination', name: 'Pagination'),
  DocsComponentLink(id: 'phone_input', name: 'PhoneInput'),
  DocsComponentLink(id: 'pinned_sheet', name: 'Pinned Sheet'),
  DocsComponentLink(id: 'popup', name: 'Popup'),
  DocsComponentLink(id: 'progress', name: 'Progress'),
  DocsComponentLink(id: 'radio_group', name: 'RadioGroup'),
  DocsComponentLink(id: 'refresh_trigger', name: 'RefreshTrigger'),
  DocsComponentLink(id: 'resizable', name: 'Resizable'),
  DocsComponentLink(id: 'scaffold', name: 'Scaffold'),
  DocsComponentLink(id: 'scrollview', name: 'Scroll View Interceptor'),
  DocsComponentLink(id: 'scrollable', name: 'Scrollable'),
  DocsComponentLink(id: 'scrollable_client', name: 'Scrollable Client'),
  DocsComponentLink(id: 'scrollbar', name: 'Scrollbar'),
  DocsComponentLink(id: 'select', name: 'Select'),
  DocsComponentLink(id: 'selectable', name: 'SelectableText'),
  DocsComponentLink(id: 'form', name: 'ShadcnForm'),
  DocsComponentLink(id: 'image', name: 'ShadcnImage'),
  DocsComponentLink(id: 'page_route', name: 'ShadcnPageRoute'),
  DocsComponentLink(id: 'skeleton', name: 'Skeleton'),
  DocsComponentLink(id: 'slider', name: 'Slider'),
  DocsComponentLink(id: 'sortable', name: 'Sortable'),
  DocsComponentLink(
    id: 'spell_check_suggestions_toolbar',
    name: 'SpellCheckSuggestionsToolbar',
  ),
  DocsComponentLink(id: 'spinner', name: 'Spinner'),
  DocsComponentLink(id: 'stage_container', name: 'Stage Container'),
  DocsComponentLink(id: 'star_rating', name: 'Star Rating'),
  DocsComponentLink(id: 'stepper', name: 'Stepper'),
  DocsComponentLink(id: 'steps', name: 'Steps'),
  DocsComponentLink(id: 'swiper', name: 'Swiper'),
  DocsComponentLink(id: 'switch', name: 'Switch'),
  DocsComponentLink(id: 'switcher', name: 'Switcher'),
  DocsComponentLink(id: 'table', name: 'Table'),
  DocsComponentLink(id: 'tabs', name: 'Tabs'),
  DocsComponentLink(id: 'text_animate', name: 'TextAnimate'),
  DocsComponentLink(id: 'text_area', name: 'TextArea'),
  DocsComponentLink(id: 'timeline', name: 'Timeline'),
  DocsComponentLink(id: 'timeline_animation', name: 'Timeline Animation'),
  DocsComponentLink(id: 'time_picker', name: 'TimePicker'),
  DocsComponentLink(id: 'toast', name: 'Toast'),
  DocsComponentLink(id: 'toggle', name: 'Toggle'),
  DocsComponentLink(id: 'tooltip', name: 'Tooltip'),
  DocsComponentLink(id: 'tracker', name: 'Tracker'),
  DocsComponentLink(id: 'tree', name: 'Tree'),
  DocsComponentLink(id: 'triple_dots', name: 'TripleDots'),
  DocsComponentLink(id: 'window', name: 'Window'),
];

/// Catalog categories, count descending then id.
const List<DocsCategory> kCategories = <DocsCategory>[
  DocsCategory(id: 'form', count: 29),
  DocsCategory(id: 'display', count: 28),
  DocsCategory(id: 'layout', count: 21),
  DocsCategory(id: 'overlay', count: 20),
  DocsCategory(id: 'navigation', count: 8),
  DocsCategory(id: 'control', count: 6),
  DocsCategory(id: 'utility', count: 6),
];

/// Stats band values, each with its derivation.
const DocsStats kStats = DocsStats(
  components: 118, // manifest entries
  presets: 42, // themes/index.json entries
  materialImports: 0, // registry import directives
  modes: 2, // distinct preset modes
);
