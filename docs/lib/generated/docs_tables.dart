// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/components/<id>/README.md
//   * flutter_shadcn_kit/lib/registry/manifests/registry.json
//   * docs/tool/cli_snapshot.txt
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// Keyboard rows are a conservative heuristic over README sections
// whose heading matches keyboard|a11y|accessib|behavio(u)r;
// components with no rows are listed in kKeyboardGaps and MUST NOT
// be hand-filled — extend the component README instead.

/// One keyboard/a11y row parsed from a README.
class DocsKeyboardRow {
  /// Creates the row.
  const DocsKeyboardRow({
    required this.keys,
    required this.action,
    required this.source,
  });

  /// Key or key combination (`ArrowDown / ArrowUp`).
  final String keys;

  /// What the key does.
  final String action;

  /// README section the row came from.
  final String source;
}

/// Registry layer a dependency belongs to.
enum DocsDepKind {
  /// Another component (flagged edge, e.g. tabs -> sortable).
  component,

  /// Shared primitive.
  primitive,

  /// Foundation layer unit.
  foundation,

  /// Theme layer unit.
  theme,
}

/// One dependency chip.
class DocsDep {
  /// Creates a dependency chip.
  const DocsDep({required this.id, required this.kind});

  /// Unit id (`clickable`, `button`, `theme`).
  final String id;

  /// Owning layer.
  final DocsDepKind kind;
}

/// One flag of a CLI command section.
class DocsCliFlag {
  /// Creates the flag.
  const DocsCliFlag({
    required this.name,
    this.alias,
    this.placeholder,
    required this.description,
  });

  /// Long flag name (`--dry-run`).
  final String name;

  /// Short alias (`-h`), or null.
  final String? alias;

  /// Value placeholder (`<path>`), or null.
  final String? placeholder;

  /// One-line description.
  final String description;
}

/// One command section of cli_snapshot.txt.
class DocsCliCommand {
  /// Creates the command.
  const DocsCliCommand({
    required this.label,
    required this.invocation,
    required this.usage,
    required this.summary,
    required this.helpText,
    required this.flags,
  });

  /// Invocation without `--help` (`flutter_shadcn add`).
  final String label;

  /// Full invocation line.
  final String invocation;

  /// `Usage:` string.
  final String usage;

  /// First description line of the section.
  final String summary;

  /// Section body verbatim (renders in `CodeSnippet`).
  final String helpText;

  /// Parsed flags.
  final List<DocsCliFlag> flags;
}

/// Keyboard/a11y rows keyed by component id (empty = gap).
const Map<String, List<DocsKeyboardRow>>
kKeyboardRows = <String, List<DocsKeyboardRow>>{
  'button': <DocsKeyboardRow>[],
  'command': <DocsKeyboardRow>[],
  'patch': <DocsKeyboardRow>[],
  'scrollbar': <DocsKeyboardRow>[],
  'scrollview': <DocsKeyboardRow>[],
  'toggle': <DocsKeyboardRow>[],
  'avatar': <DocsKeyboardRow>[],
  'badge': <DocsKeyboardRow>[],
  'border_loading': <DocsKeyboardRow>[],
  'calendar': <DocsKeyboardRow>[
    DocsKeyboardRow(
      keys: 'ArrowLeft / ArrowRight',
      action: 'one day, wrapping at the row edge',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'ArrowUp / ArrowDown',
      action: 'one week',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'Home / End',
      action: 'the first or last day of the focused week',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'PageUp / PageDown',
      action: 'one month',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'Enter / Space',
      action: 'select the focused day',
      source: 'Keyboard',
    ),
  ],
  'carousel': <DocsKeyboardRow>[],
  'chat': <DocsKeyboardRow>[],
  'chip': <DocsKeyboardRow>[],
  'code_snippet': <DocsKeyboardRow>[],
  'country_flag': <DocsKeyboardRow>[],
  'divider': <DocsKeyboardRow>[],
  'dot_indicator': <DocsKeyboardRow>[],
  'empty_state': <DocsKeyboardRow>[],
  'feature_carousel': <DocsKeyboardRow>[],
  'file_diff_viewer': <DocsKeyboardRow>[],
  'icon': <DocsKeyboardRow>[],
  'image': <DocsKeyboardRow>[],
  'keyboard_shortcut': <DocsKeyboardRow>[],
  'markdown': <DocsKeyboardRow>[],
  'number_ticker': <DocsKeyboardRow>[],
  'pinned_sheet': <DocsKeyboardRow>[],
  'progress': <DocsKeyboardRow>[],
  'selectable': <DocsKeyboardRow>[],
  'skeleton': <DocsKeyboardRow>[],
  'spinner': <DocsKeyboardRow>[],
  'text_animate': <DocsKeyboardRow>[],
  'tracker': <DocsKeyboardRow>[],
  'tree': <DocsKeyboardRow>[],
  'triple_dots': <DocsKeyboardRow>[],
  'autocomplete': <DocsKeyboardRow>[
    DocsKeyboardRow(
      keys: 'ArrowDown / ArrowUp',
      action: 'move the highlight (wraps)',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'Enter',
      action: 'apply the highlighted suggestion',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'Escape',
      action: 'close the list',
      source: 'Keyboard',
    ),
  ],
  'checkbox': <DocsKeyboardRow>[],
  'chip_input': <DocsKeyboardRow>[],
  'color_field': <DocsKeyboardRow>[],
  'color_input': <DocsKeyboardRow>[],
  'color_picker': <DocsKeyboardRow>[],
  'date_picker': <DocsKeyboardRow>[],
  'dropzone': <DocsKeyboardRow>[],
  'file_picker': <DocsKeyboardRow>[],
  'form': <DocsKeyboardRow>[],
  'formatted_input': <DocsKeyboardRow>[],
  'formatter': <DocsKeyboardRow>[],
  'history': <DocsKeyboardRow>[],
  'hsl': <DocsKeyboardRow>[],
  'hsv': <DocsKeyboardRow>[],
  'input': <DocsKeyboardRow>[],
  'input_otp': <DocsKeyboardRow>[],
  'item_picker': <DocsKeyboardRow>[],
  'multi_select': <DocsKeyboardRow>[],
  'multiple_choice': <DocsKeyboardRow>[],
  'object_input': <DocsKeyboardRow>[],
  'phone_input': <DocsKeyboardRow>[],
  'radio_group': <DocsKeyboardRow>[
    DocsKeyboardRow(
      keys: 'ArrowDown / ArrowRight',
      action: 'select the next enabled item and focus it',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'ArrowUp / ArrowLeft',
      action: 'select the previous enabled item and focus it',
      source: 'Keyboard',
    ),
    DocsKeyboardRow(
      keys: 'Space / Enter',
      action: 'activate the focused item',
      source: 'Keyboard',
    ),
  ],
  'select': <DocsKeyboardRow>[],
  'slider': <DocsKeyboardRow>[],
  'star_rating': <DocsKeyboardRow>[],
  'switch': <DocsKeyboardRow>[],
  'text_area': <DocsKeyboardRow>[],
  'time_picker': <DocsKeyboardRow>[],
  'accordion': <DocsKeyboardRow>[],
  'alert': <DocsKeyboardRow>[],
  'app': <DocsKeyboardRow>[
    DocsKeyboardRow(
      keys: 'Tab / Shift+Tab',
      action: 'NextFocusIntent / PreviousFocusIntent focus traversal',
      source: 'Keyboard shortcuts and actions',
    ),
    DocsKeyboardRow(
      keys: 'Enter / Space',
      action: 'ActivateIntent activates the focused control',
      source: 'Keyboard shortcuts and actions',
    ),
    DocsKeyboardRow(
      keys: 'Escape',
      action: 'DismissIntent dismisses dialogs/popovers',
      source: 'Keyboard shortcuts and actions',
    ),
    DocsKeyboardRow(
      keys: 'Tab',
      action:
          'Regression-tested: with custom shortcuts supplied, still moves focus,',
      source: 'Keyboard shortcuts and actions',
    ),
    DocsKeyboardRow(
      keys: 'Enter / Escape',
      action: 'still activates a Button, and still dismisses a Dialog.',
      source: 'Keyboard shortcuts and actions',
    ),
  ],
  'card': <DocsKeyboardRow>[],
  'card_image': <DocsKeyboardRow>[],
  'collapsible': <DocsKeyboardRow>[],
  'filter_bar': <DocsKeyboardRow>[],
  'group': <DocsKeyboardRow>[],
  'media_query': <DocsKeyboardRow>[],
  'outlined_container': <DocsKeyboardRow>[],
  'overflow_marquee': <DocsKeyboardRow>[],
  'resizable': <DocsKeyboardRow>[],
  'scaffold': <DocsKeyboardRow>[],
  'scrollable': <DocsKeyboardRow>[],
  'scrollable_client': <DocsKeyboardRow>[],
  'sortable': <DocsKeyboardRow>[],
  'stage_container': <DocsKeyboardRow>[],
  'steps': <DocsKeyboardRow>[],
  'table': <DocsKeyboardRow>[],
  'timeline': <DocsKeyboardRow>[],
  'window': <DocsKeyboardRow>[],
  'breadcrumb': <DocsKeyboardRow>[],
  'navigation_bar': <DocsKeyboardRow>[],
  'navigation_menu': <DocsKeyboardRow>[],
  'page_route': <DocsKeyboardRow>[],
  'pagination': <DocsKeyboardRow>[],
  'stepper': <DocsKeyboardRow>[],
  'switcher': <DocsKeyboardRow>[],
  'tabs': <DocsKeyboardRow>[],
  'alert_dialog': <DocsKeyboardRow>[],
  'anchor': <DocsKeyboardRow>[],
  'backdrop_transform': <DocsKeyboardRow>[],
  'context_menu': <DocsKeyboardRow>[],
  'dialog': <DocsKeyboardRow>[],
  'drawer': <DocsKeyboardRow>[],
  'drawer_container': <DocsKeyboardRow>[],
  'dropdown_menu': <DocsKeyboardRow>[],
  'eye_dropper': <DocsKeyboardRow>[],
  'gooey_toast': <DocsKeyboardRow>[],
  'hover_card': <DocsKeyboardRow>[],
  'menu': <DocsKeyboardRow>[],
  'menubar': <DocsKeyboardRow>[],
  'overlay_configuration': <DocsKeyboardRow>[],
  'popup': <DocsKeyboardRow>[],
  'refresh_trigger': <DocsKeyboardRow>[],
  'spell_check_suggestions_toolbar': <DocsKeyboardRow>[],
  'swiper': <DocsKeyboardRow>[],
  'toast': <DocsKeyboardRow>[],
  'tooltip': <DocsKeyboardRow>[],
  'alpha': <DocsKeyboardRow>[],
  'async': <DocsKeyboardRow>[],
  'color': <DocsKeyboardRow>[],
  'error_system': <DocsKeyboardRow>[],
  'locale_utils': <DocsKeyboardRow>[],
  'timeline_animation': <DocsKeyboardRow>[],
};

/// Components without keyboard/a11y rows in their README today.
/// Extend the component README (never this file) to close a gap.
const List<String> kKeyboardGaps = <String>[
  'button',
  'command',
  'patch',
  'scrollbar',
  'scrollview',
  'toggle',
  'avatar',
  'badge',
  'border_loading',
  'carousel',
  'chat',
  'chip',
  'code_snippet',
  'country_flag',
  'divider',
  'dot_indicator',
  'empty_state',
  'feature_carousel',
  'file_diff_viewer',
  'icon',
  'image',
  'keyboard_shortcut',
  'markdown',
  'number_ticker',
  'pinned_sheet',
  'progress',
  'selectable',
  'skeleton',
  'spinner',
  'text_animate',
  'tracker',
  'tree',
  'triple_dots',
  'checkbox',
  'chip_input',
  'color_field',
  'color_input',
  'color_picker',
  'date_picker',
  'dropzone',
  'file_picker',
  'form',
  'formatted_input',
  'formatter',
  'history',
  'hsl',
  'hsv',
  'input',
  'input_otp',
  'item_picker',
  'multi_select',
  'multiple_choice',
  'object_input',
  'phone_input',
  'select',
  'slider',
  'star_rating',
  'switch',
  'text_area',
  'time_picker',
  'accordion',
  'alert',
  'card',
  'card_image',
  'collapsible',
  'filter_bar',
  'group',
  'media_query',
  'outlined_container',
  'overflow_marquee',
  'resizable',
  'scaffold',
  'scrollable',
  'scrollable_client',
  'sortable',
  'stage_container',
  'steps',
  'table',
  'timeline',
  'window',
  'breadcrumb',
  'navigation_bar',
  'navigation_menu',
  'page_route',
  'pagination',
  'stepper',
  'switcher',
  'tabs',
  'alert_dialog',
  'anchor',
  'backdrop_transform',
  'context_menu',
  'dialog',
  'drawer',
  'drawer_container',
  'dropdown_menu',
  'eye_dropper',
  'gooey_toast',
  'hover_card',
  'menu',
  'menubar',
  'overlay_configuration',
  'popup',
  'refresh_trigger',
  'spell_check_suggestions_toolbar',
  'swiper',
  'toast',
  'tooltip',
  'alpha',
  'async',
  'color',
  'error_system',
  'locale_utils',
  'timeline_animation',
];

/// Dependency chips keyed by component id (components first, then primitives, foundation, theme).
const Map<String, List<DocsDep>> kComponentDeps = <String, List<DocsDep>>{
  'button': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'geometry', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'command': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'dialog', kind: DocsDepKind.component),
    DocsDep(id: 'divider', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'input_features', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'subfocus_scope', kind: DocsDepKind.primitive),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'icons/lucide_icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'patch': <DocsDep>[],
  'scrollbar': <DocsDep>[
    DocsDep(id: 'scroll_metrics', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'scrollview': <DocsDep>[],
  'toggle': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'geometry', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'avatar': <DocsDep>[
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'badge': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'border_loading': <DocsDep>[
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'calendar': <DocsDep>[
    DocsDep(id: 'date_math', kind: DocsDepKind.primitive),
    DocsDep(id: 'focus_outline', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'menu_nav', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'carousel': <DocsDep>[
    DocsDep(id: 'animation_queue', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'util', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'chat': <DocsDep>[
    DocsDep(id: 'fractional_align_box', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlap_layout', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'chip': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'code_snippet': <DocsDep>[
    DocsDep(id: 'syntax_highlight', kind: DocsDepKind.primitive),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'country_flag': <DocsDep>[
    DocsDep(id: 'countries', kind: DocsDepKind.primitive),
    DocsDep(id: 'phone_number', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'divider': <DocsDep>[
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'dot_indicator': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'empty_state': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'feature_carousel': <DocsDep>[
    DocsDep(id: 'animation', kind: DocsDepKind.primitive),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'file_diff_viewer': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'text_editing', kind: DocsDepKind.primitive),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'icon': <DocsDep>[
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'image': <DocsDep>[
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'keyboard_shortcut': <DocsDep>[
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'keyboard', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'markdown': <DocsDep>[
    DocsDep(id: 'collapsible', kind: DocsDepKind.component),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'markdown_parser', kind: DocsDepKind.primitive),
    DocsDep(id: 'text_editing', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'number_ticker': <DocsDep>[
    DocsDep(id: 'animated_value_builder', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'pinned_sheet': <DocsDep>[
    DocsDep(id: 'backdrop_transform', kind: DocsDepKind.component),
    DocsDep(id: 'drawer_container', kind: DocsDepKind.component),
    DocsDep(id: 'sheet_stage', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'progress': <DocsDep>[
    DocsDep(id: 'animation', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'selectable': <DocsDep>[
    DocsDep(id: 'text_editing', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'skeleton': <DocsDep>[
    DocsDep(id: 'animation', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'spinner': <DocsDep>[
    DocsDep(id: 'animation', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'text_animate': <DocsDep>[
    DocsDep(id: 'markdown', kind: DocsDepKind.component),
    DocsDep(id: 'streaming_text', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'tracker': <DocsDep>[
    DocsDep(id: 'tooltip', kind: DocsDepKind.component),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'tree': <DocsDep>[
    DocsDep(id: 'icon', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'tree_selection', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'triple_dots': <DocsDep>[
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'autocomplete': <DocsDep>[
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'input_features', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_controller', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_overlay_handler', kind: DocsDepKind.primitive),
    DocsDep(id: 'text_input', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'checkbox': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons/lucide_icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'chip_input': <DocsDep>[
    DocsDep(id: 'autocomplete', kind: DocsDepKind.component),
    DocsDep(id: 'chip', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'input_features', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'text_editing', kind: DocsDepKind.primitive),
    DocsDep(id: 'icons/lucide_icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'color_field': <DocsDep>[
    DocsDep(id: 'alpha', kind: DocsDepKind.component),
    DocsDep(id: 'color_field_paint', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'color_input': <DocsDep>[
    DocsDep(id: 'color', kind: DocsDepKind.component),
    DocsDep(id: 'color_picker', kind: DocsDepKind.component),
    DocsDep(id: 'eye_dropper', kind: DocsDepKind.component),
    DocsDep(id: 'history', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_controller', kind: DocsDepKind.primitive),
    DocsDep(id: 'captured_wrapper', kind: DocsDepKind.foundation),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'color_utils', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'color_picker': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'color', kind: DocsDepKind.component),
    DocsDep(id: 'eye_dropper', kind: DocsDepKind.component),
    DocsDep(id: 'formatter', kind: DocsDepKind.component),
    DocsDep(id: 'history', kind: DocsDepKind.component),
    DocsDep(id: 'hsl', kind: DocsDepKind.component),
    DocsDep(id: 'hsv', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'select', kind: DocsDepKind.component),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'color_utils', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'date_picker': <DocsDep>[
    DocsDep(id: 'calendar', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'date_math', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'dropzone': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'file_picker': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'dropzone', kind: DocsDepKind.component),
    DocsDep(id: 'progress', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'file_value', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'form': <DocsDep>[
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'formatted_input': <DocsDep>[
    DocsDep(id: 'focus_outline', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'text_editing', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'formatter': <DocsDep>[],
  'history': <DocsDep>[
    DocsDep(id: 'alpha', kind: DocsDepKind.component),
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'hsl': <DocsDep>[
    DocsDep(id: 'alpha', kind: DocsDepKind.component),
    DocsDep(id: 'color_field_paint', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'slider', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'hsv': <DocsDep>[
    DocsDep(id: 'alpha', kind: DocsDepKind.component),
    DocsDep(id: 'color_field_paint', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'slider', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'input': <DocsDep>[
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'input_features', kind: DocsDepKind.primitive),
    DocsDep(id: 'text_editing', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'input_otp': <DocsDep>[
    DocsDep(id: 'focus_outline', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'text_editing', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'item_picker': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'dialog', kind: DocsDepKind.component),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'layout', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover', kind: DocsDepKind.primitive),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'multi_select': <DocsDep>[
    DocsDep(id: 'chip', kind: DocsDepKind.component),
    DocsDep(id: 'menu', kind: DocsDepKind.component),
    DocsDep(id: 'select', kind: DocsDepKind.component),
    DocsDep(id: 'select_popup', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'multiple_choice': <DocsDep>[
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'object_input': <DocsDep>[
    DocsDep(id: 'calendar', kind: DocsDepKind.component),
    DocsDep(id: 'date_picker', kind: DocsDepKind.component),
    DocsDep(id: 'dialog', kind: DocsDepKind.component),
    DocsDep(id: 'formatted_input', kind: DocsDepKind.component),
    DocsDep(id: 'date_math', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'object_segments', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'time_of_day', kind: DocsDepKind.foundation),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'phone_input': <DocsDep>[
    DocsDep(id: 'country_flag', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'select', kind: DocsDepKind.component),
    DocsDep(id: 'countries', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'phone_number', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'radio_group': <DocsDep>[
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'roving_group', kind: DocsDepKind.primitive),
    DocsDep(id: 'selectable_radio', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'select': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'menu', kind: DocsDepKind.component),
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_controller', kind: DocsDepKind.primitive),
    DocsDep(id: 'select_popup', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'geometry', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'slider': <DocsDep>[
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'slider', kind: DocsDepKind.primitive),
    DocsDep(id: 'slider_value', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'star_rating': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'switch': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'widget_states', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'text_area': <DocsDep>[
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'input_features', kind: DocsDepKind.primitive),
  ],
  'time_picker': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'formatter', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'date_math', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'time_of_day', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'accordion': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons/lucide_icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'alert': <DocsDep>[
    DocsDep(id: 'basic_layout', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'app': <DocsDep>[
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay_manager_layer', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'card': <DocsDep>[
    DocsDep(id: 'sheet_overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'card_image': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'outlined_container', kind: DocsDepKind.component),
    DocsDep(id: 'layout', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'collapsible': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons/lucide_icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'filter_bar': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'chip', kind: DocsDepKind.component),
    DocsDep(id: 'date_picker', kind: DocsDepKind.component),
    DocsDep(id: 'drawer', kind: DocsDepKind.component),
    DocsDep(id: 'input', kind: DocsDepKind.component),
    DocsDep(id: 'select', kind: DocsDepKind.component),
    DocsDep(id: 'filter_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'form_core', kind: DocsDepKind.primitive),
    DocsDep(id: 'input_features', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'group': <DocsDep>[],
  'media_query': <DocsDep>[
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'outlined_container': <DocsDep>[
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'overflow_marquee': <DocsDep>[
    DocsDep(id: 'animation', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'resizable': <DocsDep>[
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'resizable_handle', kind: DocsDepKind.primitive),
    DocsDep(id: 'resizable_pane', kind: DocsDepKind.primitive),
    DocsDep(id: 'resizable_item', kind: DocsDepKind.foundation),
    DocsDep(id: 'resizer', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'scaffold': <DocsDep>[
    DocsDep(id: 'progress', kind: DocsDepKind.component),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'scrollable': <DocsDep>[
    DocsDep(id: 'scroll_metrics', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'scrollable_client': <DocsDep>[
    DocsDep(id: 'scroll_metrics', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'sortable': <DocsDep>[
    DocsDep(id: 'drag_sort', kind: DocsDepKind.primitive),
    DocsDep(id: 'sortable_layer', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'util', kind: DocsDepKind.foundation),
  ],
  'stage_container': <DocsDep>[
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'steps': <DocsDep>[
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'table': <DocsDep>[
    DocsDep(id: 'scrollable_client', kind: DocsDepKind.component),
    DocsDep(id: 'table_layout', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'timeline': <DocsDep>[
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'window': <DocsDep>[
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'outlined_container', kind: DocsDepKind.component),
    DocsDep(id: 'patch', kind: DocsDepKind.component),
    DocsDep(id: 'animated_value_builder', kind: DocsDepKind.primitive),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'window_host', kind: DocsDepKind.primitive),
    DocsDep(id: 'window_manager', kind: DocsDepKind.primitive),
    DocsDep(id: 'window_snap', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'breadcrumb': <DocsDep>[
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'navigation_bar': <DocsDep>[
    DocsDep(id: 'overflow_marquee', kind: DocsDepKind.component),
    DocsDep(id: 'tooltip', kind: DocsDepKind.component),
    DocsDep(id: 'navigation', kind: DocsDepKind.primitive),
    DocsDep(id: 'roving_group', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'platform', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'navigation_menu': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'outlined_container', kind: DocsDepKind.component),
    DocsDep(id: 'layout', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_controller', kind: DocsDepKind.primitive),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'page_route': <DocsDep>[],
  'pagination': <DocsDep>[
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'triple_dots', kind: DocsDepKind.component),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'stepper': <DocsDep>[
    DocsDep(id: 'clickable', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'switcher': <DocsDep>[
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'tabs': <DocsDep>[
    DocsDep(id: 'sortable', kind: DocsDepKind.component),
    DocsDep(id: 'fade_scroll', kind: DocsDepKind.primitive),
    DocsDep(id: 'roving_group', kind: DocsDepKind.primitive),
    DocsDep(id: 'tab_container', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'alert_dialog': <DocsDep>[
    DocsDep(id: 'dialog', kind: DocsDepKind.component),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'anchor': <DocsDep>[DocsDep(id: 'data', kind: DocsDepKind.foundation)],
  'backdrop_transform': <DocsDep>[
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'context_menu': <DocsDep>[
    DocsDep(id: 'menu', kind: DocsDepKind.component),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover', kind: DocsDepKind.primitive),
    DocsDep(id: 'sheet_overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'dialog': <DocsDep>[
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'density', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
    DocsDep(id: 'tokens', kind: DocsDepKind.theme),
  ],
  'drawer': <DocsDep>[
    DocsDep(id: 'drawer_route', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'drawer_container': <DocsDep>[
    DocsDep(id: 'drawer', kind: DocsDepKind.component),
    DocsDep(id: 'axis_size', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'dropdown_menu': <DocsDep>[
    DocsDep(id: 'menu', kind: DocsDepKind.component),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover', kind: DocsDepKind.primitive),
    DocsDep(id: 'sheet_overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'eye_dropper': <DocsDep>[
    DocsDep(id: 'history', kind: DocsDepKind.component),
    DocsDep(id: 'screen_capture', kind: DocsDepKind.primitive),
    DocsDep(id: 'text', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'data_messenger', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'color_utils', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'gooey_toast': <DocsDep>[
    DocsDep(id: 'animation', kind: DocsDepKind.primitive),
    DocsDep(id: 'gooey', kind: DocsDepKind.primitive),
    DocsDep(id: 'toast_queue', kind: DocsDepKind.primitive),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'hover_card': <DocsDep>[
    DocsDep(id: 'hover', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_controller', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'menu': <DocsDep>[
    DocsDep(id: 'menu_nav', kind: DocsDepKind.primitive),
    DocsDep(id: 'menu_rows', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_controller', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'menubar': <DocsDep>[
    DocsDep(id: 'menu', kind: DocsDepKind.component),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'overlay_configuration': <DocsDep>[
    DocsDep(id: 'anchor', kind: DocsDepKind.component),
    DocsDep(id: 'drawer', kind: DocsDepKind.component),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover', kind: DocsDepKind.primitive),
    DocsDep(id: 'data', kind: DocsDepKind.foundation),
    DocsDep(id: 'platform', kind: DocsDepKind.foundation),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'popup': <DocsDep>[
    DocsDep(id: 'menu', kind: DocsDepKind.component),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover', kind: DocsDepKind.primitive),
  ],
  'refresh_trigger': <DocsDep>[
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'animated_value_builder', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'constants', kind: DocsDepKind.foundation),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'spell_check_suggestions_toolbar': <DocsDep>[
    DocsDep(id: 'menu', kind: DocsDepKind.component),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
  ],
  'swiper': <DocsDep>[
    DocsDep(id: 'drawer', kind: DocsDepKind.component),
    DocsDep(id: 'drawer_route', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'toast': <DocsDep>[
    DocsDep(id: 'toast_queue', kind: DocsDepKind.primitive),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'tooltip': <DocsDep>[
    DocsDep(id: 'hover', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay', kind: DocsDepKind.primitive),
    DocsDep(id: 'overlay_manager', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_controller', kind: DocsDepKind.primitive),
    DocsDep(id: 'popover_overlay_state', kind: DocsDepKind.primitive),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'alpha': <DocsDep>[],
  'async': <DocsDep>[],
  'color': <DocsDep>[DocsDep(id: 'color_math', kind: DocsDepKind.primitive)],
  'error_system': <DocsDep>[
    DocsDep(id: 'alert_dialog', kind: DocsDepKind.component),
    DocsDep(id: 'button', kind: DocsDepKind.component),
    DocsDep(id: 'card', kind: DocsDepKind.component),
    DocsDep(id: 'divider', kind: DocsDepKind.component),
    DocsDep(id: 'toast', kind: DocsDepKind.component),
    DocsDep(id: 'error_handling', kind: DocsDepKind.primitive),
    DocsDep(id: 'localizations', kind: DocsDepKind.primitive),
    DocsDep(id: 'gap', kind: DocsDepKind.foundation),
    DocsDep(id: 'icons', kind: DocsDepKind.foundation),
    DocsDep(id: 'color_tokens', kind: DocsDepKind.theme),
    DocsDep(id: 'theme', kind: DocsDepKind.theme),
  ],
  'locale_utils': <DocsDep>[],
  'timeline_animation': <DocsDep>[],
};

/// Parsed cli_snapshot.txt command sections.
const List<DocsCliCommand> kCliCommands = <DocsCliCommand>[
  DocsCliCommand(
    label: 'flutter_shadcn',
    invocation: 'flutter_shadcn --help',
    usage: 'flutter_shadcn <command> [arguments]',
    summary: 'Component manager for the shadcn_flutter_kit registry.',
    helpText:
        'Component manager for the shadcn_flutter_kit registry.\n\nUsage: flutter_shadcn <command> [arguments]\n-h, --help       Print this usage information.\n    --version    Print the CLI version.\n\nAvailable commands:\n  init       Install the layer core and pick a theme preset.\n  add        Add components and their dependency closure.\n  remove     Remove registry-owned files (user-owned files stay).\n  update     Pull upstream registry changes for installed files.\n  list       List every component in the registry manifest.\n  search     Search components by name, tag or description.\n  info       Show dependency closure, files and theme class for one component.\n  theme      List or apply theme presets.\n  doctor     Check the install closure, lock drift and user-owned files.\n  validate   Validate the registry manifest against the v2 schema.\n\nRun "flutter_shadcn help <command>" for more information about a command.',
    flags: <DocsCliFlag>[
      DocsCliFlag(name: '--version', description: 'Print the CLI version.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn init',
    invocation: 'flutter_shadcn init --help',
    usage: 'flutter_shadcn init [arguments]',
    summary:
        'Install the registry layer core (foundation + theme) into a project and choose',
    helpText:
        'Install the registry layer core (foundation + theme) into a project and choose\na theme preset. Writes .shadcn/config.json and shadcn.lock v2; installs no\ncomponent.\n\nUsage: flutter_shadcn init [arguments]\n-h, --help         Print this usage information.\n    --dir=<path>   Install root (default: lib/ui/shadcn or the path recorded in .shadcn/config.json).\n    --theme=<id>   Preset id from themes/index.json; interactive list when omitted.\n    --yes          Accept defaults without prompting.\n    --json         Print the result as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(
        name: '--dir',
        placeholder: '<path>',
        description:
            'Install root (default: lib/ui/shadcn or the path recorded in .shadcn/config.json).',
      ),
      DocsCliFlag(
        name: '--theme',
        placeholder: '<id>',
        description:
            'Preset id from themes/index.json; interactive list when omitted.',
      ),
      DocsCliFlag(
        name: '--yes',
        description: 'Accept defaults without prompting.',
      ),
      DocsCliFlag(name: '--json', description: 'Print the result as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn add',
    invocation: 'flutter_shadcn add --help',
    usage: 'flutter_shadcn add <ids...> [arguments]',
    summary:
        'Add components and the transitive dependency closure (components -> primitives',
    helpText:
        'Add components and the transitive dependency closure (components -> primitives\n-> foundation/theme). Existing user-owned files are never overwritten. Refuses\nto install when a symbol would be defined twice (single-owner preflight).\n\nUsage: flutter_shadcn add <ids...> [arguments]\n-h, --help             Print this usage information.\n    --dry-run          Print the plan without writing files.\n    --json             Print the plan or result as JSON.\n    --force            Continue past non-fatal preflight warnings.\n    --all              Add every component in the registry manifest.\n    --include-preview  Also copy preview.dart files (default: never).',
    flags: <DocsCliFlag>[
      DocsCliFlag(
        name: '--dry-run',
        description: 'Print the plan without writing files.',
      ),
      DocsCliFlag(
        name: '--json',
        description: 'Print the plan or result as JSON.',
      ),
      DocsCliFlag(
        name: '--force',
        description: 'Continue past non-fatal preflight warnings.',
      ),
      DocsCliFlag(
        name: '--all',
        description: 'Add every component in the registry manifest.',
      ),
      DocsCliFlag(
        name: '--include-preview',
        description: 'Also copy preview.dart files (default: never).',
      ),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn update',
    invocation: 'flutter_shadcn update --help',
    usage: 'flutter_shadcn update [ids...] [arguments]',
    summary:
        'Hash-based update of registry-owned files. Unchanged files are overwritten,',
    helpText:
        'Hash-based update of registry-owned files. Unchanged files are overwritten,\nlocally modified files are reported and skipped, user-owned files are never\ntouched. Regenerates theme/app_theme.dart from the locked preset.\n\nUsage: flutter_shadcn update [ids...] [arguments]\n-h, --help    Print this usage information.\n    --all     Update every installed component.\n    --check   Report only; exit 1 when anything is behind or modified.\n    --json    Print the result as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(
        name: '--all',
        description: 'Update every installed component.',
      ),
      DocsCliFlag(
        name: '--check',
        description: 'Report only; exit 1 when anything is behind or modified.',
      ),
      DocsCliFlag(name: '--json', description: 'Print the result as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn remove',
    invocation: 'flutter_shadcn remove --help',
    usage: 'flutter_shadcn remove [ids...] [arguments]',
    summary:
        'Remove registry-owned files for the given components. Refuses when another',
    helpText:
        'Remove registry-owned files for the given components. Refuses when another\ninstalled component depends on the target.\n\nUsage: flutter_shadcn remove [ids...] [arguments]\n-h, --help               Print this usage information.\n    --purge-user-themes  Also delete the user-owned *_theme.dart files.\n    --json               Print the result as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(
        name: '--purge-user-themes',
        description: 'Also delete the user-owned *_theme.dart files.',
      ),
      DocsCliFlag(name: '--json', description: 'Print the result as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn list',
    invocation: 'flutter_shadcn list --help',
    usage: 'flutter_shadcn list [arguments]',
    summary: 'List every component in the registry manifest.',
    helpText:
        'List every component in the registry manifest.\n\nUsage: flutter_shadcn list [arguments]\n-h, --help    Print this usage information.\n    --json    Print the list as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(name: '--json', description: 'Print the list as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn search',
    invocation: 'flutter_shadcn search --help',
    usage: 'flutter_shadcn search <query> [arguments]',
    summary:
        'Search the registry manifest by component id, name, tag or description.',
    helpText:
        'Search the registry manifest by component id, name, tag or description.\n\nUsage: flutter_shadcn search <query> [arguments]\n-h, --help    Print this usage information.\n    --json    Print the matches as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(name: '--json', description: 'Print the matches as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn info',
    invocation: 'flutter_shadcn info --help',
    usage: 'flutter_shadcn info <id> [arguments]',
    summary:
        'Show the dependency closure, files, API symbols and theme class for one',
    helpText:
        'Show the dependency closure, files, API symbols and theme class for one\ncomponent.\n\nUsage: flutter_shadcn info <id> [arguments]\n-h, --help    Print this usage information.\n    --json    Print the report as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(name: '--json', description: 'Print the report as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn theme list',
    invocation: 'flutter_shadcn theme list --help',
    usage: 'flutter_shadcn theme list [arguments]',
    summary: 'List the theme presets recorded in the registry manifest.',
    helpText:
        'List the theme presets recorded in the registry manifest.\n\nUsage: flutter_shadcn theme list [arguments]\n-h, --help    Print this usage information.\n    --json    Print the presets as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(name: '--json', description: 'Print the presets as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn theme apply',
    invocation: 'flutter_shadcn theme apply --help',
    usage: 'flutter_shadcn theme apply <preset> [arguments]',
    summary:
        'Generate theme/app_theme.dart from a preset JSON (values-only file, full',
    helpText:
        'Generate theme/app_theme.dart from a preset JSON (values-only file, full\nrewrite; no regex patching). Updates the lock\'s theme section.\n\nUsage: flutter_shadcn theme apply <preset> [arguments]\n-h, --help      Print this usage information.\n    --refresh   Re-read the preset JSON even when the lock hash matches.\n    --json      Print the result as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(
        name: '--refresh',
        description: 'Re-read the preset JSON even when the lock hash matches.',
      ),
      DocsCliFlag(name: '--json', description: 'Print the result as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn doctor',
    invocation: 'flutter_shadcn doctor --help',
    usage: 'flutter_shadcn doctor [arguments]',
    summary:
        'Check the manifest, the installed closure, lock drift, user-owned files and',
    helpText:
        'Check the manifest, the installed closure, lock drift, user-owned files and\nrelative imports escaping the install root.\n\nUsage: flutter_shadcn doctor [arguments]\n-h, --help    Print this usage information.\n    --json    Print the report as JSON.\nExit codes: 0 clean, 1 drift or modified files, 2 broken closure,\n3 invalid manifest.',
    flags: <DocsCliFlag>[
      DocsCliFlag(name: '--json', description: 'Print the report as JSON.'),
    ],
  ),
  DocsCliCommand(
    label: 'flutter_shadcn validate',
    invocation: 'flutter_shadcn validate --help',
    usage: 'flutter_shadcn validate [arguments]',
    summary:
        'Validate lib/registry/manifests/registry.json against the v2 schema.',
    helpText:
        'Validate lib/registry/manifests/registry.json against the v2 schema.\n\nUsage: flutter_shadcn validate [arguments]\n-h, --help    Print this usage information.\n    --json    Print the validation report as JSON.',
    flags: <DocsCliFlag>[
      DocsCliFlag(
        name: '--json',
        description: 'Print the validation report as JSON.',
      ),
    ],
  ),
];
