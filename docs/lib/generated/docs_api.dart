// GENERATED CODE - DO NOT MODIFY BY HAND.
//
// Sources:
//   * flutter_shadcn_kit/lib/registry/manifests/registry.json
//   * flutter_shadcn_kit/lib/registry/components/<id>/<entry>.dart
//   * flutter_shadcn_kit/lib/registry/components/<id>/README.md
//
// Regenerate: dart run tool/gen_docs_data.dart
//
// API params are extracted from each component entry file with
// package:analyzer (unresolved AST, require-first order).
// Function-first components (dialog, popup, drawer) extract the
// primary top-level function parameters instead.
// Static/factory-first components (color, formatter) extract the
// entry points declared in the manifest api.methods /
// api.constants / api.functions lists instead.
// Theme fields come from the manifest `<Name>Theme` field map.
// `parseClean: false` marks entry files the analyzer cannot parse
// cleanly; their facts are best-effort.

/// One constructor parameter row.
class DocsApiParam {
  /// Creates a parameter row.
  const DocsApiParam({
    required this.name,
    required this.type,
    required this.isRequired,
    this.defaultValue,
    this.doc,
  });

  /// Parameter name.
  final String name;

  /// Declared type, or empty when unresolved.
  final String type;

  /// Whether the parameter is required.
  final bool isRequired;

  /// Default expression source, or null.
  final String? defaultValue;

  /// Doc comment, or null.
  final String? doc;
}

/// One declared method/factory/constant/function row.
class DocsApiMember {
  /// Creates the row.
  const DocsApiMember({
    required this.name,
    required this.kind,
    this.returnType = '',
    this.isStatic = false,
    this.params = const <DocsApiParam>[],
    this.doc,
  });

  /// Declared name (`TextInputFormatters.time`).
  final String name;

  /// Declaration kind: `method`, `factory`, `constructor`, `getter`,
  /// `setter`, `constant`, `field` or `function`.
  final String kind;

  /// Declared return type, or the owning class for constructors.
  final String returnType;

  /// Whether the member is static.
  final bool isStatic;

  /// Parameters, required first.
  final List<DocsApiParam> params;

  /// Doc comment, or null.
  final String? doc;
}

/// The constructor API table of one component.
class DocsApiTable {
  /// Creates the table.
  const DocsApiTable({
    required this.componentId,
    required this.symbol,
    required this.hasApiTable,
    required this.parseClean,
    this.summary,
    this.params = const <DocsApiParam>[],
    this.members = const <DocsApiMember>[],
  });

  /// Owning component id.
  final String componentId;

  /// Primary class name (`Button`) or function name (`showShadcnDialog`).
  final String symbol;

  /// Whether a primary constructor or function was found.
  final bool hasApiTable;

  /// Whether the entry file parsed without diagnostics.
  final bool parseClean;

  /// First paragraph of the class doc, or null.
  final String? summary;

  /// Constructor parameters, required first.
  final List<DocsApiParam> params;

  /// Declared static methods / factories / constants / functions,
  /// required first per member. Empty unless the primary
  /// constructor is private or parameterless.
  final List<DocsApiMember> members;
}

/// One `<Name>Theme` field.
class DocsThemeField {
  /// Creates a field row.
  const DocsThemeField({
    required this.name,
    required this.type,
    required this.description,
  });

  /// Field name (`primary`).
  final String name;

  /// Declared type (`ButtonVariantStyle?`).
  final String type;

  /// Description, or empty.
  final String description;
}

/// The per-component theme table of one component.
class DocsThemeTable {
  /// Creates the table.
  const DocsThemeTable({
    required this.componentId,
    required this.themeClass,
    required this.themeDefaults,
    required this.userFile,
    required this.userOwned,
    required this.hasTheme,
    required this.fields,
  });

  /// Owning component id.
  final String componentId;

  /// `<Name>Theme` class, or empty.
  final String themeClass;

  /// Defaults constant (`buttonDefaults`), or empty.
  final String themeDefaults;

  /// Declared user theme file (`button_theme.dart`), or empty.
  final String userFile;

  /// Whether this component owns the user file.
  final bool userOwned;

  /// Whether the component has a theme class at all.
  final bool hasTheme;

  /// Theme fields, sorted by name.
  final List<DocsThemeField> fields;
}

/// API tables keyed by component id (all components present).
const Map<String, DocsApiTable> kApiTables = <String, DocsApiTable>{
  'border_loading': DocsApiTable(
    componentId: 'border_loading',
    symbol: 'BorderLoading',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Wraps [child] and paints a configurable border effect around it: `BorderLoading(mode: BorderLoadingMode.tracer, child: ...)`.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The wrapped content.',
      ),
      DocsApiParam(
        name: 'strokeWidth',
        type: 'double?',
        isRequired: false,
        doc: 'Outline stroke thickness; null uses the theme, then `2`.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc:
            'Spacing between border and child; null uses `EdgeInsets.all(strokeWidth)`.',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc:
            'Rounded-rect shape used when [shapeBorder] is null; radius `12` default.',
      ),
      DocsApiParam(
        name: 'shapeBorder',
        type: 'ShapeBorder?',
        isRequired: false,
        doc: 'Optional shape override (circle/stadium/custom border).',
      ),
      DocsApiParam(
        name: 'mode',
        type: 'BorderLoadingMode?',
        isRequired: false,
        doc: 'Rendering mode; null uses the theme, then `sweepGradient`.',
      ),
      DocsApiParam(
        name: 'progress',
        type: 'double',
        isRequired: false,
        defaultValue: '0.0',
        doc: 'Determinate progress for [BorderLoadingMode.progress].',
      ),
      DocsApiParam(
        name: 'progressStream',
        type: 'Stream<double>?',
        isRequired: false,
        doc:
            'Optional progress source; stream values override [progress] (clamped).',
      ),
      DocsApiParam(
        name: 'tracer',
        type: 'BorderTracerSpec',
        isRequired: false,
        defaultValue: 'const BorderTracerSpec()',
        doc: 'Tracer segment configuration.',
      ),
      DocsApiParam(
        name: 'spec',
        type: 'BorderLoadingSpec',
        isRequired: false,
        defaultValue: 'const BorderGradientSpec()',
        doc: 'Shader spec used by every mode.',
      ),
      DocsApiParam(
        name: 'duration',
        type: 'Duration?',
        isRequired: false,
        doc:
            'Cycle duration of the looping modes; null uses the theme, then 1200ms.',
      ),
      DocsApiParam(
        name: 'curve',
        type: 'Curve?',
        isRequired: false,
        doc: 'Easing of normalized progress; null uses the theme, then linear.',
      ),
      DocsApiParam(
        name: 'backgroundColor',
        type: 'Color?',
        isRequired: false,
        doc:
            'Fill painted behind the padded child; null uses the theme colour.',
      ),
      DocsApiParam(
        name: 'opacity',
        type: 'double?',
        isRequired: false,
        doc: 'Global stroke opacity; null uses the theme, then `1`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'BorderLoadingTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'dot_indicator': DocsApiTable(
    componentId: 'dot_indicator',
    symbol: 'DotIndicator',
    hasApiTable: true,
    parseClean: true,
    summary: 'Navigation indicator with a row or column of animated dots.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'index',
        type: 'int',
        isRequired: true,
        doc:
            'Index of the active dot; a value outside `0..length - 1` leaves every dot\ninactive.',
      ),
      DocsApiParam(
        name: 'length',
        type: 'int',
        isRequired: true,
        doc: 'Number of dots.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<int>?',
        isRequired: false,
        doc:
            'Called with the tapped index. Null makes the indicator read-only: no\n`Clickable` and no click cursor are built.',
      ),
      DocsApiParam(
        name: 'spacing',
        type: 'double?',
        isRequired: false,
        doc:
            'Gap between two dots; null uses [DotIndicatorTheme.spacing] then\n`8 * scaling`.',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.horizontal',
        doc: 'Axis of the run of dots.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc:
            'Padding around the run of dots; null uses [DotIndicatorTheme.padding] then\n[dotIndicatorDefaultPadding]. It is applied once, to the run, never per\ndot.',
      ),
      DocsApiParam(
        name: 'dotBuilder',
        type: 'DotBuilder?',
        isRequired: false,
        doc: 'Custom dot builder; null paints the theme rows.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'DotIndicatorTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'text_animate': DocsApiTable(
    componentId: 'text_animate',
    symbol: 'TextAnimate',
    hasApiTable: true,
    parseClean: true,
    summary: 'Stream-aware text renderer for incremental updates.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'text',
        type: 'String',
        isRequired: true,
        doc: 'Latest full text value received from the stream.',
      ),
      DocsApiParam(
        name: 'style',
        type: 'TextStyle?',
        isRequired: false,
        doc: 'Base style, merged over the theme style and the ambient default.',
      ),
      DocsApiParam(
        name: 'typewriter',
        type: 'TextAnimateTypewriter?',
        isRequired: false,
        doc: 'Reveal pacing; null falls back through the theme legs.',
      ),
      DocsApiParam(
        name: 'animateByWord',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Word units (with trailing whitespace) instead of characters.',
      ),
      DocsApiParam(
        name: 'effect',
        type: 'TextAnimateEffect?',
        isRequired: false,
        doc:
            'Animation of newly revealed units; null falls back through the legs.',
      ),
      DocsApiParam(
        name: 'cursor',
        type: 'TextAnimateCursor?',
        isRequired: false,
        doc: 'Cursor; null falls back through the theme legs.',
      ),
      DocsApiParam(name: 'textAlign', type: 'TextAlign?', isRequired: false),
      DocsApiParam(
        name: 'smoothLayout',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Smoothly animates height when wrapping changes the layout.',
      ),
      DocsApiParam(
        name: 'layoutAnimationDuration',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'const Duration(milliseconds: 180)',
        doc: 'Duration of the smooth layout height transition.',
      ),
      DocsApiParam(
        name: 'layoutAnimationCurve',
        type: 'Curve',
        isRequired: false,
        defaultValue: 'Curves.easeOutCubic',
        doc: 'Curve of the smooth layout height transition.',
      ),
      DocsApiParam(
        name: 'onSettled',
        type: 'TextAnimateSettled?',
        isRequired: false,
        doc: 'Fired once per revision when it has fully settled.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'TextAnimateTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged over the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'button': DocsApiTable(
    componentId: 'button',
    symbol: 'Button',
    hasApiTable: true,
    parseClean: true,
    summary: 'A pressable action control.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Button content, usually a `Text` or an `Icon`.',
      ),
      DocsApiParam(
        name: 'variant',
        type: 'ButtonVariant',
        isRequired: false,
        defaultValue: 'ButtonVariant.primary',
        doc: 'Visual variant. Defaults to [ButtonVariant.primary].',
      ),
      DocsApiParam(
        name: 'size',
        type: 'ButtonSize',
        isRequired: false,
        defaultValue: 'ButtonSize.md',
        doc: 'Fixed size row. Defaults to [ButtonSize.md].',
      ),
      DocsApiParam(
        name: 'onPressed',
        type: 'VoidCallback?',
        isRequired: false,
        doc:
            'Called on tap. When null the button is disabled unless [enabled] is true.',
      ),
      DocsApiParam(
        name: 'onLongPress',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Called on long press. Ignored while the button is disabled.',
      ),
      DocsApiParam(
        name: 'onHover',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the hover state changes.',
      ),
      DocsApiParam(
        name: 'onFocusChange',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the focus state changes.',
      ),
      DocsApiParam(
        name: 'leading',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown before [child].',
      ),
      DocsApiParam(
        name: 'trailing',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown after [child].',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc:
            'Focus node. A node is created internally when [autofocus] is true and\nthis is null; otherwise the internal `Clickable` owns its own node.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the button requests focus when first built.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc: 'Overrides the enabled state; null means `onPressed != null`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ButtonVariantStyle?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'toggle': DocsApiTable(
    componentId: 'toggle',
    symbol: 'Toggle',
    hasApiTable: true,
    parseClean: true,
    summary: 'A button that keeps an on/off state.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Toggle content, usually a `Text` or an icon.',
      ),
      DocsApiParam(
        name: 'value',
        type: 'bool?',
        isRequired: false,
        doc: 'Current value in controlled mode; null in controller mode.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'ToggleController?',
        isRequired: false,
        doc: 'Controller mode: the controller owns the value.',
      ),
      DocsApiParam(
        name: 'size',
        type: 'ToggleSize',
        isRequired: false,
        defaultValue: 'ToggleSize.md',
        doc: 'Fixed size row. Defaults to [ToggleSize.md] (h-9 = 36).',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called with the next value in controlled mode.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc:
            'Overrides the enabled state; null means "interactive when controlled or\ncontroller-driven".',
      ),
      DocsApiParam(
        name: 'style',
        type: 'ToggleStyle?',
        isRequired: false,
        doc:
            'Widget-leg override for the off state (old `SelectedButton.style`).',
      ),
      DocsApiParam(
        name: 'activeStyle',
        type: 'ToggleStyle?',
        isRequired: false,
        doc: 'Widget-leg override for the on state (old `selectedStyle`).',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ToggleStyle?',
        isRequired: false,
        doc: 'Generic widget-leg override, merged under [style]/[activeStyle].',
      ),
      DocsApiParam(
        name: 'onHover',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the hover state changes.',
      ),
      DocsApiParam(
        name: 'onFocusChange',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the focus state changes.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc:
            'Focus node. A node is created internally when [autofocus] is true and\nthis is null.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the toggle requests focus when first built.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'color_picker': DocsApiTable(
    componentId: 'color_picker',
    symbol: 'ColorPicker',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A full colour picker: a pad plus hue/alpha bars, a mode dropdown, live numeric fields, optional colour history and an eye-dropper button.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'value', type: 'ColorDerivative', isRequired: true),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<ColorDerivative>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onChanging',
        type: 'ValueChanged<ColorDerivative>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'showAlpha',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'initialMode',
        type: 'ColorPickerMode',
        isRequired: false,
        defaultValue: 'ColorPickerMode.rgb',
      ),
      DocsApiParam(
        name: 'onModeChanged',
        type: 'ValueChanged<ColorPickerMode>?',
        isRequired: false,
        doc: 'Called when the mode dropdown changes.',
      ),
      DocsApiParam(
        name: 'enableEyeDropper',
        type: 'bool?',
        isRequired: false,
        doc: 'Eye-dropper button visibility; null uses the theme (true).',
      ),
      DocsApiParam(
        name: 'onEyeDropperRequested',
        type: 'VoidCallback?',
        isRequired: false,
        doc:
            'Replaces the default eye-dropper action (pick through the nearest\n`EyeDropperLayer`, into the colour history when one is in scope).',
      ),
      DocsApiParam(
        name: 'showHistoryButton',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether the history toggle is shown (needs a `RecentColorsScope`).',
      ),
      DocsApiParam(
        name: 'initialShowHistory',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the history grid is shown on first build.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ColorPickerTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override (orientation/spacing/slider size live here).',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'avatar': DocsApiTable(
    componentId: 'avatar',
    symbol: 'Avatar',
    hasApiTable: true,
    parseClean: true,
    summary: 'An image or initials tile for a person or entity.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'initials',
        type: 'String',
        isRequired: true,
        doc: 'Fallback label; also the accessible label of the tile.',
      ),
      DocsApiParam(
        name: 'image',
        type: 'ImageProvider?',
        isRequired: false,
        doc: 'Optional photo. When it fails to decode, [initials] are shown.',
      ),
      DocsApiParam(
        name: 'size',
        type: 'double?',
        isRequired: false,
        doc:
            'Diameter override; null uses [AvatarTheme.size] then `32 * scaling`\n(shadcn `size-8`).',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc:
            'Corner radius override; null uses [AvatarTheme.borderRadius] then a\nfull circle.',
      ),
      DocsApiParam(
        name: 'backgroundColor',
        type: 'Color?',
        isRequired: false,
        doc: 'Initials fill override.',
      ),
      DocsApiParam(
        name: 'foregroundColor',
        type: 'Color?',
        isRequired: false,
        doc: 'Initials colour override.',
      ),
      DocsApiParam(
        name: 'textStyle',
        type: 'TextStyle?',
        isRequired: false,
        doc: 'Initials style override.',
      ),
      DocsApiParam(
        name: 'fit',
        type: 'BoxFit',
        isRequired: false,
        defaultValue: 'BoxFit.cover',
        doc: 'How the image fills the tile.',
      ),
      DocsApiParam(
        name: 'badge',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional badge overlaid on the tile.',
      ),
      DocsApiParam(
        name: 'badgeAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
        doc:
            'Where [badge] sits; null uses [AvatarTheme.badgeAlignment] then the\nbottom end corner.',
      ),
      DocsApiParam(
        name: 'badgeGap',
        type: 'double?',
        isRequired: false,
        doc: 'Inset of [badge] from the tile edge.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'AvatarTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'badge': DocsApiTable(
    componentId: 'badge',
    symbol: 'Badge',
    hasApiTable: true,
    parseClean: true,
    summary: 'A small rounded label used for status, counts and categories.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Badge content. Ignored when [showAsDot] is true.',
      ),
      DocsApiParam(
        name: 'variant',
        type: 'BadgeVariant',
        isRequired: false,
        defaultValue: 'BadgeVariant.primary',
        doc: 'Visual variant. Defaults to [BadgeVariant.primary].',
      ),
      DocsApiParam(
        name: 'leading',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown before [child].',
      ),
      DocsApiParam(
        name: 'trailing',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown after [child].',
      ),
      DocsApiParam(
        name: 'onPressed',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Turns the badge into a press target when provided.',
      ),
      DocsApiParam(
        name: 'onHover',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the hover state changes.',
      ),
      DocsApiParam(
        name: 'onFocusChange',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the focus state changes.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc:
            'Focus node of a pressable badge; ignored when [onPressed] is null.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether a pressable badge requests focus when first built.',
      ),
      DocsApiParam(
        name: 'showAsDot',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Draws a fixed-size dot instead of [child] (shadcn `showAsDot`).',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'BadgeStyle?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged over the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'carousel': DocsApiTable(
    componentId: 'carousel',
    symbol: 'Carousel',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A paged carousel; a [CarouselController] drives the fractional page position.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'itemBuilder',
        type: 'CarouselItemBuilder',
        isRequired: true,
        doc: 'Builds the page at [index].',
      ),
      DocsApiParam(
        name: 'itemCount',
        type: 'int?',
        isRequired: false,
        doc: 'Number of pages; null means unbounded.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'CarouselController?',
        isRequired: false,
        doc:
            'Controller driving the page position; the carousel creates and disposes\nits own when null.',
      ),
      DocsApiParam(
        name: 'transition',
        type: 'CarouselTransition?',
        isRequired: false,
        doc: 'Page transition; null resolves sliding.',
      ),
      DocsApiParam(
        name: 'alignment',
        type: 'CarouselAlignment?',
        isRequired: false,
        doc: 'Page alignment; null resolves center.',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis?',
        isRequired: false,
        doc: 'Scroll axis; null resolves horizontal.',
      ),
      DocsApiParam(
        name: 'viewportFraction',
        type: 'double?',
        isRequired: false,
        doc: 'Viewport fraction per page; null resolves 1.',
      ),
      DocsApiParam(
        name: 'itemExtent',
        type: 'double?',
        isRequired: false,
        doc: 'Fixed page extent; wins over [viewportFraction].',
      ),
      DocsApiParam(
        name: 'gap',
        type: 'double?',
        isRequired: false,
        doc: 'Gap between two pages.',
      ),
      DocsApiParam(
        name: 'speed',
        type: 'Duration?',
        isRequired: false,
        doc: 'Page-change duration; null resolves 150 ms.',
      ),
      DocsApiParam(
        name: 'curve',
        type: 'Curve?',
        isRequired: false,
        doc: 'Page-change curve; null resolves easeInOut.',
      ),
      DocsApiParam(
        name: 'autoplayInterval',
        type: 'Duration?',
        isRequired: false,
        doc: 'Hold time per page; null disables autoplay.',
      ),
      DocsApiParam(
        name: 'autoplayReverse',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether autoplay walks backwards.',
      ),
      DocsApiParam(
        name: 'onIndexChanged',
        type: 'ValueChanged<int>?',
        isRequired: false,
        doc: 'Called with the rounded page index whenever it changes.',
      ),
      DocsApiParam(
        name: 'onPageChanged',
        type: 'ValueChanged<double>?',
        isRequired: false,
        doc: 'Called with the fractional page position on every change.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CarouselTheme?',
        isRequired: false,
        doc: 'Widget leg of [CarouselTheme].',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'chat': DocsApiTable(
    componentId: 'chat',
    symbol: 'ChatBubble',
    hasApiTable: true,
    parseClean: true,
    summary: 'A chat message bubble, aligned to its side of the row.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'child', type: 'Widget', isRequired: true),
      DocsApiParam(
        name: 'variant',
        type: 'ChatBubbleVariant?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'alignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
      ),
      DocsApiParam(name: 'color', type: 'ThemedColor?', isRequired: false),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'borderColor',
        type: 'ThemedColor?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'corner',
        type: 'ChatBubbleCornerDirectional?',
        isRequired: false,
        doc:
            'Corner that sharpens / carries the tail; null = the bubble\'s side corner.',
      ),
      DocsApiParam(name: 'widthFactor', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'theme',
        type: 'ChatTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'chip': DocsApiTable(
    componentId: 'chip',
    symbol: 'Chip',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A compact button shaped like a shadcn chip (`px-2 py-0.5 text-xs`).',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Chip content, usually a `Text`.',
      ),
      DocsApiParam(
        name: 'onPressed',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Turns the chip into a press target when provided.',
      ),
      DocsApiParam(
        name: 'leading',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown before [child].',
      ),
      DocsApiParam(
        name: 'trailing',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown after [child].',
      ),
      DocsApiParam(
        name: 'variant',
        type: 'ButtonVariant?',
        isRequired: false,
        doc: 'Button variant override; null resolves `ChipTheme.variant`.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc: 'Padding override; null resolves `ChipTheme.padding`.',
      ),
      DocsApiParam(
        name: 'onHover',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the hover state changes.',
      ),
      DocsApiParam(
        name: 'onFocusChange',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the focus state changes.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc:
            'Focus node of a pressable chip; ignored when [onPressed] is null.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether a pressable chip requests focus when first built.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ChipTheme?',
        isRequired: false,
        doc:
            'Widget-leg override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'country_flag': DocsApiTable(
    componentId: 'country_flag',
    symbol: 'CountryFlag',
    hasApiTable: true,
    parseClean: true,
    summary: 'Flag tile for a country.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'country',
        type: 'Country?',
        isRequired: true,
        doc: 'Country to draw, or null for an empty box.',
      ),
      DocsApiParam(
        name: 'width',
        type: 'double?',
        isRequired: false,
        doc: 'Flag width override; null falls back to the theme (24, scaled).',
      ),
      DocsApiParam(
        name: 'height',
        type: 'double?',
        isRequired: false,
        doc: 'Flag height override; null falls back to the theme (18, scaled).',
      ),
      DocsApiParam(
        name: 'shape',
        type: 'ShapeBorder?',
        isRequired: false,
        doc: 'Clip shape override; null falls back to the theme (unclipped).',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CountryFlagTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged over the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'divider': DocsApiTable(
    componentId: 'divider',
    symbol: 'Divider',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A one-pixel themed rule separating content, with an optional label.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'axis',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.horizontal',
        doc:
            'Orientation of the rule. A horizontal divider fills the available width;\na vertical one fills the available height.',
      ),
      DocsApiParam(
        name: 'color',
        type: 'ThemedColor?',
        isRequired: false,
        doc: 'Rule colour override; null falls back to `DividerTheme.color`.',
      ),
      DocsApiParam(
        name: 'thickness',
        type: 'double?',
        isRequired: false,
        doc:
            'Stroke width override; null falls back to `DividerTheme.thickness`.',
      ),
      DocsApiParam(
        name: 'extent',
        type: 'double?',
        isRequired: false,
        doc:
            'Cross-axis extent override; null falls back to `DividerTheme.extent`.',
      ),
      DocsApiParam(
        name: 'indent',
        type: 'double?',
        isRequired: false,
        doc:
            'Space before the rule. Applies to the leading edge in both orientations.',
      ),
      DocsApiParam(
        name: 'endIndent',
        type: 'double?',
        isRequired: false,
        doc:
            'Space after the rule. Applies to the trailing edge in both orientations.',
      ),
      DocsApiParam(
        name: 'label',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional label centred in the rule. Omit it for a plain rule.',
      ),
      DocsApiParam(
        name: 'labelPadding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc:
            'Padding around [label]; null falls back to `DividerTheme.labelPadding`, a\ndensity-scaled shadcn `px-2` that this widget resolves against\n`density.baseContentPadding * scaling`. A literal override passes\nthrough unchanged.',
      ),
      DocsApiParam(
        name: 'labelAlignment',
        type: 'DividerLabelAlignment?',
        isRequired: false,
        doc:
            'Cross-axis placement of [label]; null falls back to\n`DividerTheme.labelAlignment`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'DividerTheme?',
        isRequired: false,
        doc:
            'Widget-leg override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'empty_state': DocsApiTable(
    componentId: 'empty_state',
    symbol: 'EmptyState',
    hasApiTable: true,
    parseClean: true,
    summary: 'A block that stands in for missing content.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'variant',
        type: 'EmptyStateVariant',
        isRequired: false,
        defaultValue: 'EmptyStateVariant.empty',
        doc: 'Preset for the default strings and icon.',
      ),
      DocsApiParam(
        name: 'size',
        type: 'EmptyStateSize',
        isRequired: false,
        defaultValue: 'EmptyStateSize.fullPage',
        doc: 'Presentation scale.',
      ),
      DocsApiParam(
        name: 'icon',
        type: 'Widget?',
        isRequired: false,
        doc: 'Icon shown above the title; null uses the preset\'s icon.',
      ),
      DocsApiParam(
        name: 'title',
        type: 'Widget?',
        isRequired: false,
        doc: 'Title; null uses the preset\'s localized string.',
      ),
      DocsApiParam(
        name: 'description',
        type: 'Widget?',
        isRequired: false,
        doc: 'Description; null uses the preset\'s localized string.',
      ),
      DocsApiParam(
        name: 'primaryAction',
        type: 'EmptyStateAction?',
        isRequired: false,
        doc: 'First action.',
      ),
      DocsApiParam(
        name: 'secondaryAction',
        type: 'EmptyStateAction?',
        isRequired: false,
        doc: 'Second action, shown beside the first.',
      ),
      DocsApiParam(
        name: 'footerAction',
        type: 'EmptyStateAction?',
        isRequired: false,
        doc: 'Trailing action, shown on its own row below the pair.',
      ),
      DocsApiParam(
        name: 'showIconContainer',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the icon sits in the muted container.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'EmptyStateTheme?',
        isRequired: false,
        doc: 'Widget-leg style override.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'feature_carousel': DocsApiTable(
    componentId: 'feature_carousel',
    symbol: 'FeatureCarousel',
    hasApiTable: true,
    parseClean: true,
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'items',
        type: 'List<FeatureCarouselItem>',
        isRequired: true,
      ),
      DocsApiParam(
        name: 'controller',
        type: 'FeatureCarouselController?',
        isRequired: false,
      ),
      DocsApiParam(name: 'width', type: 'double?', isRequired: false),
      DocsApiParam(name: 'height', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'theme',
        type: 'FeatureCarouselTheme?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'cardBuilder',
        type: 'FeatureCarouselCardBuilder?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'file_diff_viewer': DocsApiTable(
    componentId: 'file_diff_viewer',
    symbol: 'FileDiffViewer',
    hasApiTable: true,
    parseClean: true,
    summary: 'A file diff viewer with unified and split layouts.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'files',
        type: 'List<FileDiff>',
        isRequired: true,
        doc: 'Files rendered by the viewer, and the layout mode.',
      ),
      DocsApiParam(
        name: 'layout',
        type: 'FileDiffLayout',
        isRequired: false,
        defaultValue: 'FileDiffLayout.unified',
      ),
      DocsApiParam(
        name: 'showFileHeaders',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'showLineNumbers',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'collapseUnchanged',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'showCopyAction',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'maxHeight', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'minContentWidth',
        type: 'double',
        isRequired: false,
        defaultValue: '720.0',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'FileDiffViewerTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'keyboard_shortcut': DocsApiTable(
    componentId: 'keyboard_shortcut',
    symbol: 'KeyboardShortcut',
    hasApiTable: true,
    parseClean: true,
    summary: 'A whole shortcut chord, drawn as a row of caps.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: '_keys',
        type: 'List<LogicalKeyboardKey>?',
        isRequired: true,
      ),
      DocsApiParam(
        name: 'spacing',
        type: 'double?',
        isRequired: false,
        doc: 'Horizontal gap between caps; null resolves the theme\'s.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'KeyboardShortcutTheme?',
        isRequired: false,
        doc: 'Widget-leg style override, applied to every cap.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'number_ticker': DocsApiTable(
    componentId: 'number_ticker',
    symbol: 'NumberTicker',
    hasApiTable: true,
    parseClean: true,
    summary: 'Animated number: counts between values with [duration]/[curve].',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'number',
        type: 'num',
        isRequired: true,
        doc: 'Target value.',
      ),
      DocsApiParam(
        name: 'formatter',
        type: 'NumberTickerFormatted?',
        isRequired: true,
        doc: 'Text formatter (text variant).',
      ),
      DocsApiParam(
        name: 'initialNumber',
        type: 'num?',
        isRequired: false,
        doc: 'Value the first animation runs from; null starts at [number].',
      ),
      DocsApiParam(
        name: 'duration',
        type: 'Duration?',
        isRequired: false,
        doc: 'Animation duration override; null falls back to the theme.',
      ),
      DocsApiParam(
        name: 'curve',
        type: 'Curve?',
        isRequired: false,
        doc: 'Animation curve override; null falls back to the theme.',
      ),
      DocsApiParam(
        name: 'style',
        type: 'TextStyle?',
        isRequired: false,
        doc: 'Text style override; null falls back to the theme, then ambient.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'NumberTickerTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged over the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'pinned_sheet': DocsApiTable(
    componentId: 'pinned_sheet',
    symbol: 'PinnedSheet',
    hasApiTable: true,
    parseClean: true,
    summary:
        'An in-tree sheet: slides in from [position], drags, snaps to [stages].',
    params: <DocsApiParam>[
      DocsApiParam(name: 'child', type: 'Widget', isRequired: true),
      DocsApiParam(
        name: 'position',
        type: 'OverlayPosition',
        isRequired: false,
        defaultValue: 'OverlayPosition.bottom',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'SheetController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'stages',
        type: 'List<SheetStage>',
        isRequired: false,
        defaultValue: 'const [SheetStage.closed(), SheetStage.expanded()]',
      ),
      DocsApiParam(
        name: 'initialStage',
        type: 'SheetStage?',
        isRequired: false,
      ),
      DocsApiParam(name: 'backdrop', type: 'Widget?', isRequired: false),
      DocsApiParam(
        name: 'backdropTransform',
        type: 'BackdropTransform?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'draggable',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'showDragHandle',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'expands',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'contentExpands',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'modal',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'barrierDismissible',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'barrierColor',
        type: 'ThemedColor?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadius?',
        isRequired: false,
      ),
      DocsApiParam(name: 'dragHandleSize', type: 'Size?', isRequired: false),
      DocsApiParam(
        name: 'constraints',
        type: 'BoxConstraints?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'duration',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'const Duration(milliseconds: 350)',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'table': DocsApiTable(
    componentId: 'table',
    symbol: 'ShadcnTable',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A themed data grid of [ShadcnTableRow]s (headers, rows, footers) holding [ShadcnTableCell]s, sized by [TableSize] strategies.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'rows',
        type: 'List<ShadcnTableRow>',
        isRequired: true,
        doc: 'Rows of the table.',
      ),
      DocsApiParam(
        name: 'defaultColumnWidth',
        type: 'TableSize',
        isRequired: false,
        defaultValue: 'const FlexTableSize()',
        doc: 'Default column sizing strategy.',
      ),
      DocsApiParam(
        name: 'defaultRowHeight',
        type: 'TableSize',
        isRequired: false,
        defaultValue: 'const IntrinsicTableSize()',
        doc: 'Default row sizing strategy.',
      ),
      DocsApiParam(
        name: 'columnWidths',
        type: 'Map<int, TableSize>?',
        isRequired: false,
        doc: 'Per-column / per-row sizing overrides.',
      ),
      DocsApiParam(
        name: 'rowHeights',
        type: 'Map<int, TableSize>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'clipBehavior',
        type: 'Clip',
        isRequired: false,
        defaultValue: 'Clip.hardEdge',
        doc: 'How content is clipped at the table boundary.',
      ),
      DocsApiParam(
        name: 'frozenCells',
        type: 'FrozenTableData?',
        isRequired: false,
        doc: 'Frozen rows/columns kept visible while scrolling.',
      ),
      DocsApiParam(
        name: 'horizontalOffset',
        type: 'double?',
        isRequired: false,
        doc:
            'Manual scroll offsets and viewport size (used when no controllers).',
      ),
      DocsApiParam(name: 'verticalOffset', type: 'double?', isRequired: false),
      DocsApiParam(name: 'viewportSize', type: 'Size?', isRequired: false),
      DocsApiParam(
        name: 'verticalController',
        type: 'ScrollController?',
        isRequired: false,
        doc:
            'Own scrolling controllers; when set the table wraps a `ScrollableClient`.',
      ),
      DocsApiParam(
        name: 'horizontalController',
        type: 'ScrollController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'textDirection',
        type: 'TextDirection?',
        isRequired: false,
        doc:
            'Direction columns run in; defaults to the ambient `Directionality`.',
      ),
      DocsApiParam(
        name: 'resizeController',
        type: 'ResizableTableController?',
        isRequired: false,
        doc: 'Enables interactive resizing when non-null.',
      ),
      DocsApiParam(
        name: 'cellWidthResizeMode',
        type: 'TableCellResizeMode',
        isRequired: false,
        defaultValue: 'TableCellResizeMode.reallocate',
        doc: 'Column / row resize behaviour when [resizeController] is set.',
      ),
      DocsApiParam(
        name: 'cellHeightResizeMode',
        type: 'TableCellResizeMode',
        isRequired: false,
        defaultValue: 'TableCellResizeMode.expand',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'TableTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override, merged on top of the other resolver legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'timeline': DocsApiTable(
    componentId: 'timeline',
    symbol: 'Timeline',
    hasApiTable: true,
    parseClean: true,
    summary: 'A vertical timeline of chronological entries.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'data',
        type: 'List<TimelineData>',
        isRequired: true,
        doc: 'Entries rendered top to bottom.',
      ),
      DocsApiParam(
        name: 'timeConstraints',
        type: 'BoxConstraints?',
        isRequired: false,
        doc:
            'Widget-leg width of the time column; null uses [TimelineTheme.timeConstraints]\nor the `120 * scaling` default.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'TimelineTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'tracker': DocsApiTable(
    componentId: 'tracker',
    symbol: 'Tracker',
    hasApiTable: true,
    parseClean: true,
    summary: 'A row of coloured activity segments.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'data',
        type: 'List<TrackerData>',
        isRequired: true,
        doc: 'Segments, in visual order.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'TrackerTheme?',
        isRequired: false,
        doc:
            'Widget-leg override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'tree': DocsApiTable(
    componentId: 'tree',
    symbol: 'Tree',
    hasApiTable: true,
    parseClean: true,
    summary: 'A hierarchical list with expand/collapse and selection.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'nodes',
        type: 'List<TreeNode<T>>',
        isRequired: true,
        doc: 'The nodes to render, root level.',
      ),
      DocsApiParam(
        name: 'builder',
        type: 'Widget Function(BuildContext context, TreeItem<T> item)',
        isRequired: true,
        doc: 'Builds the content of one item.',
      ),
      DocsApiParam(
        name: 'onSelectionChanged',
        type: 'TreeNodeSelectionChanged<T>?',
        isRequired: false,
        doc: 'Called when a row is activated.',
      ),
      DocsApiParam(
        name: 'onExpandedChanged',
        type: 'TreeNodeExpandedChanged<T>?',
        isRequired: false,
        doc: 'Called when a row is expanded or collapsed.',
      ),
      DocsApiParam(
        name: 'allowMultiSelect',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether [onSelectionChanged] may report several nodes at once.\n\nWhen false every gesture collapses to a plain click: a <kbd>Shift</kbd> or\n<kbd>Ctrl</kbd> chord selects that one row and nothing else.',
      ),
      DocsApiParam(
        name: 'recursiveSelection',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether selecting a parent also selects its descendants.\n\nRange and select-all report the visible rows as they are; the subtree\nexpansion only applies to a plain, toggle or range click on one row.',
      ),
      DocsApiParam(
        name: 'branchLine',
        type: 'TreeBranchLine?',
        isRequired: false,
        doc: 'Guide style; falls back to the theme.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc: 'Padding around the tree; falls back to the theme.',
      ),
      DocsApiParam(
        name: 'shrinkWrap',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the list shrinks to its content.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'ScrollController?',
        isRequired: false,
        doc: 'Scroll controller for the list.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusScopeNode?',
        isRequired: false,
        doc: 'Focus scope of the tree.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'TreeTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'calendar': DocsApiTable(
    componentId: 'calendar',
    symbol: 'Calendar',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A date, month or year grid. Controlled: it paints [value] and reports every change through [onChanged], like shadcn/ui\'s `React.Calendar`.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'view',
        type: 'CalendarView',
        isRequired: true,
        doc:
            'The month shown by [CalendarViewType.date], the year by the other two, and\nhow a tap changes the selection.',
      ),
      DocsApiParam(
        name: 'viewType',
        type: 'CalendarViewType',
        isRequired: false,
        defaultValue: 'CalendarViewType.date',
      ),
      DocsApiParam(
        name: 'selectionMode',
        type: 'CalendarSelectionMode',
        isRequired: false,
        defaultValue: 'CalendarSelectionMode.none',
      ),
      DocsApiParam(
        name: 'value',
        type: 'CalendarValue?',
        isRequired: false,
        doc: 'The current selection; null when nothing is selected.',
      ),
      DocsApiParam(
        name: 'now',
        type: 'DateTime?',
        isRequired: false,
        doc: 'The date highlighted as "today"; null draws none.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<CalendarValue?>?',
        isRequired: false,
        doc:
            'The next selection (null when a tap cleared it), and the new month when a\nkeyboard move takes the focus past the shown one.',
      ),
      DocsApiParam(
        name: 'onViewChanged',
        type: 'ValueChanged<CalendarView>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'stateBuilder',
        type: 'DateStateBuilder?',
        isRequired: false,
        doc: 'Decides whether a cell is interactive; null enables everything.',
      ),
      DocsApiParam(
        name: 'firstDayOfWeek',
        type: 'int',
        isRequired: false,
        defaultValue: 'DateTime.monday',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CalendarTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override; the value a tap or an `Enter` on [date] produces\ncomes from [calendarSelect] (see [select]).',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'date_picker': DocsApiTable(
    componentId: 'date_picker',
    symbol: 'DatePicker',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A single-date field: a trigger showing the value (or the localized placeholder) that opens a [DatePickerDialog] in a dialog or a popover.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'value', type: 'DateTime?', isRequired: true),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<DateTime?>?',
        isRequired: false,
      ),
      DocsApiParam(name: 'placeholder', type: 'Widget?', isRequired: false),
      DocsApiParam(name: 'mode', type: 'PromptMode?', isRequired: false),
      DocsApiParam(
        name: 'initialView',
        type: 'CalendarView?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'initialViewType',
        type: 'CalendarViewType?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'popoverAnchorAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'popoverPadding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
      ),
      DocsApiParam(name: 'dialogTitle', type: 'Widget?', isRequired: false),
      DocsApiParam(
        name: 'stateBuilder',
        type: 'DateStateBuilder?',
        isRequired: false,
      ),
      DocsApiParam(name: 'enabled', type: 'bool?', isRequired: false),
      DocsApiParam(name: 'theme', type: 'DatePickerTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'time_picker': DocsApiTable(
    componentId: 'time_picker',
    symbol: 'TimePicker',
    hasApiTable: true,
    parseClean: true,
    summary: 'A clock-time field opening a [TimePickerDialog] sheet.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'value', type: 'TimeOfDay?', isRequired: true),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<TimeOfDay?>?',
        isRequired: false,
      ),
      DocsApiParam(name: 'mode', type: 'PromptMode?', isRequired: false),
      DocsApiParam(name: 'placeholder', type: 'Widget?', isRequired: false),
      DocsApiParam(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'popoverAnchorAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'popoverPadding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
      ),
      DocsApiParam(name: 'use24HourFormat', type: 'bool?', isRequired: false),
      DocsApiParam(
        name: 'showSeconds',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(name: 'dialogTitle', type: 'Widget?', isRequired: false),
      DocsApiParam(name: 'enabled', type: 'bool?', isRequired: false),
      DocsApiParam(name: 'theme', type: 'TimePickerTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'alert': DocsApiTable(
    componentId: 'alert',
    symbol: 'Alert',
    hasApiTable: true,
    parseClean: true,
    summary: 'A bordered banner that highlights a message.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'leading',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional leading widget, usually a 16px `Icon`.',
      ),
      DocsApiParam(
        name: 'title',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional title widget.',
      ),
      DocsApiParam(
        name: 'content',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional descriptive content.',
      ),
      DocsApiParam(
        name: 'trailing',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional trailing widget (actions/dismissal).',
      ),
      DocsApiParam(
        name: 'variant',
        type: 'AlertVariant',
        isRequired: false,
        defaultValue: 'AlertVariant.base',
        doc: 'Visual variant. Defaults to [AlertVariant.base].',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'AlertTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'progress': DocsApiTable(
    componentId: 'progress',
    symbol: 'Progress',
    hasApiTable: true,
    parseClean: true,
    summary: 'A horizontal progress bar.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'value',
        type: 'double?',
        isRequired: false,
        doc: 'Fraction complete in `0..1`, or null for an indeterminate bar.',
      ),
      DocsApiParam(
        name: 'height',
        type: 'double?',
        isRequired: false,
        doc: 'Bar height override.',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc: 'Corner radius override.',
      ),
      DocsApiParam(
        name: 'color',
        type: 'Color?',
        isRequired: false,
        doc: 'Fill colour override.',
      ),
      DocsApiParam(
        name: 'backgroundColor',
        type: 'Color?',
        isRequired: false,
        doc: 'Track colour override.',
      ),
      DocsApiParam(
        name: 'showSparks',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether to paint a glow at the leading edge.',
      ),
      DocsApiParam(
        name: 'disableAnimation',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether value changes jump instead of animating.',
      ),
      DocsApiParam(
        name: 'semanticsLabel',
        type: 'String?',
        isRequired: false,
        doc: 'Semantic label, e.g. `\'Uploading\'`.',
      ),
      DocsApiParam(
        name: 'semanticsValue',
        type: 'String?',
        isRequired: false,
        doc: 'Semantic value, e.g. `\'40%\'`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ProgressTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'skeleton': DocsApiTable(
    componentId: 'skeleton',
    symbol: 'Skeleton',
    hasApiTable: true,
    parseClean: true,
    summary: 'A shimmering placeholder shown while [content] is still loading.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc:
            'The real content, laid out but painted only while [enabled] is false.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether the placeholder is shown. A disabled skeleton paints [child].',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc:
            'Corner radius override; null uses `SkeletonTheme.borderRadius` and then\nthe theme\'s `borderRadiusMd`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SkeletonTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'spinner': DocsApiTable(
    componentId: 'spinner',
    symbol: 'Spinner',
    hasApiTable: true,
    parseClean: true,
    summary: 'An indeterminate circular indicator.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'size',
        type: 'double?',
        isRequired: false,
        doc:
            'Diameter override; null uses [SpinnerTheme.size] then `24 * scaling`.',
      ),
      DocsApiParam(
        name: 'strokeWidth',
        type: 'double?',
        isRequired: false,
        doc:
            'Arc thickness override; null uses [SpinnerTheme.strokeWidth] then\n`size / 12`.',
      ),
      DocsApiParam(
        name: 'color',
        type: 'Color?',
        isRequired: false,
        doc: 'Arc colour override.',
      ),
      DocsApiParam(
        name: 'semanticsLabel',
        type: 'String?',
        isRequired: false,
        doc: 'Semantic label, e.g. `\'Loading\'`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SpinnerTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'toast': DocsApiTable(
    componentId: 'toast',
    symbol: 'ToastLayer',
    hasApiTable: true,
    parseClean: true,
    params: <DocsApiParam>[
      DocsApiParam(name: 'child', type: 'Widget', isRequired: true),
      DocsApiParam(
        name: 'controller',
        type: 'ToastController?',
        isRequired: false,
      ),
      DocsApiParam(name: 'theme', type: 'ToastTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'autocomplete': DocsApiTable(
    componentId: 'autocomplete',
    symbol: 'AutoCompleteFeature',
    hasApiTable: true,
    parseClean: true,
    summary:
        'The `input`-component adapter: an [InputFeature] that turns the field text into the `autocomplete` suggestion popover.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'suggestions',
        type: 'SuggestionBuilder',
        isRequired: true,
        doc: 'Provides the suggestions for a query. May be asynchronous.',
      ),
      DocsApiParam(
        name: 'mode',
        type: 'AutoCompleteMode?',
        isRequired: false,
        doc: 'Overrides `AutoCompleteTheme.mode`.',
      ),
      DocsApiParam(
        name: 'completer',
        type: 'AutoCompleteCompleter',
        isRequired: false,
        defaultValue: 'identityAutoCompleteCompleter',
        doc: 'Post-processes a suggestion before it is applied.',
      ),
      DocsApiParam(
        name: 'onSuggestionSelected',
        type: 'ValueChanged<String>?',
        isRequired: false,
        doc: 'Called after a suggestion was written into the field.',
      ),
      DocsApiParam(
        name: 'itemBuilder',
        type: 'SuggestionRowBuilder?',
        isRequired: false,
        doc: 'Builds one suggestion row; null renders the shadcn default.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'AutoCompleteTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override for the suggestion list.',
      ),
      DocsApiParam(name: 'visibility', type: '', isRequired: false),
      DocsApiParam(name: 'skipFocusTraversal', type: '', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'checkbox': DocsApiTable(
    componentId: 'checkbox',
    symbol: 'Checkbox',
    hasApiTable: true,
    parseClean: true,
    summary: 'A tri-state checkbox.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'value',
        type: 'CheckboxValue',
        isRequired: false,
        defaultValue: 'CheckboxValue.unchecked',
        doc: 'Current value in controlled mode.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'CheckboxController?',
        isRequired: false,
        doc: 'Controller mode: the controller owns the value.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<CheckboxValue>?',
        isRequired: false,
        doc: 'Called with the next value in controlled mode.',
      ),
      DocsApiParam(
        name: 'tristate',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether a tap cycles through the indeterminate state as well.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc:
            'Overrides the enabled state; null means "interactive when controlled or\ncontroller-driven".',
      ),
      DocsApiParam(
        name: 'label',
        type: 'Widget?',
        isRequired: false,
        doc: 'Text shown next to the box.',
      ),
      DocsApiParam(
        name: 'size',
        type: 'double?',
        isRequired: false,
        doc: 'Side length of the box; null falls back to the size table.',
      ),
      DocsApiParam(
        name: 'gap',
        type: 'double?',
        isRequired: false,
        doc:
            'Space between the box and [label]; null falls back to the size table.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc:
            'Padding around the whole control; null falls back to the size table.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc:
            'Focus node. A node is created internally when [autofocus] is true and\nthis is null.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the checkbox requests focus when first built.',
      ),
      DocsApiParam(
        name: 'onHover',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the hover state changes.',
      ),
      DocsApiParam(
        name: 'onFocusChange',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the focus state changes.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CheckboxStyle?',
        isRequired: false,
        doc: 'Widget-leg override, merged over the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'chip_input': DocsApiTable(
    componentId: 'chip_input',
    symbol: 'ChipInput',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A token field: text typed next to [chip] widgets, each with its own remove button.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'onChipSubmit',
        type: 'ChipSubmitCallback<T>',
        isRequired: true,
        doc: 'Converts the word at the caret into a chip; null rejects it.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'TokenEditingController<T>?',
        isRequired: false,
        doc:
            'Owns the field text and its tokens; created and disposed here when null.',
      ),
      DocsApiParam(
        name: 'initialChips',
        type: 'List<T>?',
        isRequired: false,
        doc:
            'Chips an uncontrolled field starts with; ignored in controlled mode.',
      ),
      DocsApiParam(
        name: 'chips',
        type: 'List<T>?',
        isRequired: false,
        doc: 'Controlled mode: the chips to render.',
      ),
      DocsApiParam(
        name: 'onChipsChanged',
        type: 'ValueChanged<List<T>>?',
        isRequired: false,
        doc: 'Called with the new chip list whenever it changes.',
      ),
      DocsApiParam(
        name: 'chipBuilder',
        type: 'ChipBuilder<T>?',
        isRequired: false,
        doc: 'Builds each chip\'s content; defaults to a `Text` of the value.',
      ),
      DocsApiParam(
        name: 'suggestions',
        type: 'SuggestionBuilder?',
        isRequired: false,
        doc:
            'Suggestions for the current word; an accepted one becomes a chip.',
      ),
      DocsApiParam(
        name: 'features',
        type: 'List<InputFeature>',
        isRequired: false,
        defaultValue: 'const <InputFeature>[]',
        doc:
            'Extra input features, installed before the field\'s own key bindings.',
      ),
      DocsApiParam(
        name: 'clipboardHandler',
        type: 'TokenClipboardHandler<T>?',
        isRequired: false,
        doc:
            'Chip clipboard serialization; defaults to [PlainTokenClipboardHandler].',
      ),
      DocsApiParam(
        name: 'hintText',
        type: 'String?',
        isRequired: false,
        doc: 'Hint shown while the field is empty.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Focus node of the field.',
      ),
      DocsApiParam(
        name: 'keyboardType',
        type: 'TextInputType?',
        isRequired: false,
        doc:
            'Keyboard type of the field; the keyboard action is always `done`.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether the field accepts input; a disabled field is dimmed to 50%.',
      ),
      DocsApiParam(
        name: 'readOnly',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the text and the chips can be edited.',
      ),
      DocsApiParam(
        name: 'validator',
        type: 'String? Function(List<T> chips)?',
        isRequired: false,
        doc:
            'Validates the chip list; a non-null result paints a destructive border\nand shows the message below the field.',
      ),
      DocsApiParam(
        name: 'autovalidateMode',
        type: 'FormValidationMode',
        isRequired: false,
        defaultValue: 'FormValidationMode.changed',
        doc: 'When [validator] runs.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ChipInputTheme?',
        isRequired: false,
        doc: 'Widget-leg token overrides, merged over the other legs.',
      ),
      DocsApiParam(
        name: 'inputTheme',
        type: 'InputTheme?',
        isRequired: false,
        doc: 'Widget-leg overrides for the field surface itself.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'dropzone': DocsApiTable(
    componentId: 'dropzone',
    symbol: 'Dropzone',
    hasApiTable: true,
    parseClean: true,
    summary: 'A dashed-look upload surface.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'state',
        type: 'DropzoneState',
        isRequired: false,
        defaultValue: 'DropzoneState.idle',
        doc: 'Current upload state.',
      ),
      DocsApiParam(
        name: 'isDragOver',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc:
            'Whether a drag is hovering over the surface right now. Takes precedence\nover [state] for the border and the icon scale, because it is the live\nsignal while [state] is the last committed outcome.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the surface accepts input.',
      ),
      DocsApiParam(
        name: 'focused',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the surface is focused for keyboard interaction.',
      ),
      DocsApiParam(
        name: 'icon',
        type: 'Widget?',
        isRequired: false,
        doc: 'Icon above the status line; null uses the upload glyph.',
      ),
      DocsApiParam(
        name: 'hint',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional helper line under the status line.',
      ),
      DocsApiParam(
        name: 'content',
        type: 'Widget?',
        isRequired: false,
        doc:
            'Extra content below the action, or below the status line when\n[showAction] is false.',
      ),
      DocsApiParam(
        name: 'actionLabel',
        type: 'String?',
        isRequired: false,
        doc: 'Browse button label; null resolves the localized default.',
      ),
      DocsApiParam(
        name: 'onBrowse',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Called when the browse button is pressed.',
      ),
      DocsApiParam(
        name: 'actionVariant',
        type: 'ButtonVariant',
        isRequired: false,
        defaultValue: 'ButtonVariant.outline',
        doc: 'Browse button variant.',
      ),
      DocsApiParam(
        name: 'showAction',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether to render the browse button at all.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'DropzoneTheme?',
        isRequired: false,
        doc: 'Widget-leg style override.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Focus node for keyboard activation; null creates one internally.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the surface requests focus when first built.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'file_picker': DocsApiTable(
    componentId: 'file_picker',
    symbol: 'FileUpload',
    hasApiTable: true,
    parseClean: true,
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'variant',
        type: 'FileUploadVariant',
        isRequired: false,
        defaultValue: 'FileUploadVariant.dragDrop',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'FileUploadController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'constraints',
        type: 'FileConstraints',
        isRequired: false,
        defaultValue: 'const FileConstraints()',
      ),
      DocsApiParam(name: 'pick', type: 'FileUploadPick?', isRequired: false),
      DocsApiParam(name: 'upload', type: 'FileUploadFn?', isRequired: false),
      DocsApiParam(
        name: 'dropTargetBuilder',
        type: 'FileUploadDropTargetBuilder?',
        isRequired: false,
        doc:
            'Platform drag intake wrapper; null leaves the dropzone click-only.',
      ),
      DocsApiParam(
        name: 'onFilesChanged',
        type: 'ValueChanged<List<FileValue>>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onComplete',
        type: 'ValueChanged<List<FileValue>>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onError',
        type: 'ValueChanged<FileError>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'layout',
        type: 'FileUploadItemsLayout',
        isRequired: false,
        defaultValue: 'FileUploadItemsLayout.list',
      ),
      DocsApiParam(
        name: 'gridColumns',
        type: 'int',
        isRequired: false,
        defaultValue: '2',
      ),
      DocsApiParam(
        name: 'groupKey',
        type: 'String Function(FileItem item)?',
        isRequired: false,
        doc:
            'Groups rows under a header per returned key; null keeps one list.',
      ),
      DocsApiParam(
        name: 'groupHeaderBuilder',
        type: 'Widget Function(BuildContext context, String key)?',
        isRequired: false,
        doc: 'Builds a group header; null renders the key as muted text.',
      ),
      DocsApiParam(
        name: 'iconBuilder',
        type: 'FileUploadIconBuilder?',
        isRequired: false,
        doc: 'Per-row thumbnail builder; null renders the extension icon.',
      ),
      DocsApiParam(name: 'itemsMaxHeight', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'maxConcurrentUploads',
        type: 'int',
        isRequired: false,
        defaultValue: '1',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'theme', type: 'FileUploadTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'form': DocsApiTable(
    componentId: 'form',
    symbol: 'ShadcnForm',
    hasApiTable: true,
    parseClean: true,
    summary: 'Provides form state and installs [onSubmit] on the controller.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The subtree containing the form fields.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'FormController?',
        isRequired: false,
        doc:
            'External controller; a private one is created and disposed when null.',
      ),
      DocsApiParam(
        name: 'onSubmit',
        type: 'FormSubmitCallback?',
        isRequired: false,
        doc: 'Called by `FormController.submit` after a successful validation.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'formatted_input': DocsApiTable(
    componentId: 'formatted_input',
    symbol: 'FormattedInput',
    hasApiTable: true,
    parseClean: true,
    summary: 'A field made of static separators and small editable segments.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'controller',
        type: 'FormattedInputController?',
        isRequired: false,
        doc: 'Uncontrolled mode: the controller owns the value.',
      ),
      DocsApiParam(
        name: 'initialValue',
        type: 'SegmentedValue?',
        isRequired: false,
        doc: 'Initial value; ignored in controlled mode.',
      ),
      DocsApiParam(
        name: 'value',
        type: 'SegmentedValue?',
        isRequired: false,
        doc: 'Controlled mode: the current value.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<SegmentedValue>?',
        isRequired: false,
        doc: 'Controlled mode: called with the next value.',
      ),
      DocsApiParam(
        name: 'leading',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget before the parts.',
      ),
      DocsApiParam(
        name: 'trailing',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget after the parts.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether the field accepts input; a disabled field is dimmed to 50%.',
      ),
      DocsApiParam(
        name: 'validator',
        type: 'String? Function(String? text)?',
        isRequired: false,
        doc:
            'Validation of the joined text; a non-null result shows below the field.',
      ),
      DocsApiParam(
        name: 'autovalidateMode',
        type: 'FormValidationMode',
        isRequired: false,
        defaultValue: 'FormValidationMode.changed',
        doc:
            'When [validator] runs: `initial`, `changed` (default) or `submitted`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'FormattedInputTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'input': DocsApiTable(
    componentId: 'input',
    symbol: 'Input',
    hasApiTable: true,
    parseClean: true,
    summary: 'A single-line (or multi-line) text field.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'controller',
        type: 'TextEditingController?',
        isRequired: false,
      ),
      DocsApiParam(name: 'initialValue', type: 'String?', isRequired: false),
      DocsApiParam(name: 'focusNode', type: 'FocusNode?', isRequired: false),
      DocsApiParam(
        name: 'undoController',
        type: 'UndoHistoryController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'statesController',
        type: 'WidgetStatesController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'keyboardType',
        type: 'TextInputType?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'textInputAction',
        type: 'TextInputAction?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'textCapitalization',
        type: 'TextCapitalization',
        isRequired: false,
        defaultValue: 'TextCapitalization.none',
      ),
      DocsApiParam(name: 'style', type: 'TextStyle?', isRequired: false),
      DocsApiParam(name: 'placeholder', type: 'Widget?', isRequired: false),
      DocsApiParam(name: 'hintText', type: 'String?', isRequired: false),
      DocsApiParam(
        name: 'textAlign',
        type: 'TextAlign',
        isRequired: false,
        defaultValue: 'TextAlign.start',
      ),
      DocsApiParam(
        name: 'maxLines',
        type: 'int?',
        isRequired: false,
        defaultValue: '1',
      ),
      DocsApiParam(name: 'minLines', type: 'int?', isRequired: false),
      DocsApiParam(
        name: 'expands',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(name: 'maxLength', type: 'int?', isRequired: false),
      DocsApiParam(
        name: 'maxLengthEnforcement',
        type: 'MaxLengthEnforcement?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'obscureText',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'obscuringCharacter',
        type: 'String',
        isRequired: false,
        defaultValue: '\'•\'',
      ),
      DocsApiParam(
        name: 'readOnly',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'autocorrect',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'enableSuggestions',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'inputFormatters',
        type: 'List<TextInputFormatter>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'autofillHints',
        type: 'Iterable<String>?',
        isRequired: false,
      ),
      DocsApiParam(name: 'cursorColor', type: 'Color?', isRequired: false),
      DocsApiParam(
        name: 'cursorWidth',
        type: 'double',
        isRequired: false,
        defaultValue: '2.0',
      ),
      DocsApiParam(name: 'cursorHeight', type: 'double?', isRequired: false),
      DocsApiParam(name: 'cursorRadius', type: 'Radius?', isRequired: false),
      DocsApiParam(
        name: 'scrollPadding',
        type: 'EdgeInsets',
        isRequired: false,
        defaultValue: 'const EdgeInsets.all(20)',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<String>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onEditingComplete',
        type: 'VoidCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onSubmitted',
        type: 'ValueChanged<String>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onTapOutside',
        type: 'TapRegionCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'selectionControls',
        type: 'TextSelectionControls?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'contextMenuBuilder',
        type: 'EditableTextContextMenuBuilder?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'decoration',
        type: 'BoxDecoration?',
        isRequired: false,
      ),
      DocsApiParam(name: 'border', type: 'Border?', isRequired: false),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
      ),
      DocsApiParam(name: 'filled', type: 'bool?', isRequired: false),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'features',
        type: 'List<InputFeature>',
        isRequired: false,
        defaultValue: 'const <InputFeature>[]',
      ),
      DocsApiParam(
        name: 'validator',
        type: 'String? Function(String? value)?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'autovalidateMode',
        type: 'FormValidationMode',
        isRequired: false,
        defaultValue: 'FormValidationMode.changed',
      ),
      DocsApiParam(
        name: 'groupId',
        type: 'Object',
        isRequired: false,
        defaultValue: 'EditableText',
      ),
      DocsApiParam(name: 'theme', type: 'InputTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'input_otp': DocsApiTable(
    componentId: 'input_otp',
    symbol: 'InputOtp',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A one-time-password / verification-code input. The code lives in one hidden field; the slots are painted from the string (see README.md).',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'length',
        type: 'int',
        isRequired: true,
        doc: 'Number of slots.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'TextEditingController?',
        isRequired: false,
        doc: 'Controller for the whole code; created internally when null.',
      ),
      DocsApiParam(
        name: 'initialValue',
        type: 'String?',
        isRequired: false,
        doc: 'Initial code; ignored when [controller] is given.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<String>?',
        isRequired: false,
        doc: 'Called with the whole code whenever it changes.',
      ),
      DocsApiParam(
        name: 'onCompleted',
        type: 'ValueChanged<String>?',
        isRequired: false,
        doc: 'Called once, the first time every slot is filled.',
      ),
      DocsApiParam(
        name: 'onSubmitted',
        type: 'ValueChanged<String>?',
        isRequired: false,
        doc:
            'Called when the field is submitted (Enter / the platform action).',
      ),
      DocsApiParam(
        name: 'keyboardType',
        type: 'TextInputType',
        isRequired: false,
        defaultValue: 'TextInputType.number',
        doc: 'Keyboard type; digits by default.',
      ),
      DocsApiParam(
        name: 'obscureText',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether each character is replaced by a dot.',
      ),
      DocsApiParam(
        name: 'readOnly',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the code can be edited.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether the field accepts input; a disabled field is dimmed to 50%.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc:
            '`autofocus`, `textCapitalization`, `autofillHints` and `inputFormatters`\npass straight through to the hidden field; README.md lists their defaults.',
      ),
      DocsApiParam(
        name: 'textCapitalization',
        type: 'TextCapitalization',
        isRequired: false,
        defaultValue: 'TextCapitalization.none',
      ),
      DocsApiParam(
        name: 'autofillHints',
        type: 'Iterable<String>?',
        isRequired: false,
        defaultValue: 'const <String>[AutofillHints.oneTimeCode]',
      ),
      DocsApiParam(
        name: 'inputFormatters',
        type: 'List<TextInputFormatter>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'filter',
        type: 'bool Function(String character)?',
        isRequired: false,
        doc:
            'Rejects a character when it returns false. Null accepts everything.',
      ),
      DocsApiParam(
        name: 'separator',
        type: 'Widget?',
        isRequired: false,
        doc:
            'Widget drawn after every [separatorEvery] slots; needs [separatorEvery].',
      ),
      DocsApiParam(
        name: 'separatorEvery',
        type: 'int?',
        isRequired: false,
        doc: 'Slots between two separators.',
      ),
      DocsApiParam(
        name: 'validator',
        type: 'String? Function(String? code)?',
        isRequired: false,
        doc:
            'Validation of the whole code; the message renders below the row, but only\nonce every slot is filled. The validator itself runs on every change\n(per [autovalidateMode]) and sees partial codes along the way.',
      ),
      DocsApiParam(
        name: 'autovalidateMode',
        type: 'FormValidationMode',
        isRequired: false,
        defaultValue: 'FormValidationMode.changed',
        doc:
            'When [validator] runs: `initial` on mount, `changed` on every change,\n`submitted` on submit; all three also when [validator] itself changes.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'InputOtpTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'item_picker': DocsApiTable(
    componentId: 'item_picker',
    symbol: 'ItemPicker',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Field editing a value by picking one item; a tap selects and closes.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'items',
        type: 'ItemChildDelegate<T>',
        isRequired: true,
      ),
      DocsApiParam(
        name: 'builder',
        type: 'ItemPickerBuilder<T>',
        isRequired: true,
      ),
      DocsApiParam(name: 'value', type: 'T?', isRequired: false),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<T?>?',
        isRequired: false,
        doc: 'Called with the next value; null disables the field.',
      ),
      DocsApiParam(
        name: 'layout',
        type: 'ItemPickerLayout',
        isRequired: false,
        defaultValue: 'ItemPickerLayout.grid',
      ),
      DocsApiParam(name: 'placeholder', type: 'Widget?', isRequired: false),
      DocsApiParam(
        name: 'title',
        type: 'Widget?',
        isRequired: false,
        doc: 'Heading of the dialog prompt.',
      ),
      DocsApiParam(
        name: 'mode',
        type: 'PromptMode',
        isRequired: false,
        defaultValue: 'PromptMode.dialog',
        doc: 'Dialog or popover presentation.',
      ),
      DocsApiParam(
        name: 'constraints',
        type: 'BoxConstraints?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ItemPickerTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged over the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'multi_select': DocsApiTable(
    componentId: 'multi_select',
    symbol: 'MultiSelect',
    hasApiTable: true,
    parseClean: true,
    summary: 'A multi-selection dropdown.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'itemBuilder',
        type: 'SelectValueBuilder<T>',
        isRequired: true,
        doc:
            'Builds one selected value in the trigger (usually a `MultiSelectChip`).',
      ),
      DocsApiParam(
        name: 'value',
        type: 'Iterable<T>?',
        isRequired: false,
        doc: 'The selected values.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<Iterable<T>?>?',
        isRequired: false,
        doc: 'Called with the next selection; null disables the select.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc: 'Overrides the enabled state; null means `onChanged != null`.',
      ),
      DocsApiParam(
        name: 'placeholder',
        type: 'Widget?',
        isRequired: false,
        doc: 'Shown in the trigger while no value is selected.',
      ),
      DocsApiParam(
        name: 'items',
        type: 'FutureOr<List<Widget>>?',
        isRequired: false,
        doc: 'The popup rows; ignored when [builder] is set.',
      ),
      DocsApiParam(
        name: 'builder',
        type: 'SelectItemsBuilder?',
        isRequired: false,
        doc:
            'Builds the popup rows for a search query; enables the search field.',
      ),
      DocsApiParam(
        name: 'searchPlaceholder',
        type: 'Widget?',
        isRequired: false,
        doc: 'Placeholder of the search field (shown when [builder] is set).',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Trigger focus node.',
      ),
      DocsApiParam(
        name: 'expandIcon',
        type: 'Widget?',
        isRequired: false,
        defaultValue: 'const Icon(LucideIcons.chevronsUpDown)',
        doc: 'Trigger trailing icon; null hides it.',
      ),
      DocsApiParam(
        name: 'canUnselect',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether picking a selected item removes it. Default: true.',
      ),
      DocsApiParam(
        name: 'autoClose',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc:
            'Whether picking an item closes the popup. Default: false, so several\nvalues can be toggled in a row.',
      ),
      DocsApiParam(
        name: 'popupConstraints',
        type: 'BoxConstraints?',
        isRequired: false,
        doc: 'Popup size constraints; null resolves `SelectTheme.constraints`.',
      ),
      DocsApiParam(
        name: 'valueSelectionHandler',
        type: 'SelectValueSelectionHandler<Iterable<T>>?',
        isRequired: false,
        doc: 'Custom selection mapping; null toggles the item.',
      ),
      DocsApiParam(
        name: 'valueSelectionPredicate',
        type: 'SelectValueSelectionPredicate<Iterable<T>>?',
        isRequired: false,
        doc: 'Custom selection test; null is `value.contains(test)`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SelectTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'object_input': DocsApiTable(
    componentId: 'object_input',
    symbol: 'DateInput',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A typed date field: locale-ordered segments with a calendar prompt (dialog or popover) behind the trailing button. Incomplete or impossible dates report null; controlled with [value] + [onChanged], uncontrolled with [initialValue], disabled with null [onChanged].',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'value',
        type: 'DateTime?',
        isRequired: false,
        doc: 'Controlled value; null with [onChanged] set means "no date".',
      ),
      DocsApiParam(
        name: 'initialValue',
        type: 'DateTime?',
        isRequired: false,
        doc: 'Uncontrolled seed; ignored once the field owns its state.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<DateTime?>?',
        isRequired: false,
        doc: 'Called with the next date (null while incomplete/invalid).',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the field accepts input; disabled dims to 50%.',
      ),
      DocsApiParam(
        name: 'datePartsOrder',
        type: 'List<DatePart>?',
        isRequired: false,
        doc: 'Segment order; null uses the locale order.',
      ),
      DocsApiParam(
        name: 'separator',
        type: 'String',
        isRequired: false,
        defaultValue: '\'/\'',
        doc: 'Text between segments.',
      ),
      DocsApiParam(
        name: 'placeholders',
        type: 'Map<DatePart, Widget>?',
        isRequired: false,
        doc: 'Per-part placeholder overrides; null uses locale abbreviations.',
      ),
      DocsApiParam(
        name: 'validator',
        type: 'String? Function(DateTime? value)?',
        isRequired: false,
        doc:
            'Validates the parsed date; a non-null result shows below the field.',
      ),
      DocsApiParam(
        name: 'mode',
        type: 'PromptMode?',
        isRequired: false,
        doc:
            'Calendar prompt presentation; null is popover on desktop widths\n(≥ 768 logical pixels), dialog below (popover needs `OverlayManager`).',
      ),
      DocsApiParam(
        name: 'initialView',
        type: 'CalendarView?',
        isRequired: false,
        doc: 'Calendar sheet: starting month view.',
      ),
      DocsApiParam(
        name: 'initialViewType',
        type: 'CalendarViewType?',
        isRequired: false,
        doc: 'Calendar sheet: starting grid.',
      ),
      DocsApiParam(
        name: 'stateBuilder',
        type: 'DateStateBuilder?',
        isRequired: false,
        doc: 'Calendar sheet: per-date enablement.',
      ),
      DocsApiParam(
        name: 'dialogTitle',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional title above the calendar dialog.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'FormattedInputTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, forwarded to [FormattedInput].',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'phone_input': DocsApiTable(
    componentId: 'phone_input',
    symbol: 'PhoneInput',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A country selector plus a number field (an optional dial-code prefix plus the national number). `onChanged` reports a [PhoneNumber] whenever either side changes, and null while the number is empty.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'initialCountry',
        type: 'Country?',
        isRequired: false,
        doc: 'Country selected when [initialValue] carries none.',
      ),
      DocsApiParam(
        name: 'initialValue',
        type: 'PhoneNumber?',
        isRequired: false,
        doc: 'Initial country + national number.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<PhoneNumber?>?',
        isRequired: false,
        doc: 'Called with the next value; null while the number is empty.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'TextEditingController?',
        isRequired: false,
        doc:
            'External text controller for the national number. When null the widget\nowns one seeded from [initialValue].',
      ),
      DocsApiParam(
        name: 'onlyNumber',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the number field accepts digits only.',
      ),
      DocsApiParam(
        name: 'countries',
        type: 'List<CountryInfo>?',
        isRequired: false,
        doc: 'Rows offered by the selector; null uses the full ISO table.',
      ),
      DocsApiParam(
        name: 'searchPlaceholder',
        type: 'Widget?',
        isRequired: false,
        doc: 'Placeholder of the selector\'s search field.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'PhoneInputTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'radio_group': DocsApiTable(
    componentId: 'radio_group',
    symbol: 'ShadcnRadioGroup',
    hasApiTable: true,
    parseClean: true,
    summary: 'A single-select group of radio items.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'items',
        type: 'List<Widget>',
        isRequired: true,
        doc: 'The items, stacked by the group along [direction].',
      ),
      DocsApiParam(
        name: 'value',
        type: 'T?',
        isRequired: false,
        doc: 'The selected value in controlled mode.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'ShadcnRadioGroupController<T>?',
        isRequired: false,
        doc: 'Controller mode: the controller owns the selection.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<T>?',
        isRequired: false,
        doc: 'Called with the newly selected value in controlled mode.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc:
            'Overrides the enabled state; null means "interactive when driven".',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.vertical',
        doc:
            'Arrow-key reading order: vertical walks top to bottom, horizontal left to\nright.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'RadioGroupTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override for the group.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'select': DocsApiTable(
    componentId: 'select',
    symbol: 'Select',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A single-selection dropdown picker: the trigger shows [itemBuilder]\'s rendering of [value] (or [placeholder] while [value] is null). Tapping opens a popover of [items] (or the asynchronous [builder], which enables a search field); picking a row reports through [onChanged], and forms see the value through `FormValueSupplier`.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'itemBuilder',
        type: 'SelectValueBuilder<T>',
        isRequired: true,
        doc: 'Builds the trigger content of the selected value.',
      ),
      DocsApiParam(
        name: 'value',
        type: 'T?',
        isRequired: false,
        doc: 'The selected value; null shows [placeholder].',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<T?>?',
        isRequired: false,
        doc: 'Called with the next selection; null disables the select.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc: 'Overrides the enabled state; null means `onChanged != null`.',
      ),
      DocsApiParam(
        name: 'placeholder',
        type: 'Widget?',
        isRequired: false,
        doc: 'Shown in the trigger while [value] is null.',
      ),
      DocsApiParam(
        name: 'items',
        type: 'FutureOr<List<Widget>>?',
        isRequired: false,
        doc: 'The popup rows; ignored when [builder] is set.',
      ),
      DocsApiParam(
        name: 'builder',
        type: 'SelectItemsBuilder?',
        isRequired: false,
        doc:
            'Builds the popup rows for a search query; enables the search field.',
      ),
      DocsApiParam(
        name: 'searchPlaceholder',
        type: 'Widget?',
        isRequired: false,
        doc: 'Placeholder of the search field (shown when [builder] is set).',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Trigger focus node.',
      ),
      DocsApiParam(
        name: 'expandIcon',
        type: 'Widget?',
        isRequired: false,
        defaultValue: 'const Icon(LucideIcons.chevronsUpDown)',
        doc: 'Trigger trailing icon; null hides it.',
      ),
      DocsApiParam(
        name: 'canUnselect',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether picking the selected value clears the selection.',
      ),
      DocsApiParam(
        name: 'autoClose',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether picking a value closes the popup. Default: true (single\nselection); `multi_select` passes false so the popup stays open.',
      ),
      DocsApiParam(
        name: 'popupConstraints',
        type: 'BoxConstraints?',
        isRequired: false,
        doc:
            'Popup size constraints; null resolves `SelectTheme.constraints`, then\n192-320 wide and 240 high. The popup is always trigger-wide.',
      ),
      DocsApiParam(
        name: 'valueSelectionHandler',
        type: 'SelectValueSelectionHandler<T>?',
        isRequired: false,
        doc: 'Custom selection mapping; null is single selection.',
      ),
      DocsApiParam(
        name: 'valueSelectionPredicate',
        type: 'SelectValueSelectionPredicate<T>?',
        isRequired: false,
        doc: 'Custom selection test; null is `value == test`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SelectTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'slider': DocsApiTable(
    componentId: 'slider',
    symbol: 'Slider',
    hasApiTable: true,
    parseClean: true,
    summary: 'A single-thumb slider.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'value',
        type: 'double',
        isRequired: true,
        doc: 'Current single value (single mode). Ignored in range mode.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<double>?',
        isRequired: true,
        doc: 'Called with the next value (single mode).',
      ),
      DocsApiParam(
        name: 'min',
        type: 'double',
        isRequired: false,
        defaultValue: '0',
        doc: 'Domain minimum.',
      ),
      DocsApiParam(
        name: 'max',
        type: 'double',
        isRequired: false,
        defaultValue: '1',
        doc: 'Domain maximum; must be greater than [min].',
      ),
      DocsApiParam(
        name: 'snap',
        type: 'SliderSnap',
        isRequired: false,
        defaultValue: 'const SliderSnap.none()',
        doc: 'Snapping applied to tap/drag/keyboard output.',
      ),
      DocsApiParam(
        name: 'variant',
        type: 'SliderVariant',
        isRequired: false,
        defaultValue: 'SliderVariant.standard',
        doc: 'Visual variant (track/thumb/mark style).',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the slider reacts to gestures and keys.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SliderStyle?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged under style/tree/app legs.',
      ),
      DocsApiParam(
        name: 'semanticLabel',
        type: 'String?',
        isRequired: false,
        doc: 'Accessibility label.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Focus node; one is created internally when null.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether to take focus when first built.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'star_rating': DocsApiTable(
    componentId: 'star_rating',
    symbol: 'StarRating',
    hasApiTable: true,
    parseClean: true,
    summary: 'An interactive star rating.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'value', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'controller',
        type: 'StarRatingController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<double>?',
        isRequired: false,
      ),
      DocsApiParam(name: 'enabled', type: 'bool?', isRequired: false),
      DocsApiParam(
        name: 'step',
        type: 'double',
        isRequired: false,
        defaultValue: '0.5',
      ),
      DocsApiParam(
        name: 'max',
        type: 'double',
        isRequired: false,
        defaultValue: '5',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.horizontal',
      ),
      DocsApiParam(name: 'focusNode', type: 'FocusNode?', isRequired: false),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'onHover',
        type: 'ValueChanged<bool>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onFocusChange',
        type: 'ValueChanged<bool>?',
        isRequired: false,
      ),
      DocsApiParam(name: 'theme', type: 'StarRatingStyle?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'switch': DocsApiTable(
    componentId: 'switch',
    symbol: 'Switch',
    hasApiTable: true,
    parseClean: true,
    summary: 'An on/off switch.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'value',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Current value in controlled mode.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'SwitchController?',
        isRequired: false,
        doc: 'Controller mode: the controller owns the value.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called with the next value in controlled mode.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc:
            'Overrides the enabled state; null means "interactive when controlled or\ncontroller-driven".',
      ),
      DocsApiParam(
        name: 'label',
        type: 'Widget?',
        isRequired: false,
        doc: 'Text shown next to the switch.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc:
            'Focus node. A node is created internally when [autofocus] is true and\nthis is null.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the switch requests focus when first built.',
      ),
      DocsApiParam(
        name: 'onHover',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the hover state changes.',
      ),
      DocsApiParam(
        name: 'onFocusChange',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc: 'Called when the focus state changes.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SwitchStyle?',
        isRequired: false,
        doc: 'Widget-leg override, merged over the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'text_area': DocsApiTable(
    componentId: 'text_area',
    symbol: 'TextArea',
    hasApiTable: true,
    parseClean: true,
    summary: 'A multi-line text input.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'controller',
        type: 'TextEditingController?',
        isRequired: false,
      ),
      DocsApiParam(name: 'initialValue', type: 'String?', isRequired: false),
      DocsApiParam(name: 'focusNode', type: 'FocusNode?', isRequired: false),
      DocsApiParam(
        name: 'undoController',
        type: 'UndoHistoryController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'statesController',
        type: 'WidgetStatesController?',
        isRequired: false,
      ),
      DocsApiParam(name: 'hintText', type: 'String?', isRequired: false),
      DocsApiParam(name: 'placeholder', type: 'Widget?', isRequired: false),
      DocsApiParam(
        name: 'textAlign',
        type: 'TextAlign',
        isRequired: false,
        defaultValue: 'TextAlign.start',
      ),
      DocsApiParam(
        name: 'textCapitalization',
        type: 'TextCapitalization',
        isRequired: false,
        defaultValue: 'TextCapitalization.sentences',
      ),
      DocsApiParam(name: 'style', type: 'TextStyle?', isRequired: false),
      DocsApiParam(
        name: 'keyboardType',
        type: 'TextInputType?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'minLines',
        type: 'int?',
        isRequired: false,
        defaultValue: 'textAreaMinLines',
        doc: 'Smallest height, in lines; defaults to [textAreaMinLines].',
      ),
      DocsApiParam(
        name: 'maxLines',
        type: 'int?',
        isRequired: false,
        defaultValue: 'textAreaMaxLines',
        doc: 'Largest height, in lines; defaults to [textAreaMaxLines].',
      ),
      DocsApiParam(
        name: 'expands',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the field fills its parent instead of growing.',
      ),
      DocsApiParam(name: 'maxLength', type: 'int?', isRequired: false),
      DocsApiParam(
        name: 'maxLengthEnforcement',
        type: 'MaxLengthEnforcement?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'decoration',
        type: 'BoxDecoration?',
        isRequired: false,
      ),
      DocsApiParam(name: 'border', type: 'Border?', isRequired: false),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
      ),
      DocsApiParam(name: 'filled', type: 'bool?', isRequired: false),
      DocsApiParam(
        name: 'readOnly',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'autocorrect',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'enableSuggestions',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'cursorColor', type: 'Color?', isRequired: false),
      DocsApiParam(
        name: 'scrollPadding',
        type: 'EdgeInsets',
        isRequired: false,
        defaultValue: 'const EdgeInsets.all(20)',
      ),
      DocsApiParam(
        name: 'features',
        type: 'List<InputFeature>',
        isRequired: false,
        defaultValue: 'const <InputFeature>[]',
      ),
      DocsApiParam(
        name: 'validator',
        type: 'String? Function(String? value)?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'autovalidateMode',
        type: 'FormValidationMode',
        isRequired: false,
        defaultValue: 'FormValidationMode.changed',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<String>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onSubmitted',
        type: 'ValueChanged<String>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onEditingComplete',
        type: 'VoidCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'theme',
        type: 'InputTheme?',
        isRequired: false,
        doc: 'Widget-leg [InputTheme] override.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'accordion': DocsApiTable(
    componentId: 'accordion',
    symbol: 'Accordion',
    hasApiTable: true,
    parseClean: true,
    summary: 'A container of expandable sections; at most one panel is open.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'items',
        type: 'List<Widget>',
        isRequired: true,
        doc:
            'Usually [AccordionItem] widgets; dividers are inserted between them.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'AccordionTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the other resolver legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'card': DocsApiTable(
    componentId: 'card',
    symbol: 'Card',
    hasApiTable: true,
    parseClean: true,
    summary: 'A rounded surface with a border, a token fill and a soft shadow.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Card content.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc:
            'Padding between the card border and its content; null falls back to\n`cardDefaults.padding`, a density-scaled shadcn `p-6` that `Card`\nresolves against `density.baseContentPadding * scaling`. A literal\noverride passes through unchanged.',
      ),
      DocsApiParam(
        name: 'background',
        type: 'ThemedColor?',
        isRequired: false,
        doc: 'Fill override; null falls back to `CardTheme.background`.',
      ),
      DocsApiParam(
        name: 'borderColor',
        type: 'ThemedColor?',
        isRequired: false,
        doc:
            'Border colour override; null falls back to `CardTheme.borderColor`.',
      ),
      DocsApiParam(
        name: 'borderWidth',
        type: 'double?',
        isRequired: false,
        doc: 'Border width override; `0` hides the border.',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc: 'Corner radius override; null resolves the ambient `radiusXl`.',
      ),
      DocsApiParam(
        name: 'shadows',
        type: 'List<BoxShadow>?',
        isRequired: false,
        doc: 'Shadow override; null resolves the ambient `shadowSm`.',
      ),
      DocsApiParam(
        name: 'clipBehavior',
        type: 'Clip',
        isRequired: false,
        defaultValue: 'Clip.none',
        doc: 'How the card clips its content.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CardTheme?',
        isRequired: false,
        doc:
            'Widget-leg override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'card_image': DocsApiTable(
    componentId: 'card_image',
    symbol: 'CardImage',
    hasApiTable: true,
    parseClean: true,
    summary: 'An interactive card with an image and an optional text block.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'image',
        type: 'Widget',
        isRequired: true,
        doc: 'The image (or any widget) shown in the image surface.',
      ),
      DocsApiParam(
        name: 'title',
        type: 'Widget?',
        isRequired: false,
        doc: 'Title passed to the [Basic] text block.',
      ),
      DocsApiParam(
        name: 'subtitle',
        type: 'Widget?',
        isRequired: false,
        doc: 'Subtitle passed to the [Basic] text block.',
      ),
      DocsApiParam(
        name: 'trailing',
        type: 'Widget?',
        isRequired: false,
        doc: 'Trailing widget passed to the [Basic] text block.',
      ),
      DocsApiParam(
        name: 'leading',
        type: 'Widget?',
        isRequired: false,
        doc: 'Leading widget passed to the [Basic] text block.',
      ),
      DocsApiParam(
        name: 'onPressed',
        type: 'VoidCallback?',
        isRequired: false,
        doc:
            'Called on tap. When null the card is disabled unless [enabled] is true.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc: 'Overrides the enabled state; null means `onPressed != null`.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc:
            'Focus node of the card. The card creates and owns one when this is null.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the card requests focus when first built.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CardImageTheme?',
        isRequired: false,
        doc:
            'Widget-leg override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'collapsible': DocsApiTable(
    componentId: 'collapsible',
    symbol: 'Collapsible',
    hasApiTable: true,
    parseClean: true,
    summary: 'An expandable section.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'children',
        type: 'List<Widget>',
        isRequired: true,
        doc:
            'Usually one [CollapsibleTrigger] followed by [CollapsibleContent]s.',
      ),
      DocsApiParam(
        name: 'isExpanded',
        type: 'bool?',
        isRequired: false,
        doc:
            'Expanded state. Non-null makes the widget controlled; null lets it keep\nits own state.',
      ),
      DocsApiParam(
        name: 'onExpansionChanged',
        type: 'ValueChanged<bool>?',
        isRequired: false,
        doc:
            'Called with the **new** expansion state when the trigger is tapped.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CollapsibleTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the other resolver legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'filter_bar': DocsApiTable(
    componentId: 'filter_bar',
    symbol: 'FilterBar',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A controlled filter bar: search, sort, date range, custom filters, chips and an optional sheet presentation (`FilterBar(state: ..., ...)`).',
    params: <DocsApiParam>[
      DocsApiParam(name: 'state', type: 'FilterState?', isRequired: false),
      DocsApiParam(
        name: 'onStateChanged',
        type: 'ValueChanged<FilterState>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'controller',
        type: 'FilterBarController?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'sortOptions',
        type: 'List<FilterSortOption>',
        isRequired: false,
        defaultValue: 'const <FilterSortOption>[]',
      ),
      DocsApiParam(
        name: 'enableDateRange',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(name: 'resultsCount', type: 'int?', isRequired: false),
      DocsApiParam(
        name: 'searchDebounce',
        type: 'Duration?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'trailingFilters',
        type: 'List<Widget>',
        isRequired: false,
        defaultValue: 'const <Widget>[]',
      ),
      DocsApiParam(
        name: 'customFilters',
        type: 'List<FilterCustomFilter>',
        isRequired: false,
        defaultValue: 'const <FilterCustomFilter>[]',
      ),
      DocsApiParam(
        name: 'clearPolicy',
        type: 'FilterClearPolicy',
        isRequired: false,
        defaultValue: 'const FilterClearPolicy()',
      ),
      DocsApiParam(
        name: 'onClearAll',
        type: 'FilterBarClearResolver?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'showClearAllWhenEmpty',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'presentation',
        type: 'FilterBarPresentation',
        isRequired: false,
        defaultValue: 'FilterBarPresentation.autoSheet',
      ),
      DocsApiParam(
        name: 'sheetBreakpoint',
        type: 'double',
        isRequired: false,
        defaultValue: '720',
      ),
      DocsApiParam(
        name: 'sheetPosition',
        type: 'OverlayPosition',
        isRequired: false,
        defaultValue: 'OverlayPosition.bottom',
      ),
      DocsApiParam(
        name: 'useRootNavigator',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'sheetContentPadding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'groups',
        type: 'List<FilterGroup>',
        isRequired: false,
        defaultValue: 'const <FilterGroup>[]',
      ),
      DocsApiParam(name: 'theme', type: 'FilterBarTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'overflow_marquee': DocsApiTable(
    componentId: 'overflow_marquee',
    symbol: 'OverflowMarquee',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Scrolls [child] along [direction] when it overflows its container and stays still when it fits. The scroll ping-pongs — rest, one run of the overflow, rest, back — with fades at both clipped edges; under reduced motion (`MediaQuery.disableAnimations`) the content holds its position.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Content to scroll.',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis?',
        isRequired: false,
        doc: 'Scroll axis; null uses the theme, then `Axis.horizontal`.',
      ),
      DocsApiParam(
        name: 'duration',
        type: 'Duration?',
        isRequired: false,
        doc:
            'Time one run of [step] pixels takes; a run scales with the overflow.',
      ),
      DocsApiParam(
        name: 'delayDuration',
        type: 'Duration?',
        isRequired: false,
        doc: 'Pause at each end of a run.',
      ),
      DocsApiParam(
        name: 'step',
        type: 'double?',
        isRequired: false,
        doc: 'Pixels covered per [duration].',
      ),
      DocsApiParam(
        name: 'fadePortion',
        type: 'double?',
        isRequired: false,
        doc:
            'Fade width per edge as a fraction of the visible extent (`0..0.5`).',
      ),
      DocsApiParam(
        name: 'curve',
        type: 'Curve?',
        isRequired: false,
        doc: 'Easing of each run.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'OverflowMarqueeTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'resizable': DocsApiTable(
    componentId: 'resizable',
    symbol: 'ResizablePanelGroup',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A container of [ResizablePanel]s separated by [ResizableHandle]s.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'children', type: 'List<Widget>', isRequired: true),
      DocsApiParam(
        name: 'direction',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.horizontal',
      ),
      DocsApiParam(name: 'theme', type: 'ResizableTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'scaffold': DocsApiTable(
    componentId: 'scaffold',
    symbol: 'Scaffold',
    hasApiTable: true,
    parseClean: true,
    summary:
        'App screen shell; fixed bars take layout space, floating bars overlay.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'child', type: 'Widget', isRequired: true),
      DocsApiParam(
        name: 'headers',
        type: 'List<Widget>',
        isRequired: false,
        defaultValue: 'const <Widget>[]',
      ),
      DocsApiParam(
        name: 'footers',
        type: 'List<Widget>',
        isRequired: false,
        defaultValue: 'const <Widget>[]',
      ),
      DocsApiParam(
        name: 'loadingProgress',
        type: 'double?',
        isRequired: false,
        doc: 'Loading fraction 0..1; null hides the bar unless indeterminate.',
      ),
      DocsApiParam(
        name: 'loadingProgressIndeterminate',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether the loading bar animates without a value.',
      ),
      DocsApiParam(
        name: 'floatingHeader',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether headers overlay the body instead of pushing it down.',
      ),
      DocsApiParam(
        name: 'floatingFooter',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether footers overlay the body instead of pushing it up.',
      ),
      DocsApiParam(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'headerBackgroundColor',
        type: 'ThemedColor?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'footerBackgroundColor',
        type: 'ThemedColor?',
        isRequired: false,
      ),
      DocsApiParam(name: 'showLoadingSparks', type: 'bool?', isRequired: false),
      DocsApiParam(
        name: 'resizeToAvoidBottomInset',
        type: 'bool?',
        isRequired: false,
        doc:
            'Whether the body pads for the keyboard; null falls back to the theme.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ScaffoldTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged over the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'scrollbar': DocsApiTable(
    componentId: 'scrollbar',
    symbol: 'Scrollbar',
    hasApiTable: true,
    parseClean: true,
    summary: 'A scrollbar for the nearest scrollable of [child].',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The scrollable widget the scrollbar is stacked on.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'ScrollController?',
        isRequired: false,
        doc:
            'Controller of the scrollable; defaults to the primary controller.',
      ),
      DocsApiParam(
        name: 'thumbVisibility',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether the thumb is always visible.',
      ),
      DocsApiParam(
        name: 'trackVisibility',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether the track is painted behind the thumb.',
      ),
      DocsApiParam(
        name: 'thickness',
        type: 'double?',
        isRequired: false,
        doc: 'Thumb thickness override.',
      ),
      DocsApiParam(
        name: 'radius',
        type: 'Radius?',
        isRequired: false,
        doc: 'Thumb corner radius override.',
      ),
      DocsApiParam(
        name: 'minThumbLength',
        type: 'double?',
        isRequired: false,
        doc: 'Minimum thumb length override.',
      ),
      DocsApiParam(
        name: 'minOverscrollLength',
        type: 'double?',
        isRequired: false,
        doc: 'Minimum thumb length while dragged past an edge.',
      ),
      DocsApiParam(
        name: 'color',
        type: 'ThemedColor?',
        isRequired: false,
        doc: 'Thumb colour override.',
      ),
      DocsApiParam(
        name: 'interactive',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether the thumb responds to drags; defaults to true.',
      ),
      DocsApiParam(
        name: 'notificationPredicate',
        type: 'ScrollNotificationPredicate?',
        isRequired: false,
        doc: 'Which scroll notifications the scrollbar reacts to.',
      ),
      DocsApiParam(
        name: 'scrollbarOrientation',
        type: 'ScrollbarOrientation?',
        isRequired: false,
        doc: 'Side of the scrollable the bar attaches to.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ScrollbarTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the other resolver legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'sortable': DocsApiTable(
    componentId: 'sortable',
    symbol: 'Sortable',
    hasApiTable: true,
    parseClean: true,
    summary: 'A draggable item that accepts drops on its four edges.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'data',
        type: 'SortableData<T>',
        isRequired: true,
        doc: 'The value identifying this item.',
      ),
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The item content.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether drag interactions are enabled.',
      ),
      DocsApiParam(
        name: 'canAcceptTop',
        type: 'Predicate<SortableData<T>>?',
        isRequired: false,
        doc: 'Whether a drop on the top edge is accepted.',
      ),
      DocsApiParam(
        name: 'canAcceptLeft',
        type: 'Predicate<SortableData<T>>?',
        isRequired: false,
        doc: 'Whether a drop on the left edge is accepted.',
      ),
      DocsApiParam(
        name: 'canAcceptRight',
        type: 'Predicate<SortableData<T>>?',
        isRequired: false,
        doc: 'Whether a drop on the right edge is accepted.',
      ),
      DocsApiParam(
        name: 'canAcceptBottom',
        type: 'Predicate<SortableData<T>>?',
        isRequired: false,
        doc: 'Whether a drop on the bottom edge is accepted.',
      ),
      DocsApiParam(
        name: 'onAcceptTop',
        type: 'ValueChanged<SortableData<T>>?',
        isRequired: false,
        doc: 'Called when data is dropped on the top edge.',
      ),
      DocsApiParam(
        name: 'onAcceptLeft',
        type: 'ValueChanged<SortableData<T>>?',
        isRequired: false,
        doc: 'Called when data is dropped on the left edge.',
      ),
      DocsApiParam(
        name: 'onAcceptRight',
        type: 'ValueChanged<SortableData<T>>?',
        isRequired: false,
        doc: 'Called when data is dropped on the right edge.',
      ),
      DocsApiParam(
        name: 'onAcceptBottom',
        type: 'ValueChanged<SortableData<T>>?',
        isRequired: false,
        doc: 'Called when data is dropped on the bottom edge.',
      ),
      DocsApiParam(
        name: 'ghost',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget rendered in the layer while dragging.',
      ),
      DocsApiParam(
        name: 'fallback',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown in place of the child while dragging.',
      ),
      DocsApiParam(
        name: 'candidateFallback',
        type: 'Widget?',
        isRequired: false,
        doc: 'Widget shown when this item is the current drop candidate.',
      ),
      DocsApiParam(
        name: 'onDragStart',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Called when a drag starts.',
      ),
      DocsApiParam(
        name: 'onDragEnd',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Called when a drag ends (after the accept callback).',
      ),
      DocsApiParam(
        name: 'onDragCancel',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Called when a drag is cancelled.',
      ),
      DocsApiParam(
        name: 'behavior',
        type: 'HitTestBehavior',
        isRequired: false,
        defaultValue: 'HitTestBehavior.deferToChild',
        doc: 'Hit-test behaviour of the drag gesture.',
      ),
      DocsApiParam(
        name: 'onDropFailed',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Called when a drop lands on no valid target.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'steps': DocsApiTable(
    componentId: 'steps',
    symbol: 'Steps',
    hasApiTable: true,
    parseClean: true,
    summary: 'A vertical step list with numbered indicators and connectors.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'children',
        type: 'List<Widget>',
        isRequired: true,
        doc: 'One widget per step, top to bottom.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'StepsTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'command': DocsApiTable(
    componentId: 'command',
    symbol: 'Command',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A command palette with a search field, async results and keyboard support.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'builder',
        type: 'CommandBuilder',
        isRequired: true,
        doc: 'Builds the results for the current query.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the search field takes focus when mounted.',
      ),
      DocsApiParam(
        name: 'debounceDuration',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'const Duration(milliseconds: 300)',
        doc:
            'Delay between typing and running [builder]; each query restarts it.',
      ),
      DocsApiParam(
        name: 'emptyBuilder',
        type: 'WidgetBuilder?',
        isRequired: false,
        doc: 'Shown when the finished result stream is empty.',
      ),
      DocsApiParam(
        name: 'errorBuilder',
        type: 'CommandErrorBuilder?',
        isRequired: false,
        doc:
            'Shown when the result stream errors; defaults to the empty state.',
      ),
      DocsApiParam(
        name: 'loadingBuilder',
        type: 'WidgetBuilder?',
        isRequired: false,
        doc: 'Shown while the debounce/result stream has not produced data.',
      ),
      DocsApiParam(
        name: 'searchPlaceholder',
        type: 'Widget?',
        isRequired: false,
        doc: 'Placeholder of the search field; defaults to the localized hint.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CommandTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override, merged over the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'context_menu': DocsApiTable(
    componentId: 'context_menu',
    symbol: 'ContextMenu',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Wraps [child] so a secondary-click (and a long-press on touch platforms) opens [items] as a menu at the pointer.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The widget that triggers the menu.',
      ),
      DocsApiParam(
        name: 'items',
        type: 'List<Widget>',
        isRequired: true,
        doc: 'The menu rows.',
      ),
      DocsApiParam(
        name: 'behavior',
        type: 'HitTestBehavior',
        isRequired: false,
        defaultValue: 'HitTestBehavior.translucent',
        doc: 'Hit-test behavior of the trigger area.',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.vertical',
        doc: 'Row layout of the menu.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the menu can open.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'MenuTheme',
        isRequired: false,
        defaultValue: 'const MenuTheme()',
        doc: 'Widget-leg row theme override, applied inside the popup.',
      ),
      DocsApiParam(
        name: 'popupTheme',
        type: 'MenuPopupTheme?',
        isRequired: false,
        doc: 'Widget-leg surface override, merged over the popup theme legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'dropdown_menu': DocsApiTable(
    componentId: 'dropdown_menu',
    symbol: 'DropdownMenu',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A menu surface for a dropdown: the menu\'s rows inside a [MenuPopup], dismissing the overlay it is shown in when a row closes the menu.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'children',
        type: 'List<Widget>',
        isRequired: true,
        doc: 'The menu rows.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'MenuPopupTheme?',
        isRequired: false,
        doc: 'Widget-leg surface override, merged over the popup theme legs.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc:
            'Whether the group takes focus on mount; true for opened overlays.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'menu': DocsApiTable(
    componentId: 'menu',
    symbol: 'MenuButton',
    hasApiTable: true,
    parseClean: true,
    summary:
        'An actionable menu row, optionally owning a submenu; hover focuses and opens it, press activates [onPressed] and (with [autoClose]) dismisses.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'child', type: 'Widget', isRequired: true),
      DocsApiParam(name: 'subMenu', type: 'List<Widget>?', isRequired: false),
      DocsApiParam(
        name: 'onPressed',
        type: 'MenuPressedCallback?',
        isRequired: false,
      ),
      DocsApiParam(name: 'trailing', type: 'Widget?', isRequired: false),
      DocsApiParam(name: 'leading', type: 'Widget?', isRequired: false),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'focusNode', type: 'FocusNode?', isRequired: false),
      DocsApiParam(
        name: 'autoClose',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'theme', type: 'MenuTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'menubar': DocsApiTable(
    componentId: 'menubar',
    symbol: 'Menubar',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Bar contract (shadcn menubar: `rounded-md border bg-background p-1`, radius md) resolved through widget > tree > app > defaults.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'children',
        type: 'List<Widget>',
        isRequired: true,
        doc:
            'Top-level menu triggers, usually [MenuButton]s with a `subMenu`.\n\nAny widget works: non-[MenuItem] content (labels, separators) renders\nwithout taking part in traversal, like a [MenuGroup].',
      ),
      DocsApiParam(
        name: 'border',
        type: 'bool?',
        isRequired: false,
        doc:
            'Whether the bar draws its border, background and padding; null resolves\n`MenubarTheme.border` (true).',
      ),
      DocsApiParam(
        name: 'popoverOffset',
        type: 'Offset?',
        isRequired: false,
        doc:
            'Submenu offset; null resolves `MenubarTheme.subMenuOffset`\n(`Offset(-4, 8)`), matching shadcn\'s submenu placement below the bar.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'MenubarTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'breadcrumb': DocsApiTable(
    componentId: 'breadcrumb',
    symbol: 'Breadcrumb',
    hasApiTable: true,
    parseClean: true,
    summary: 'A horizontal breadcrumb trail, scrollable when it overflows.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'children',
        type: 'List<Widget>',
        isRequired: true,
        doc: 'Crumbs, ordered from root to the current location.',
      ),
      DocsApiParam(
        name: 'separator',
        type: 'Widget?',
        isRequired: false,
        doc:
            'Separator override; null resolves [BreadcrumbTheme.separator] and then\n[arrowSeparator].',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc:
            'Padding around the strip; null resolves [BreadcrumbTheme.padding].',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'BreadcrumbTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'navigation_bar': DocsApiTable(
    componentId: 'navigation_bar',
    symbol: 'NavigationBar',
    hasApiTable: true,
    parseClean: true,
    summary: 'A navigation container: horizontal bar, compact rail or sidebar.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'children',
        type: 'List<NavigationBarItem>',
        isRequired: true,
        doc: 'The navigation items.',
      ),
      DocsApiParam(
        name: 'container',
        type: 'NavigationContainerType',
        isRequired: false,
        defaultValue: 'NavigationContainerType.bar',
      ),
      DocsApiParam(name: 'direction', type: 'Axis?', isRequired: false),
      DocsApiParam(
        name: 'alignment',
        type: 'MainAxisAlignment?',
        isRequired: false,
      ),
      DocsApiParam(name: 'spacing', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'labelType',
        type: 'NavigationLabelType?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'labelPosition',
        type: 'NavigationLabelPosition?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'labelSize',
        type: 'NavigationLabelSize?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'constraints',
        type: 'BoxConstraints?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'index',
        type: 'int?',
        isRequired: false,
        doc: 'Selected item index.',
      ),
      DocsApiParam(
        name: 'onSelected',
        type: 'ValueChanged<int>?',
        isRequired: false,
        doc: 'Called with the selected item\'s index.',
      ),
      DocsApiParam(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'expanded',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether labels follow the expanded state (`NavigationLabelType.expanded`).',
      ),
      DocsApiParam(
        name: 'header',
        type: 'List<Widget>',
        isRequired: false,
        defaultValue: 'const <Widget>[]',
      ),
      DocsApiParam(
        name: 'footer',
        type: 'List<Widget>',
        isRequired: false,
        defaultValue: 'const <Widget>[]',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'NavigationBarTheme?',
        isRequired: false,
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'navigation_menu': DocsApiTable(
    componentId: 'navigation_menu',
    symbol: 'NavigationMenu',
    hasApiTable: true,
    parseClean: true,
    summary: 'Horizontal bar of entries with dropdown content.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'children', type: 'List<Widget>', isRequired: true),
      DocsApiParam(name: 'surfaceOpacity', type: 'double?', isRequired: false),
      DocsApiParam(name: 'surfaceBlur', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'theme',
        type: 'NavigationMenuTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged over the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'pagination': DocsApiTable(
    componentId: 'pagination',
    symbol: 'Pagination',
    hasApiTable: true,
    parseClean: true,
    summary: 'A page selector.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'page',
        type: 'int',
        isRequired: true,
        doc:
            'The active page (1-based). Out-of-range values are clamped for display.',
      ),
      DocsApiParam(
        name: 'totalPages',
        type: 'int',
        isRequired: true,
        doc: 'Total number of pages.',
      ),
      DocsApiParam(
        name: 'onPageChanged',
        type: 'ValueChanged<int>',
        isRequired: true,
        doc: 'Called with the requested page number.',
      ),
      DocsApiParam(
        name: 'maxPages',
        type: 'int',
        isRequired: false,
        defaultValue: '3',
        doc:
            'How many page buttons the window shows when the total exceeds it.',
      ),
      DocsApiParam(
        name: 'showSkipToFirstPage',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether a button jumping to the first page is shown before the window.',
      ),
      DocsApiParam(
        name: 'showSkipToLastPage',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether a button jumping to the last page is shown after the window.',
      ),
      DocsApiParam(
        name: 'hidePreviousOnFirstPage',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Hides the previous button while on the first page.',
      ),
      DocsApiParam(
        name: 'hideNextOnLastPage',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Hides the next button while on the last page.',
      ),
      DocsApiParam(
        name: 'showLabel',
        type: 'bool?',
        isRequired: false,
        doc:
            'Whether previous/next show a text label; null resolves the theme.',
      ),
      DocsApiParam(
        name: 'gap',
        type: 'double?',
        isRequired: false,
        doc: 'Gap override; null resolves [PaginationTheme.gap].',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'PaginationTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'stepper': DocsApiTable(
    componentId: 'stepper',
    symbol: 'Stepper',
    hasApiTable: true,
    parseClean: true,
    summary: 'A sequence of steps with progress indication.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'steps',
        type: 'List<StepperStep>',
        isRequired: true,
        doc: 'The steps, in order.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'StepperController?',
        isRequired: false,
        doc: 'Uncontrolled mode: the controller owns the active step.',
      ),
      DocsApiParam(
        name: 'currentStep',
        type: 'int?',
        isRequired: false,
        doc: 'Controlled mode: index of the active step.',
      ),
      DocsApiParam(
        name: 'onStepChanged',
        type: 'ValueChanged<int>?',
        isRequired: false,
        doc:
            'Controlled mode: called with the next index when a step is activated.',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis?',
        isRequired: false,
        doc: 'Layout axis; falls back to the theme.',
      ),
      DocsApiParam(
        name: 'size',
        type: 'StepperSize?',
        isRequired: false,
        doc: 'Indicator size; falls back to the theme.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'StepperTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'tabs': DocsApiTable(
    componentId: 'tabs',
    symbol: 'Tabs',
    hasApiTable: true,
    parseClean: true,
    summary: 'A shadcn pill tab strip on a muted container.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'index', type: 'int', isRequired: true),
      DocsApiParam(name: 'children', type: 'List<TabItem>', isRequired: true),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<int>?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'expand',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(name: 'theme', type: 'TabsTheme?', isRequired: false),
      DocsApiParam(
        name: 'containerTheme',
        type: 'TabContainerTheme?',
        isRequired: false,
        doc:
            'Container layout defaults; resolved and forwarded to [TabContainer].',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'alert_dialog': DocsApiTable(
    componentId: 'alert_dialog',
    symbol: 'AlertDialog',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Builds the header row: optional icon, then the title/description column.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'title',
        type: 'Widget?',
        isRequired: false,
        doc: 'Headline of the dialog. Typically a `Text`.',
      ),
      DocsApiParam(
        name: 'description',
        type: 'Widget?',
        isRequired: false,
        doc: 'Supporting text below [title]. Typically a `Text`.',
      ),
      DocsApiParam(
        name: 'icon',
        type: 'Widget?',
        isRequired: false,
        doc:
            'Leading glyph of the header, usually an `Icon`. It is tinted with\n`AlertDialogTheme.iconColor` (`mutedForeground` by default).',
      ),
      DocsApiParam(
        name: 'actions',
        type: 'List<Widget>',
        isRequired: false,
        defaultValue: 'const <Widget>[]',
        doc:
            'Footer controls, usually buttons. They are laid out in a row aligned by\n`AlertDialogTheme.footerAlignment` (the end of the row by default) and\nseparated by `actionGap`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'AlertDialogTheme?',
        isRequired: false,
        doc:
            'Widget-leg override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'dialog': DocsApiTable(
    componentId: 'dialog',
    symbol: 'showShadcnDialog',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Pushes a shadcn modal dialog on a [Navigator] and returns its result.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'context', type: 'BuildContext', isRequired: true),
      DocsApiParam(name: 'builder', type: 'WidgetBuilder', isRequired: true),
      DocsApiParam(
        name: 'useRootNavigator',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'barrierDismissible',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'barrierColor',
        type: 'ThemedColor?',
        isRequired: false,
      ),
      DocsApiParam(name: 'barrierLabel', type: 'String?', isRequired: false),
      DocsApiParam(
        name: 'useSafeArea',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'routeSettings',
        type: 'RouteSettings?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'traversalEdgeBehavior',
        type: 'TraversalEdgeBehavior',
        isRequired: false,
        defaultValue: 'TraversalEdgeBehavior.closedLoop',
      ),
      DocsApiParam(
        name: 'alignment',
        type: 'AlignmentGeometry',
        isRequired: false,
        defaultValue: 'Alignment.center',
      ),
      DocsApiParam(
        name: 'fullScreen',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(name: 'theme', type: 'DialogTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'drawer': DocsApiTable(
    componentId: 'drawer',
    symbol: 'openDrawerOverlay',
    hasApiTable: true,
    parseClean: true,
    summary: 'Opens a drawer and returns a handle to it.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'context', type: 'BuildContext', isRequired: true),
      DocsApiParam(name: 'builder', type: 'WidgetBuilder', isRequired: true),
      DocsApiParam(
        name: 'position',
        type: 'OverlayPosition',
        isRequired: false,
        defaultValue: 'OverlayPosition.end',
      ),
      DocsApiParam(
        name: 'expands',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'draggable',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'barrierDismissible',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'useSafeArea',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'showDragHandle', type: 'bool?', isRequired: false),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadius?',
        isRequired: false,
      ),
      DocsApiParam(name: 'maxSize', type: 'double?', isRequired: false),
      DocsApiParam(name: 'barrierLabel', type: 'String?', isRequired: false),
      DocsApiParam(
        name: 'useRootNavigator',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'routeSettings',
        type: 'RouteSettings?',
        isRequired: false,
      ),
      DocsApiParam(name: 'theme', type: 'DrawerTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'gooey_toast': DocsApiTable(
    componentId: 'gooey_toast',
    symbol: 'GooeyToastLayer',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Hosts a [GooeyToastController] and renders its stack above [child].',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Content below the toasts.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'GooeyToastController?',
        isRequired: false,
        doc: 'Injected controller; one is owned when null.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'GooeyToastTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'hover_card': DocsApiTable(
    componentId: 'hover_card',
    symbol: 'HoverCard',
    hasApiTable: true,
    parseClean: true,
    summary: 'A rich preview card shown while the pointer rests on [child].',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The anchor the card points at.',
      ),
      DocsApiParam(
        name: 'hoverBuilder',
        type: 'WidgetBuilder',
        isRequired: true,
        doc: 'Builds the card content.',
      ),
      DocsApiParam(
        name: 'debounce',
        type: 'Duration?',
        isRequired: false,
        doc:
            'Hide delay after the pointer leaves; null resolves the theme default.',
      ),
      DocsApiParam(
        name: 'wait',
        type: 'Duration?',
        isRequired: false,
        doc:
            'Show delay after the pointer enters; null resolves the theme default.',
      ),
      DocsApiParam(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
        doc: 'Card placement; null resolves the theme default.',
      ),
      DocsApiParam(
        name: 'anchorAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
        doc: 'Anchor edge; null resolves the theme default.',
      ),
      DocsApiParam(
        name: 'popoverOffset',
        type: 'Offset?',
        isRequired: false,
        doc: 'Gap between anchor and card; null resolves the theme default.',
      ),
      DocsApiParam(
        name: 'behavior',
        type: 'HitTestBehavior?',
        isRequired: false,
        doc:
            'Hit-test behaviour of the anchor; null resolves the theme default.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'PopoverController?',
        isRequired: false,
        doc: 'External popover controller; owned internally when null.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'HoverCardTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'popup': DocsApiTable(
    componentId: 'popup',
    symbol: 'showShadcnPopup',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Shows [builder]\'s content on a [MenuPopup] surface anchored to [context].',
    params: <DocsApiParam>[
      DocsApiParam(name: 'context', type: 'BuildContext', isRequired: true),
      DocsApiParam(name: 'builder', type: 'WidgetBuilder', isRequired: true),
      DocsApiParam(
        name: 'alignment',
        type: 'AlignmentGeometry',
        isRequired: false,
        defaultValue: 'Alignment.topCenter',
      ),
      DocsApiParam(
        name: 'anchorAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'offset',
        type: 'Offset',
        isRequired: false,
        defaultValue: 'const Offset(0, 4)',
      ),
      DocsApiParam(
        name: 'widthConstraint',
        type: 'PopoverConstraint',
        isRequired: false,
        defaultValue: 'PopoverConstraint.flexible',
      ),
      DocsApiParam(
        name: 'heightConstraint',
        type: 'PopoverConstraint',
        isRequired: false,
        defaultValue: 'PopoverConstraint.flexible',
      ),
      DocsApiParam(
        name: 'modal',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'consumeOutsideTaps',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'theme', type: 'MenuPopupTheme?', isRequired: false),
      DocsApiParam(name: 'width', type: 'double?', isRequired: false),
      DocsApiParam(name: 'maxWidth', type: 'double?', isRequired: false),
      DocsApiParam(name: 'maxHeight', type: 'double?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'refresh_trigger': DocsApiTable(
    componentId: 'refresh_trigger',
    symbol: 'RefreshTrigger',
    hasApiTable: true,
    parseClean: true,
    summary: 'Pull-to-refresh wrapper; null [onRefresh] disables pulling.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'child', type: 'Widget', isRequired: true),
      DocsApiParam(name: 'minExtent', type: 'double?', isRequired: false),
      DocsApiParam(name: 'maxExtent', type: 'double?', isRequired: false),
      DocsApiParam(
        name: 'onRefresh',
        type: 'Future<void> Function()?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.vertical',
      ),
      DocsApiParam(
        name: 'reverse',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
      ),
      DocsApiParam(
        name: 'indicatorBuilder',
        type: 'RefreshIndicatorBuilder?',
        isRequired: false,
      ),
      DocsApiParam(name: 'curve', type: 'Curve?', isRequired: false),
      DocsApiParam(
        name: 'completeDuration',
        type: 'Duration?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'theme',
        type: 'RefreshTriggerTheme?',
        isRequired: false,
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'tooltip': DocsApiTable(
    componentId: 'tooltip',
    symbol: 'Tooltip',
    hasApiTable: true,
    parseClean: true,
    summary: 'A short label shown while the pointer rests on [child].',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The anchor the tooltip points at.',
      ),
      DocsApiParam(
        name: 'tooltip',
        type: 'WidgetBuilder',
        isRequired: true,
        doc:
            'Builds the tooltip content. The result is wrapped in a\n[TooltipContainer], so return the bare content (usually a `Text`).',
      ),
      DocsApiParam(
        name: 'alignment',
        type: 'AlignmentGeometry',
        isRequired: false,
        defaultValue: 'Alignment.topCenter',
        doc: 'Where the tooltip sits relative to itself.',
      ),
      DocsApiParam(
        name: 'anchorAlignment',
        type: 'AlignmentGeometry',
        isRequired: false,
        defaultValue: 'Alignment.bottomCenter',
        doc: 'Which edge of [child] the tooltip points at.',
      ),
      DocsApiParam(
        name: 'waitDuration',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'kTooltipWaitDuration',
        doc: 'Delay before the tooltip appears.',
      ),
      DocsApiParam(
        name: 'showDuration',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'kTooltipShowDuration',
        doc: 'Grace period after the pointer leaves.',
      ),
      DocsApiParam(
        name: 'minDuration',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'Duration.zero',
        doc: 'Minimum time the tooltip stays visible.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'TooltipTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override for the presented container.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'code_snippet': DocsApiTable(
    componentId: 'code_snippet',
    symbol: 'CodeSnippet',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Scrollable code block with optional top-right [actions] (copy, run).',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'code',
        type: 'Widget',
        isRequired: true,
        doc: 'Code content (usually a [Text]).',
      ),
      DocsApiParam(
        name: 'constraints',
        type: 'BoxConstraints?',
        isRequired: false,
        doc: 'Bounds of the snippet area.',
      ),
      DocsApiParam(
        name: 'actions',
        type: 'List<Widget>',
        isRequired: false,
        defaultValue: 'const <Widget>[]',
        doc: 'Action buttons in the top-right corner.',
      ),
      DocsApiParam(
        name: 'language',
        type: 'String?',
        isRequired: false,
        doc:
            'Language id or fence tag (`dart`, `js`, `py`, …) used for syntax\nhighlighting. When null, the language is auto-detected from the code\ntext (fence tag first, then conservative content signals); unknown\ncontent stays plain.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'CodeSnippetTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged over the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'image': DocsApiTable(
    componentId: 'image',
    symbol: 'ShadcnImage',
    hasApiTable: true,
    parseClean: true,
    summary: 'A themed image.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'image',
        type: 'ImageProvider<Object>',
        isRequired: true,
        doc: 'The bytes to decode.',
      ),
      DocsApiParam(
        name: 'width',
        type: 'double?',
        isRequired: false,
        doc: 'Box width; null derives it from [height]/[aspectRatio].',
      ),
      DocsApiParam(
        name: 'height',
        type: 'double?',
        isRequired: false,
        doc: 'Box height; null derives it from [width]/[aspectRatio].',
      ),
      DocsApiParam(
        name: 'aspectRatio',
        type: 'double?',
        isRequired: false,
        doc: 'Width / height of the box; shadcn renders a square image.',
      ),
      DocsApiParam(
        name: 'fit',
        type: 'BoxFit',
        isRequired: false,
        defaultValue: 'BoxFit.cover',
        doc: 'How the decoded image fills the box.',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc:
            'Corner radius override; null uses [ImageTheme.borderRadius] then\n`radiusLg`.',
      ),
      DocsApiParam(
        name: 'background',
        type: 'Color?',
        isRequired: false,
        doc: 'Fill shown behind the image and as the default placeholder.',
      ),
      DocsApiParam(
        name: 'placeholder',
        type: 'Widget?',
        isRequired: false,
        doc:
            'Widget shown while the bytes load; null paints the background only.',
      ),
      DocsApiParam(
        name: 'errorBuilder',
        type: 'ImageErrorBuilder?',
        isRequired: false,
        doc: 'Widget shown when decoding fails; null keeps the background.',
      ),
      DocsApiParam(
        name: 'semanticLabel',
        type: 'String?',
        isRequired: false,
        doc:
            'Accessible label; also marks the node as an image for screen readers.',
      ),
      DocsApiParam(
        name: 'duration',
        type: 'Duration?',
        isRequired: false,
        doc: 'Fade-in duration; null uses [ImageTheme.duration].',
      ),
      DocsApiParam(
        name: 'scale',
        type: 'double',
        isRequired: false,
        defaultValue: '1.0',
        doc: 'Logical-pixel scale of the decoded image.',
      ),
      DocsApiParam(
        name: 'alignment',
        type: 'AlignmentGeometry',
        isRequired: false,
        defaultValue: 'Alignment.center',
        doc: 'Alignment of the decoded image inside the box.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ImageTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'markdown': DocsApiTable(
    componentId: 'markdown',
    symbol: 'Markdown',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Text-only markdown renderer. Source is a string: read assets or files yourself and pass the content (the old `asset`/`file` ctors and their loading states are gone; the streaming extension only supports text anyway). Link taps only fire callbacks: open URLs in [onTapLink] with `url_launcher` (the old platform-channel opener cannot be widgets-only).',
    params: <DocsApiParam>[
      DocsApiParam(name: 'data', type: 'String', isRequired: true),
      DocsApiParam(
        name: 'selectable',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'style', type: 'TextStyle?', isRequired: false),
      DocsApiParam(
        name: 'onTapLink',
        type: 'MarkdownTapLinkCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onTapLinkDetails',
        type: 'MarkdownTapLinkDetailsCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onTapImage',
        type: 'MarkdownTapImageCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onTapHeading',
        type: 'MarkdownTapHeadingCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onTapElement',
        type: 'MarkdownTapElementCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'blockBuilder',
        type: 'MarkdownBlockBuilder?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'onDocumentReady',
        type: 'MarkdownDocumentReadyCallback?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'viewportStorageId',
        type: 'Object?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'shrinkWrap',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(
        name: 'htmlSanitizationStrategy',
        type: 'MarkdownHtmlSanitizationStrategy',
        isRequired: false,
        defaultValue: 'MarkdownHtmlSanitizationStrategy.stripDangerousHtml',
      ),
      DocsApiParam(
        name: 'imagePreviewBehavior',
        type: 'MarkdownImagePreviewBehavior',
        isRequired: false,
        defaultValue: 'MarkdownImagePreviewBehavior.dialog',
      ),
      DocsApiParam(
        name: 'imagePreviewBuilder',
        type: 'MarkdownImagePreviewBuilder?',
        isRequired: false,
      ),
      DocsApiParam(
        name: 'imageBuilder',
        type: 'MarkdownImageWidgetBuilder?',
        isRequired: false,
      ),
      DocsApiParam(name: 'theme', type: 'MarkdownTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'alpha': DocsApiTable(
    componentId: 'alpha',
    symbol: 'AlphaPainter',
    hasApiTable: true,
    parseClean: true,
    summary: 'A checkerboard painter used to visualize transparency.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'primary',
        type: 'Color',
        isRequired: false,
        defaultValue: 'checkboardPrimary',
        doc: 'Fill color of the even squares.',
      ),
      DocsApiParam(
        name: 'secondary',
        type: 'Color',
        isRequired: false,
        defaultValue: 'checkboardSecondary',
        doc: 'Fill color of the odd squares.',
      ),
      DocsApiParam(
        name: 'squareSize',
        type: 'double',
        isRequired: false,
        defaultValue: 'checkboardSize',
        doc: 'Edge length of one square.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'anchor': DocsApiTable(
    componentId: 'anchor',
    symbol: 'Anchor',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Describes an anchor an overlay (popover, menu, tooltip) positions itself against, optionally tracking it as it moves.',
    params: <DocsApiParam>[],
    members: <DocsApiMember>[
      DocsApiMember(
        name: 'anchorTransformRelativeTo',
        kind: 'function',
        returnType: 'Matrix4',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'anchorBox', type: 'RenderBox', isRequired: true),
          DocsApiParam(name: 'source', type: 'RenderObject', isRequired: true),
        ],
        doc:
            'The transform from [anchorBox]\'s local coordinates into [source]\'s. Returns the identity when [source]\'s transform is singular instead of throwing from `Matrix4.invert()`.',
      ),
    ],
  ),
  'app': DocsApiTable(
    componentId: 'app',
    symbol: 'ShadcnApp',
    hasApiTable: true,
    parseClean: true,
    summary: 'A shadcn-themed application shell.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'navigatorKey',
        type: 'GlobalKey<NavigatorState>?',
        isRequired: false,
        doc: 'See [WidgetsApp.navigatorKey].',
      ),
      DocsApiParam(
        name: 'home',
        type: 'Widget?',
        isRequired: false,
        doc: 'See [WidgetsApp.home].',
      ),
      DocsApiParam(
        name: 'routes',
        type: 'Map<String, WidgetBuilder>',
        isRequired: false,
        defaultValue: 'const <String, WidgetBuilder>{}',
        doc: 'See [WidgetsApp.routes].',
      ),
      DocsApiParam(
        name: 'initialRoute',
        type: 'String?',
        isRequired: false,
        doc: 'See [WidgetsApp.initialRoute].',
      ),
      DocsApiParam(
        name: 'onGenerateRoute',
        type: 'RouteFactory?',
        isRequired: false,
        doc: 'See [WidgetsApp.onGenerateRoute].',
      ),
      DocsApiParam(
        name: 'onGenerateInitialRoutes',
        type: 'InitialRouteListFactory?',
        isRequired: false,
        doc: 'See [WidgetsApp.onGenerateInitialRoutes].',
      ),
      DocsApiParam(
        name: 'onUnknownRoute',
        type: 'RouteFactory?',
        isRequired: false,
        doc: 'See [WidgetsApp.onUnknownRoute].',
      ),
      DocsApiParam(
        name: 'pageRouteBuilder',
        type: 'PageRouteFactory?',
        isRequired: false,
        doc: 'See [WidgetsApp.pageRouteBuilder].',
      ),
      DocsApiParam(
        name: 'navigatorObservers',
        type: 'List<NavigatorObserver>',
        isRequired: false,
        defaultValue: 'const <NavigatorObserver>[]',
        doc: 'See [WidgetsApp.navigatorObservers].',
      ),
      DocsApiParam(
        name: 'builder',
        type: 'TransitionBuilder?',
        isRequired: false,
        doc: 'See [WidgetsApp.builder].',
      ),
      DocsApiParam(
        name: 'title',
        type: 'String?',
        isRequired: false,
        doc: 'See [WidgetsApp.title].',
      ),
      DocsApiParam(
        name: 'color',
        type: 'Color?',
        isRequired: false,
        doc:
            'Overrides the operating-system switcher colour. Defaults to the theme\'s\n`primary` token.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ShadcnThemeData',
        isRequired: false,
        defaultValue: 'const ShadcnThemeData()',
        doc: 'The light (or only) theme.',
      ),
      DocsApiParam(
        name: 'darkTheme',
        type: 'ShadcnThemeData?',
        isRequired: false,
        doc: 'The dark theme; falls back to [theme] when null.',
      ),
      DocsApiParam(
        name: 'themeMode',
        type: 'ThemeMode',
        isRequired: false,
        defaultValue: 'ThemeMode.system',
        doc: 'Which theme [theme]/[darkTheme] to use.',
      ),
      DocsApiParam(
        name: 'componentThemes',
        type: 'List<ComponentThemeData>',
        isRequired: false,
        defaultValue: 'const <ComponentThemeData>[]',
        doc:
            'App-wide component-theme overrides (the generated `component_themes.dart`\nlist); provided through [ComponentThemes].',
      ),
      DocsApiParam(
        name: 'scaling',
        type: 'AdaptiveScaling?',
        isRequired: false,
        doc: 'Optional adaptive scaling applied on top of the resolved theme.',
      ),
      DocsApiParam(
        name: 'locale',
        type: 'Locale?',
        isRequired: false,
        doc: 'See [WidgetsApp.locale].',
      ),
      DocsApiParam(
        name: 'localizationsDelegates',
        type: 'Iterable<LocalizationsDelegate<dynamic>>?',
        isRequired: false,
        doc: 'Extra localization delegates, merged with the shadcn delegates.',
      ),
      DocsApiParam(
        name: 'localeListResolutionCallback',
        type: 'LocaleListResolutionCallback?',
        isRequired: false,
        doc: 'See [WidgetsApp.localeListResolutionCallback].',
      ),
      DocsApiParam(
        name: 'localeResolutionCallback',
        type: 'LocaleResolutionCallback?',
        isRequired: false,
        doc: 'See [WidgetsApp.localeResolutionCallback].',
      ),
      DocsApiParam(
        name: 'supportedLocales',
        type: 'Iterable<Locale>',
        isRequired: false,
        defaultValue: 'ShadcnLocalizations.supportedLocales',
        doc:
            'See [WidgetsApp.supportedLocales].\n\nDefaults to [ShadcnLocalizations.supportedLocales] — the locales the\nshadcn delegate can load. (The delegate does not declare `en`: English\nis the class fallback, not a translated table — see the README.)',
      ),
      DocsApiParam(
        name: 'showPerformanceOverlay',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'See [WidgetsApp.showPerformanceOverlay].',
      ),
      DocsApiParam(
        name: 'showSemanticsDebugger',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'See [WidgetsApp.showSemanticsDebugger].',
      ),
      DocsApiParam(
        name: 'debugShowCheckedModeBanner',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'See [WidgetsApp.debugShowCheckedModeBanner].',
      ),
      DocsApiParam(
        name: 'shortcuts',
        type: 'Map<ShortcutActivator, Intent>?',
        isRequired: false,
        doc:
            'App-wide keyboard shortcuts, merged over [WidgetsApp.defaultShortcuts].\n\n`WidgetsApp` *replaces* its defaults when a map is supplied: an app that\npasses a single shortcut would otherwise lose Tab traversal\n(`NextFocusIntent`), activation (`Enter`/`Space` → `ActivateIntent`) and\ndismissal (`Escape` → `DismissIntent`) app-wide. `ShadcnApp` therefore\nmerges, and caller entries win.',
      ),
      DocsApiParam(
        name: 'actions',
        type: 'Map<Type, Action<Intent>>?',
        isRequired: false,
        doc:
            'App-wide intent-to-action bindings, merged over\n[WidgetsApp.defaultActions] with the same "caller entries win" rule as\n[shortcuts].',
      ),
      DocsApiParam(
        name: 'restorationScopeId',
        type: 'String?',
        isRequired: false,
        doc: 'See [WidgetsApp.restorationScopeId].',
      ),
      DocsApiParam(
        name: 'popoverHandler',
        type: 'OverlayHandler',
        isRequired: false,
        defaultValue: 'OverlayHandler.popover',
        doc: 'Handler for popover overlays installed by [OverlayManagerLayer].',
      ),
      DocsApiParam(
        name: 'tooltipHandler',
        type: 'OverlayHandler',
        isRequired: false,
        defaultValue: 'OverlayHandler.popover',
        doc: 'Handler for tooltip overlays installed by [OverlayManagerLayer].',
      ),
      DocsApiParam(
        name: 'menuHandler',
        type: 'OverlayHandler',
        isRequired: false,
        defaultValue: 'OverlayHandler.popover',
        doc: 'Handler for menu overlays installed by [OverlayManagerLayer].',
      ),
      DocsApiParam(
        name: 'enableThemeAnimation',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Animates theme changes with [AnimatedShadcnTheme] when true.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'async': DocsApiTable(
    componentId: 'async',
    symbol: 'FutureOrBuilder',
    hasApiTable: true,
    parseClean: true,
    summary: 'Renders a [FutureOr] value through one builder.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'future',
        type: 'FutureOr<T>',
        isRequired: true,
        doc: 'The value to render: an already-available `T`, or a `Future<T>`.',
      ),
      DocsApiParam(
        name: 'builder',
        type: 'AsyncWidgetBuilder<T>',
        isRequired: true,
        doc:
            'Called with the current snapshot. Runs synchronously for a plain value\nand on every [Future] transition otherwise.',
      ),
      DocsApiParam(
        name: 'initialData',
        type: 'T?',
        isRequired: false,
        doc:
            'Value reported while a [Future] is still pending.\n\nOnly consulted on the asynchronous path; a synchronous value is always\ncomplete, so the snapshot carries [future] itself and never\n[initialData].',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'backdrop_transform': DocsApiTable(
    componentId: 'backdrop_transform',
    symbol: 'BackdropTransform',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Describes how the backdrop behind a sheet or drawer is transformed as it animates between closed (`t == 0`) and fully open (`t == 1`).',
    params: <DocsApiParam>[],
    members: <DocsApiMember>[],
  ),
  'color': DocsApiTable(
    componentId: 'color',
    symbol: 'ColorDerivative',
    hasApiTable: true,
    parseClean: true,
    summary:
        'An abstract base class representing a color that can be transformed between different color spaces.',
    params: <DocsApiParam>[],
    members: <DocsApiMember>[
      DocsApiMember(
        name: 'ColorDerivative.fromColor',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: true,
        params: <DocsApiParam>[
          DocsApiParam(name: 'color', type: 'Color', isRequired: true),
        ],
        doc:
            'Creates a [ColorDerivative] from a Flutter [Color] using HSV internally.',
      ),
      DocsApiMember(
        name: 'ColorDerivative.fromHex',
        kind: 'method',
        returnType: 'ColorDerivative?',
        isStatic: true,
        params: <DocsApiParam>[
          DocsApiParam(name: 'text', type: 'String', isRequired: true),
        ],
        doc:
            'Parses a hex string (`#RGB`, `#RRGGBB`, `#AARRGGBB`) into a [ColorDerivative], or null when [text] is not a valid hex colour.',
      ),
      DocsApiMember(
        name: 'ColorDerivative.fromHSV',
        kind: 'factory',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'color', type: 'HSVColor', isRequired: true),
        ],
        doc: 'Creates a [ColorDerivative] from an [HSVColor].',
      ),
      DocsApiMember(
        name: 'ColorDerivative.fromHSL',
        kind: 'factory',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'color', type: 'HSLColor', isRequired: true),
        ],
        doc: 'Creates a [ColorDerivative] from an [HSLColor].',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToColor',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'color', type: 'Color', isRequired: true),
        ],
        doc: 'Returns a copy of [color] expressed in this colour\'s space.',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToColorRed',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'red', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the red channel (0–255).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToColorGreen',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'green', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the green channel (0–255).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToColorBlue',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'blue', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the blue channel (0–255).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSV',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'color', type: 'HSVColor', isRequired: true),
        ],
        doc: 'Returns a copy of [color] expressed in this colour\'s space.',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSVHue',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'hue', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the HSV hue (0–360).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSVSaturation',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'saturation', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the HSV saturation (0–1).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSVValue',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'value', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the HSV value (0–1).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSVAlpha',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'alpha', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the alpha channel (0–1) in HSV space.',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSL',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'color', type: 'HSLColor', isRequired: true),
        ],
        doc: 'Returns a copy of [color] expressed in this colour\'s space.',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSLHue',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'hue', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the HSL hue (0–360).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSLSaturation',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'saturation', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the HSL saturation (0–1).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToHSLLightness',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'lightness', type: 'double', isRequired: true),
        ],
        doc: 'Replaces the HSL lightness (0–1).',
      ),
      DocsApiMember(
        name: 'ColorDerivative.changeToOpacity',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'alpha', type: 'double', isRequired: true),
        ],
        doc: 'Returns a copy with the opacity replaced by [alpha].',
      ),
      DocsApiMember(
        name: 'ColorDerivative.transform',
        kind: 'method',
        returnType: 'ColorDerivative',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'old', type: 'ColorDerivative', isRequired: true),
        ],
        doc: 'Re-expresses this colour using [other]\'s internal colour space.',
      ),
      DocsApiMember(
        name: 'ColorDerivative.toColor',
        kind: 'method',
        returnType: 'Color',
        isStatic: false,
        params: <DocsApiParam>[],
        doc: 'Converts this color derivative to a Flutter [Color].',
      ),
      DocsApiMember(
        name: 'ColorDerivative.toHSVColor',
        kind: 'method',
        returnType: 'HSVColor',
        isStatic: false,
        params: <DocsApiParam>[],
        doc: 'Converts this color derivative to an [HSVColor].',
      ),
      DocsApiMember(
        name: 'ColorDerivative.toHSLColor',
        kind: 'method',
        returnType: 'HSLColor',
        isStatic: false,
        params: <DocsApiParam>[],
        doc: 'Converts this color derivative to an [HSLColor].',
      ),
    ],
  ),
  'color_field': DocsApiTable(
    componentId: 'color_field',
    symbol: 'ColorField',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A gradient area that varies an HSV/HSL colour along configurable axes.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'color',
        type: 'Color',
        isRequired: true,
        doc: 'The colour the field is built from.',
      ),
      DocsApiParam(
        name: 'mode',
        type: 'ColorFieldMode',
        isRequired: false,
        defaultValue: 'ColorFieldMode.hsv',
        doc: 'Colour space used to paint the field.',
      ),
      DocsApiParam(
        name: 'hueAxis',
        type: 'ColorFieldAxis',
        isRequired: false,
        defaultValue: 'ColorFieldAxis.none',
        doc: 'Hue ramp axis (both modes).',
      ),
      DocsApiParam(
        name: 'saturationAxis',
        type: 'ColorFieldAxis',
        isRequired: false,
        defaultValue: 'ColorFieldAxis.none',
        doc: 'Saturation ramp axis (both modes).',
      ),
      DocsApiParam(
        name: 'valueAxis',
        type: 'ColorFieldAxis',
        isRequired: false,
        defaultValue: 'ColorFieldAxis.none',
        doc: 'Value ramp axis ([ColorFieldMode.hsv] only).',
      ),
      DocsApiParam(
        name: 'lightnessAxis',
        type: 'ColorFieldAxis',
        isRequired: false,
        defaultValue: 'ColorFieldAxis.none',
        doc: 'Lightness ramp axis ([ColorFieldMode.hsl] only).',
      ),
      DocsApiParam(
        name: 'alphaAxis',
        type: 'ColorFieldAxis',
        isRequired: false,
        defaultValue: 'ColorFieldAxis.none',
        doc: 'Alpha ramp axis (both modes).',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ColorFieldTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'color_input': DocsApiTable(
    componentId: 'color_input',
    symbol: 'ColorInput',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A compact colour field: a colour well and an editable hex text field.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'value',
        type: 'ColorDerivative',
        isRequired: true,
        doc: 'The current colour.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<ColorDerivative>?',
        isRequired: false,
        doc: 'Called with every committed colour.',
      ),
      DocsApiParam(
        name: 'onChanging',
        type: 'ValueChanged<ColorDerivative>?',
        isRequired: false,
        doc: 'Called while a picker drag is in flight (live preview).',
      ),
      DocsApiParam(
        name: 'showAlpha',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether the picker edits alpha; null resolves true.',
      ),
      DocsApiParam(
        name: 'initialMode',
        type: 'ColorPickerMode?',
        isRequired: false,
        doc: 'Channel mode the picker opens in; null resolves `rgb`.',
      ),
      DocsApiParam(
        name: 'enableEyeDropper',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether the picker offers screen sampling; null resolves true.',
      ),
      DocsApiParam(
        name: 'showHistory',
        type: 'bool?',
        isRequired: false,
        doc:
            'Whether the picker\'s history toggle is shown; null resolves true.',
      ),
      DocsApiParam(
        name: 'mode',
        type: 'PromptMode?',
        isRequired: false,
        doc:
            'Prompt presentation; null resolves popover at 768 px and wider, dialog\nbelow.',
      ),
      DocsApiParam(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
        doc:
            'Popover placement relative to the trigger; null resolves top-start.',
      ),
      DocsApiParam(
        name: 'popoverAnchorAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
        doc: 'Anchor edge in popover mode; null resolves bottom-start.',
      ),
      DocsApiParam(
        name: 'popoverPadding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc:
            'Padding inside the popover surface; null resolves the primitive\'s 16.',
      ),
      DocsApiParam(
        name: 'dialogTitle',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional heading above the picker in dialog mode.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc: 'Overrides the enabled state; null means `onChanged != null`.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ColorInputTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'drawer_container': DocsApiTable(
    componentId: 'drawer_container',
    symbol: 'DrawerContainer',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A container that takes only a [child] and reads the rest of its configuration from an ancestor [DrawerContainerData].',
    params: <DocsApiParam>[
      DocsApiParam(name: 'child', type: 'Widget', isRequired: true),
      DocsApiParam(
        name: 'startPadding',
        type: 'double',
        isRequired: false,
        defaultValue: '0',
      ),
      DocsApiParam(
        name: 'endPadding',
        type: 'double',
        isRequired: false,
        defaultValue: '0',
      ),
      DocsApiParam(name: 'size', type: 'AxisSize?', isRequired: false),
      DocsApiParam(
        name: 'alignment',
        type: 'double',
        isRequired: false,
        defaultValue: '0',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'error_system': DocsApiTable(
    componentId: 'error_system',
    symbol: 'ErrorState',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A full-page (or section) error surface built from `Card`, `Divider` and `Button`.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'error',
        type: 'AppError',
        isRequired: true,
        doc: 'The error to render.',
      ),
      DocsApiParam(
        name: 'icon',
        type: 'Widget?',
        isRequired: false,
        doc: 'Replaces the default icon.',
      ),
      DocsApiParam(
        name: 'maxWidth',
        type: 'double?',
        isRequired: false,
        doc: 'Maximum width of the card; null resolves 520.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ErrorSystemTheme?',
        isRequired: false,
        doc:
            'Widget-leg override, merged over the component/app/defaults legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'eye_dropper': DocsApiTable(
    componentId: 'eye_dropper',
    symbol: 'EyeDropperLayer',
    hasApiTable: true,
    parseClean: true,
    summary: 'Wraps a subtree and enables sampling colours from it.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The subtree that can be sampled.',
      ),
      DocsApiParam(
        name: 'previewAlignment',
        type: 'AlignmentGeometry?',
        isRequired: false,
        doc:
            'Pins the preview to this alignment; null makes it follow the pointer.',
      ),
      DocsApiParam(
        name: 'showPreview',
        type: 'bool?',
        isRequired: false,
        doc:
            'Whether the magnified preview is shown. Default: theme value (true).',
      ),
      DocsApiParam(
        name: 'previewSize',
        type: 'Size?',
        isRequired: false,
        doc: 'Preview size override. Default: theme value (100x100), scaled.',
      ),
      DocsApiParam(
        name: 'previewScale',
        type: 'double?',
        isRequired: false,
        doc: 'Magnification override. Default: theme value (8).',
      ),
      DocsApiParam(
        name: 'previewLabelBuilder',
        type: 'PreviewLabelBuilder?',
        isRequired: false,
        doc: 'Custom label under the preview; defaults to the hex value.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'EyeDropperTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'formatter': DocsApiTable(
    componentId: 'formatter',
    symbol: 'TextInputFormatters',
    hasApiTable: true,
    parseClean: true,
    summary: 'Factory methods for common text input formatters.',
    params: <DocsApiParam>[],
    members: <DocsApiMember>[
      DocsApiMember(
        name: 'TextInputFormatters.time',
        kind: 'method',
        returnType: 'TextInputFormatter',
        isStatic: true,
        params: <DocsApiParam>[
          DocsApiParam(name: 'length', type: 'int', isRequired: true),
        ],
        doc: 'Creates a time formatter padded left with zeros to [length].',
      ),
      DocsApiMember(
        name: 'TextInputFormatters.integerOnly',
        kind: 'method',
        returnType: 'TextInputFormatter',
        isStatic: true,
        params: <DocsApiParam>[
          DocsApiParam(name: 'min', type: 'int?', isRequired: false),
          DocsApiParam(name: 'max', type: 'int?', isRequired: false),
        ],
        doc: 'Creates an integer-only formatter with optional bounds.',
      ),
      DocsApiMember(
        name: 'TextInputFormatters.digitsOnly',
        kind: 'method',
        returnType: 'TextInputFormatter',
        isStatic: true,
        params: <DocsApiParam>[
          DocsApiParam(name: 'min', type: 'double?', isRequired: false),
          DocsApiParam(name: 'max', type: 'double?', isRequired: false),
          DocsApiParam(name: 'decimalDigits', type: 'int?', isRequired: false),
        ],
        doc:
            'Creates a decimal formatter with optional bounds and fixed places.',
      ),
      DocsApiMember(
        name: 'TextInputFormatters.mathExpression',
        kind: 'method',
        returnType: 'TextInputFormatter',
        isStatic: true,
        params: <DocsApiParam>[
          DocsApiParam(
            name: 'context',
            type: 'Map<String, dynamic>?',
            isRequired: false,
          ),
        ],
        doc: 'Creates a math-expression evaluator formatter.',
      ),
      DocsApiMember(
        name: 'TextInputFormatters.hex',
        kind: 'method',
        returnType: 'TextInputFormatter',
        isStatic: true,
        params: <DocsApiParam>[
          DocsApiParam(
            name: 'hashPrefix',
            type: 'bool',
            isRequired: false,
            defaultValue: 'false',
          ),
        ],
        doc: 'Creates a hex-only formatter.',
      ),
      DocsApiMember(
        name: 'TextInputFormatters.toUpperCase',
        kind: 'constant',
        returnType: 'TextInputFormatter',
        isStatic: true,
        params: <DocsApiParam>[],
        doc: 'Converts all input text to uppercase.',
      ),
      DocsApiMember(
        name: 'TextInputFormatters.toLowerCase',
        kind: 'constant',
        returnType: 'TextInputFormatter',
        isStatic: true,
        params: <DocsApiParam>[],
        doc: 'Converts all input text to lowercase.',
      ),
      DocsApiMember(
        name: 'constraintToNewText',
        kind: 'function',
        returnType: 'TextSelection',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(
            name: 'newValue',
            type: 'TextEditingValue',
            isRequired: true,
          ),
          DocsApiParam(name: 'newText', type: 'String', isRequired: true),
        ],
        doc: 'Constrains the text selection to fit within the new text length.',
      ),
    ],
  ),
  'group': DocsApiTable(
    componentId: 'group',
    symbol: 'Group',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A layout surface that places children at explicit offsets and sizes.',
    params: <DocsApiParam>[
      DocsApiParam(name: 'children', type: '', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'history': DocsApiTable(
    componentId: 'history',
    symbol: 'RecentColorsScope',
    hasApiTable: true,
    parseClean: true,
    summary: 'Provides a [ColorHistoryStorage] to descendants.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Content below the scope.',
      ),
      DocsApiParam(
        name: 'initialRecentColors',
        type: 'List<Color>',
        isRequired: false,
        defaultValue: 'const <Color>[]',
        doc: 'Seed colours.',
      ),
      DocsApiParam(
        name: 'maxRecentColors',
        type: 'int',
        isRequired: false,
        defaultValue: '50',
        doc: 'Maximum stored colours.',
      ),
      DocsApiParam(
        name: 'onRecentColorsChanged',
        type: 'ValueChanged<List<Color>>?',
        isRequired: false,
        doc: 'Called whenever the list changes.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'hsl': DocsApiTable(
    componentId: 'hsl',
    symbol: 'HSLColorSlider',
    hasApiTable: true,
    parseClean: true,
    summary: 'Interactive slider for one or two HSL channels.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'color',
        type: 'HSLColor',
        isRequired: true,
        doc: 'The current colour.',
      ),
      DocsApiParam(
        name: 'sliderType',
        type: 'HSLColorSliderType',
        isRequired: true,
        doc: 'Which channel(s) this slider drives.',
      ),
      DocsApiParam(
        name: 'onChanging',
        type: 'ValueChanged<HSLColor>?',
        isRequired: false,
        doc: 'Called while the value changes.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<HSLColor>?',
        isRequired: false,
        doc: 'Called when the interaction completes.',
      ),
      DocsApiParam(
        name: 'reverse',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Swaps the channel axes (and the cursor orientation).',
      ),
      DocsApiParam(
        name: 'radius',
        type: 'Radius',
        isRequired: false,
        defaultValue: 'const Radius.circular(0)',
        doc: 'Corner radius of the gradient.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsets',
        isRequired: false,
        defaultValue: 'EdgeInsets.zero',
        doc: 'Padding between gradient and cursor bar edge.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether gestures/keys are accepted.',
      ),
      DocsApiParam(
        name: 'style',
        type: 'HSLSliderStyle?',
        isRequired: false,
        doc: 'Widget-leg style override.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Focus node; one is created internally when null and [autofocus].',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Request focus on first build.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'hsv': DocsApiTable(
    componentId: 'hsv',
    symbol: 'HSVColorSlider',
    hasApiTable: true,
    parseClean: true,
    summary: 'Interactive slider for one or two HSV channels.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'color',
        type: 'HSVColor',
        isRequired: true,
        doc: 'The current colour.',
      ),
      DocsApiParam(
        name: 'sliderType',
        type: 'HSVColorSliderType',
        isRequired: true,
        doc: 'Which channel(s) this slider drives.',
      ),
      DocsApiParam(
        name: 'onChanging',
        type: 'ValueChanged<HSVColor>?',
        isRequired: false,
        doc: 'Called while the value changes.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<HSVColor>?',
        isRequired: false,
        doc: 'Called when the interaction completes.',
      ),
      DocsApiParam(
        name: 'reverse',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Swaps the channel axes (and the cursor orientation).',
      ),
      DocsApiParam(
        name: 'radius',
        type: 'Radius',
        isRequired: false,
        defaultValue: 'const Radius.circular(0)',
        doc: 'Corner radius of the gradient.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsets',
        isRequired: false,
        defaultValue: 'EdgeInsets.zero',
        doc: 'Padding between gradient and cursor bar edge.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether gestures/keys are accepted.',
      ),
      DocsApiParam(
        name: 'style',
        type: 'HSVSliderStyle?',
        isRequired: false,
        doc: 'Widget-leg style override.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Focus node; one is created internally when null and [autofocus].',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Request focus on first build.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'icon': DocsApiTable(
    componentId: 'icon',
    symbol: 'IconContainer',
    hasApiTable: true,
    parseClean: true,
    summary: 'A padded, filled square around an icon.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'icon',
        type: 'Widget',
        isRequired: true,
        doc: 'The icon to display.',
      ),
      DocsApiParam(
        name: 'backgroundColor',
        type: 'Color?',
        isRequired: false,
        doc: 'Container fill override.',
      ),
      DocsApiParam(
        name: 'iconColor',
        type: 'Color?',
        isRequired: false,
        doc: 'Icon colour override.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc: 'Inner padding override.',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc: 'Corner radius override.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'IconContainerTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'locale_utils': DocsApiTable(
    componentId: 'locale_utils',
    symbol: 'SizeUnitLocale',
    hasApiTable: true,
    parseClean: true,
    summary: 'Unit table and digit-grouping rules for byte-size formatting.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'base',
        type: 'int',
        isRequired: true,
        doc: 'Conversion factor between two neighbouring units.',
      ),
      DocsApiParam(
        name: 'units',
        type: 'List<String>',
        isRequired: true,
        doc: 'Unit labels from smallest ([units] first) to largest.',
      ),
      DocsApiParam(
        name: 'separator',
        type: 'String',
        isRequired: false,
        defaultValue: '\',\'',
        doc: 'Separator inserted between digit groups of the integer part.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'media_query': DocsApiTable(
    componentId: 'media_query',
    symbol: 'MediaQueryVisibility',
    hasApiTable: true,
    parseClean: true,
    summary: 'Width-driven child switching.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Shown while the viewport width is inside the range.',
      ),
      DocsApiParam(
        name: 'minWidth',
        type: 'double?',
        isRequired: false,
        doc: 'Narrowest viewport width (inclusive) that shows [child].',
      ),
      DocsApiParam(
        name: 'maxWidth',
        type: 'double?',
        isRequired: false,
        doc: 'Widest viewport width (inclusive) that shows [child].',
      ),
      DocsApiParam(
        name: 'alternateChild',
        type: 'Widget?',
        isRequired: false,
        doc:
            'Shown while the viewport width is outside the range; null collapses the\nbox instead.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'MediaQueryVisibilityTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'multiple_choice': DocsApiTable(
    componentId: 'multiple_choice',
    symbol: 'MultipleChoice',
    hasApiTable: true,
    parseClean: true,
    summary: 'A single-selection scope.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The widget tree containing the choice items.',
      ),
      DocsApiParam(
        name: 'value',
        type: 'T?',
        isRequired: false,
        doc: 'Current selection in controlled mode.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'MultipleChoiceController<T>?',
        isRequired: false,
        doc: 'Controller mode: the controller owns the selection.',
      ),
      DocsApiParam(
        name: 'onChanged',
        type: 'ValueChanged<T?>?',
        isRequired: false,
        doc: 'Called with the next selection in controlled mode.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool?',
        isRequired: false,
        doc:
            'Overrides the enabled state; null means "interactive when controlled or\ncontroller-driven".',
      ),
      DocsApiParam(
        name: 'allowUnselect',
        type: 'bool?',
        isRequired: false,
        doc:
            'Whether picking the current item again clears the selection; null falls\nback to the resolved theme (default `false`).',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'MultipleChoiceTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override, merged over the component/app/defaults.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'outlined_container': DocsApiTable(
    componentId: 'outlined_container',
    symbol: 'OutlinedContainer',
    hasApiTable: true,
    parseClean: true,
    summary: 'An animated, outlined surface.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'Content inside the container.',
      ),
      DocsApiParam(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        isRequired: false,
        doc: 'Surface fill override.',
      ),
      DocsApiParam(
        name: 'borderColor',
        type: 'ThemedColor?',
        isRequired: false,
        doc: 'Border colour override.',
      ),
      DocsApiParam(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        isRequired: false,
        doc: 'Corner radius override.',
      ),
      DocsApiParam(
        name: 'borderWidth',
        type: 'double?',
        isRequired: false,
        doc: 'Border width override.',
      ),
      DocsApiParam(
        name: 'borderStyle',
        type: 'BorderStyle?',
        isRequired: false,
        doc: 'Border style override.',
      ),
      DocsApiParam(
        name: 'boxShadow',
        type: 'List<BoxShadow>?',
        isRequired: false,
        doc: 'Elevation shadows override.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc: 'Inner padding override.',
      ),
      DocsApiParam(
        name: 'clipBehavior',
        type: 'Clip',
        isRequired: false,
        defaultValue: 'Clip.antiAlias',
        doc: 'How the child is clipped to the decoration.',
      ),
      DocsApiParam(
        name: 'surfaceOpacity',
        type: 'double?',
        isRequired: false,
        doc: 'Multiplies the fill alpha.',
      ),
      DocsApiParam(
        name: 'surfaceBlur',
        type: 'double?',
        isRequired: false,
        doc: 'Backdrop blur sigma; null or <= 0 draws no blur.',
      ),
      DocsApiParam(
        name: 'width',
        type: 'double?',
        isRequired: false,
        doc: 'Fixed width.',
      ),
      DocsApiParam(
        name: 'height',
        type: 'double?',
        isRequired: false,
        doc: 'Fixed height.',
      ),
      DocsApiParam(
        name: 'duration',
        type: 'Duration?',
        isRequired: false,
        doc: 'Animation duration for decoration changes; null snaps.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'OutlinedContainerTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the other resolver legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'overlay_configuration': DocsApiTable(
    componentId: 'overlay_configuration',
    symbol: 'OverlayConfiguration',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Describes what overlay to show and how, independent of the specific mechanism.',
    params: <DocsApiParam>[],
    members: <DocsApiMember>[
      DocsApiMember(
        name: 'showOverlay',
        kind: 'function',
        returnType: 'OverlayCompleter<T?>',
        isStatic: false,
        params: <DocsApiParam>[
          DocsApiParam(name: 'context', type: 'BuildContext', isRequired: true),
          DocsApiParam(
            name: 'configuration',
            type: 'OverlayConfiguration',
            isRequired: true,
          ),
          DocsApiParam(
            name: 'builder',
            type: 'WidgetBuilder',
            isRequired: true,
          ),
          DocsApiParam(
            name: 'adaptive',
            type: 'bool',
            isRequired: false,
            defaultValue: 'true',
          ),
        ],
        doc: 'Presents [configuration] with [builder] as its content.',
      ),
    ],
  ),
  'page_route': DocsApiTable(
    componentId: 'page_route',
    symbol: 'ShadcnPageRoute',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A route that displays a full-screen page with the shadcn transition.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'builder',
        type: 'WidgetBuilder',
        isRequired: true,
        doc: 'Builds the primary content of the route.',
      ),
      DocsApiParam(name: 'settings', type: '', isRequired: false),
      DocsApiParam(
        name: 'maintainState',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
      ),
      DocsApiParam(name: 'fullscreenDialog', type: '', isRequired: false),
      DocsApiParam(
        name: '_opaque',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'Whether routes behind this one stop being built once the transition\nfinishes.',
      ),
      DocsApiParam(
        name: 'transitionDuration',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'kShadcnPageTransitionDuration',
      ),
      DocsApiParam(name: 'barrierLabel', type: 'String?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
  'patch': DocsApiTable(
    componentId: 'patch',
    symbol: 'ClickDetector',
    hasApiTable: true,
    parseClean: true,
    summary: 'Counts consecutive taps inside a time and distance window.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The widget that receives the clicks.',
      ),
      DocsApiParam(
        name: 'onClick',
        type: 'ClickCallback<ClickDetails>?',
        isRequired: false,
        doc:
            'Called for every tap with the running click count. A null callback\ndisables the detector, so no gesture recogniser is built.',
      ),
      DocsApiParam(
        name: 'behavior',
        type: 'HitTestBehavior',
        isRequired: false,
        defaultValue: 'HitTestBehavior.deferToChild',
        doc: 'How to behave during hit testing.',
      ),
      DocsApiParam(
        name: 'threshold',
        type: 'Duration',
        isRequired: false,
        defaultValue: 'const Duration(milliseconds: 300)',
        doc: 'Longest gap between two clicks that still counts as consecutive.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'scrollable': DocsApiTable(
    componentId: 'scrollable',
    symbol: 'FadedScrollableViewport',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Fades the leading and trailing edges of [child] while it is scrolled.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The scrollable subtree the fade is drawn over.',
      ),
      DocsApiParam(
        name: 'fadeExtent',
        type: 'double?',
        isRequired: false,
        doc: 'Scroll distance over which the fade reaches full strength.',
      ),
      DocsApiParam(
        name: 'fadeSize',
        type: 'double?',
        isRequired: false,
        doc: 'Length of the fade gradient.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ScrollableTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the other resolver legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'scrollable_client': DocsApiTable(
    componentId: 'scrollable_client',
    symbol: 'ScrollableClient',
    hasApiTable: true,
    parseClean: true,
    summary: 'A scrollable surface that scrolls on both axes.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'builder',
        type: 'ScrollableBuilder',
        isRequired: true,
        doc: 'Builds the content for the current offset and viewport size.',
      ),
      DocsApiParam(
        name: 'primary',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether this is the primary scrollable of the [mainAxis].',
      ),
      DocsApiParam(
        name: 'mainAxis',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.vertical',
        doc:
            'Axis that inherits the primary controller and the keyboard dismissal.',
      ),
      DocsApiParam(
        name: 'verticalDetails',
        type: 'ScrollableDetails',
        isRequired: false,
        defaultValue: 'const ScrollableDetails.vertical()',
        doc: 'Controller, physics and axis direction of the vertical axis.',
      ),
      DocsApiParam(
        name: 'horizontalDetails',
        type: 'ScrollableDetails',
        isRequired: false,
        defaultValue: 'const ScrollableDetails.horizontal()',
        doc: 'Controller, physics and axis direction of the horizontal axis.',
      ),
      DocsApiParam(
        name: 'child',
        type: 'Widget?',
        isRequired: false,
        doc: 'Optional child handed through to [builder].',
      ),
      DocsApiParam(
        name: 'diagonalDragBehavior',
        type: 'DiagonalDragBehavior?',
        isRequired: false,
        doc: 'How diagonal drags pick an axis.',
      ),
      DocsApiParam(
        name: 'dragStartBehavior',
        type: 'DragStartBehavior?',
        isRequired: false,
        doc: 'When drag gestures start.',
      ),
      DocsApiParam(
        name: 'keyboardDismissBehavior',
        type: 'ScrollViewKeyboardDismissBehavior?',
        isRequired: false,
        doc: 'Keyboard dismissal on drag.',
      ),
      DocsApiParam(
        name: 'clipBehavior',
        type: 'Clip?',
        isRequired: false,
        doc: 'Viewport clipping.',
      ),
      DocsApiParam(
        name: 'hitTestBehavior',
        type: 'HitTestBehavior?',
        isRequired: false,
        doc: 'Hit-test behaviour of the scrollable.',
      ),
      DocsApiParam(
        name: 'overscroll',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether offsets may move past the content edges.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'ScrollableClientTheme?',
        isRequired: false,
        doc:
            'Widget-leg style override, merged on top of the other resolver legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'scrollview': DocsApiTable(
    componentId: 'scrollview',
    symbol: 'ScrollViewInterceptor',
    hasApiTable: true,
    parseClean: true,
    summary: 'Wraps [child] with middle-button autoscroll.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The subtree that receives the synthetic scroll events.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc:
            'When false the child renders untouched and no pointer is intercepted.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'selectable': DocsApiTable(
    componentId: 'selectable',
    symbol: 'SelectableText',
    hasApiTable: true,
    parseClean: true,
    summary: 'Read-only text that users can select, copy and long-press.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'data',
        type: 'String?',
        isRequired: true,
        doc:
            'Plain text; null when the [SelectableText.rich] constructor is used.',
      ),
      DocsApiParam(
        name: 'focusNode',
        type: 'FocusNode?',
        isRequired: false,
        doc: 'Focus node; one is created and disposed internally when null.',
      ),
      DocsApiParam(
        name: 'style',
        type: 'TextStyle?',
        isRequired: false,
        doc: 'Style override; merged over the theme and default text style.',
      ),
      DocsApiParam(
        name: 'strutStyle',
        type: 'StrutStyle?',
        isRequired: false,
        doc: 'Strut style override.',
      ),
      DocsApiParam(
        name: 'textAlign',
        type: 'TextAlign?',
        isRequired: false,
        doc: 'Horizontal text alignment.',
      ),
      DocsApiParam(
        name: 'textDirection',
        type: 'TextDirection?',
        isRequired: false,
        doc: 'Text direction override.',
      ),
      DocsApiParam(
        name: 'textScaler',
        type: 'TextScaler?',
        isRequired: false,
        doc: 'Text scaling override.',
      ),
      DocsApiParam(
        name: 'showCursor',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether to paint a blinking caret when focused.',
      ),
      DocsApiParam(
        name: 'autofocus',
        type: 'bool',
        isRequired: false,
        defaultValue: 'false',
        doc: 'Whether to focus when first built.',
      ),
      DocsApiParam(
        name: 'minLines',
        type: 'int?',
        isRequired: false,
        doc: 'Minimum number of lines.',
      ),
      DocsApiParam(
        name: 'maxLines',
        type: 'int?',
        isRequired: false,
        doc: 'Maximum number of lines before scrolling.',
      ),
      DocsApiParam(
        name: 'cursorWidth',
        type: 'double?',
        isRequired: false,
        doc: 'Caret width override.',
      ),
      DocsApiParam(
        name: 'cursorHeight',
        type: 'double?',
        isRequired: false,
        doc: 'Caret height override.',
      ),
      DocsApiParam(
        name: 'cursorRadius',
        type: 'Radius?',
        isRequired: false,
        doc: 'Caret corner radius override.',
      ),
      DocsApiParam(
        name: 'cursorColor',
        type: 'Color?',
        isRequired: false,
        doc: 'Caret colour override.',
      ),
      DocsApiParam(
        name: 'selectionHeightStyle',
        type: 'BoxHeightStyle?',
        isRequired: false,
        doc: 'Selection box height style override.',
      ),
      DocsApiParam(
        name: 'selectionWidthStyle',
        type: 'BoxWidthStyle?',
        isRequired: false,
        doc: 'Selection box width style override.',
      ),
      DocsApiParam(
        name: 'enableInteractiveSelection',
        type: 'bool?',
        isRequired: false,
        doc: 'Whether drag/double-tap/long-press selection is enabled.',
      ),
      DocsApiParam(
        name: 'selectionControls',
        type: 'TextSelectionControls?',
        isRequired: false,
        doc:
            'Selection controls override; defaults to `ShadcnSelectionControls`.',
      ),
      DocsApiParam(
        name: 'contextMenuBuilder',
        type: 'EditableTextContextMenuBuilder?',
        isRequired: false,
        doc: 'Context menu builder override; defaults to the shadcn toolbar.',
      ),
      DocsApiParam(
        name: 'onTap',
        type: 'VoidCallback?',
        isRequired: false,
        doc: 'Called when the text is tapped.',
      ),
      DocsApiParam(
        name: 'onSelectionChanged',
        type: 'SelectionChangedCallback?',
        isRequired: false,
        doc: 'Called when the selection changes.',
      ),
      DocsApiParam(
        name: 'semanticsLabel',
        type: 'String?',
        isRequired: false,
        doc: 'Semantic label; replaces the text semantics when set.',
      ),
      DocsApiParam(
        name: 'textHeightBehavior',
        type: 'TextHeightBehavior?',
        isRequired: false,
        doc: 'Text height behavior override.',
      ),
      DocsApiParam(
        name: 'textWidthBasis',
        type: 'TextWidthBasis?',
        isRequired: false,
        doc: 'Text width basis override.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SelectableTextTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'spell_check_suggestions_toolbar': DocsApiTable(
    componentId: 'spell_check_suggestions_toolbar',
    symbol: 'SpellCheckSuggestionsToolbar',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A shadcn styled toolbar offering replacement suggestions for the misspelled word under the cursor.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'anchors',
        type: 'TextSelectionToolbarAnchors',
        isRequired: true,
        doc: 'Where the toolbar is anchored relative to the text field.',
      ),
      DocsApiParam(
        name: 'buttonItems',
        type: 'List<ContextMenuButtonItem>',
        isRequired: true,
        doc: 'The replacement suggestions to display, at most three.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'stage_container': DocsApiTable(
    componentId: 'stage_container',
    symbol: 'StageContainer',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A responsive container that constrains content to breakpoint widths.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'builder',
        type: 'StageContainerBuilder',
        isRequired: true,
        doc: 'Builds the content; receives the resolved outer padding.',
      ),
      DocsApiParam(
        name: 'breakpoint',
        type: 'StageBreakpoint?',
        isRequired: false,
        doc:
            'Width strategy; null resolves the theme, then the default breakpoints.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc: 'Base padding; null resolves the theme, then the density default.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'StageContainerTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'swiper': DocsApiTable(
    componentId: 'swiper',
    symbol: 'Swiper',
    hasApiTable: true,
    parseClean: true,
    summary:
        'Wraps [child] and reveals a [SwiperVariant.drawer] or [SwiperVariant.sheet] panel when the user swipes towards the panel\'s edge. The panel is painted in-tree so the gesture can scrub it. Provide a non-swipe trigger for keyboard and assistive-technology users.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'position',
        type: 'OverlayPosition',
        isRequired: true,
        doc:
            'Edge the panel slides in from; `start`/`end` follow the text direction.',
      ),
      DocsApiParam(
        name: 'builder',
        type: 'WidgetBuilder',
        isRequired: true,
        doc: 'Builds the panel content.',
      ),
      DocsApiParam(
        name: 'child',
        type: 'Widget',
        isRequired: true,
        doc: 'The widget that responds to the swipe gesture.',
      ),
      DocsApiParam(
        name: 'variant',
        type: 'SwiperVariant',
        isRequired: false,
        defaultValue: 'SwiperVariant.drawer',
        doc: 'Which panel to reveal.',
      ),
      DocsApiParam(
        name: 'enabled',
        type: 'bool',
        isRequired: false,
        defaultValue: 'true',
        doc: 'Whether the swipe gesture is active.',
      ),
      DocsApiParam(
        name: 'controller',
        type: 'SwiperController?',
        isRequired: false,
        doc: 'Optional programmatic control; the swiper never disposes it.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SwiperTheme?',
        isRequired: false,
        doc:
            'Widget-leg theme override; other legs resolve from the tree and the app.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'switcher': DocsApiTable(
    componentId: 'switcher',
    symbol: 'Switcher',
    hasApiTable: true,
    parseClean: true,
    summary: 'A swipeable container that transitions between child widgets.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'direction',
        type: 'AxisDirection',
        isRequired: true,
        doc:
            'Axis the transition runs along; `right` means "the next child enters from\nthe right".',
      ),
      DocsApiParam(
        name: 'children',
        type: 'List<Widget>',
        isRequired: true,
        doc:
            'The pages to switch between; never empty.\n\nThe **length** must not change after the first build: the position lives\nin an [AnimationController] whose range is fixed when it is created.\nChanging it asserts in debug; build a new [KeyedSubtree] (or give the\n[Switcher] a new `Key`) to swap the page list.',
      ),
      DocsApiParam(
        name: 'index',
        type: 'int',
        isRequired: false,
        defaultValue: '0',
        doc:
            'Index of the active child; values outside `0..children.length - 1` are\nclamped.',
      ),
      DocsApiParam(
        name: 'onIndexChanged',
        type: 'ValueChanged<int>?',
        isRequired: false,
        doc: 'Called when a drag snaps to an index other than the current one.',
      ),
      DocsApiParam(
        name: 'duration',
        type: 'Duration?',
        isRequired: false,
        doc: 'Snap-back duration; null uses [SwitcherTheme.duration].',
      ),
      DocsApiParam(
        name: 'curve',
        type: 'Curve?',
        isRequired: false,
        doc: 'Snap-back curve; null uses [SwitcherTheme.curve].',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'SwitcherTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'timeline_animation': DocsApiTable(
    componentId: 'timeline_animation',
    symbol: 'TimelineAnimation',
    hasApiTable: true,
    parseClean: true,
    summary: 'A keyframe timeline bound to a total duration.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'keyframes',
        type: 'List<Keyframe<T>>',
        isRequired: true,
        doc: 'The segments, in order.',
      ),
      DocsApiParam(
        name: 'lerp',
        type: 'PropertyLerp<T>?',
        isRequired: false,
        doc: 'Interpolation used by absolute and relative segments.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'triple_dots': DocsApiTable(
    componentId: 'triple_dots',
    symbol: 'TripleDots',
    hasApiTable: true,
    parseClean: true,
    summary: 'A row or column of evenly spaced dots.',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'count',
        type: 'int',
        isRequired: false,
        defaultValue: '3',
        doc: 'Number of dots.',
      ),
      DocsApiParam(
        name: 'direction',
        type: 'Axis',
        isRequired: false,
        defaultValue: 'Axis.horizontal',
        doc: 'Layout direction of the dots.',
      ),
      DocsApiParam(
        name: 'size',
        type: 'double?',
        isRequired: false,
        doc: 'Dot diameter override.',
      ),
      DocsApiParam(
        name: 'spacing',
        type: 'double?',
        isRequired: false,
        doc: 'Gap between dots override.',
      ),
      DocsApiParam(
        name: 'color',
        type: 'Color?',
        isRequired: false,
        doc: 'Dot colour override.',
      ),
      DocsApiParam(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        isRequired: false,
        doc: 'Padding around the whole run.',
      ),
      DocsApiParam(
        name: 'theme',
        type: 'TripleDotsTheme?',
        isRequired: false,
        doc: 'Widget-leg theme override, merged on top of the other legs.',
      ),
    ],
    members: <DocsApiMember>[],
  ),
  'window': DocsApiTable(
    componentId: 'window',
    symbol: 'Window',
    hasApiTable: true,
    parseClean: true,
    summary:
        'A draggable, resizable window frame driven by a [WindowController].',
    params: <DocsApiParam>[
      DocsApiParam(
        name: 'controller',
        type: 'WindowController',
        isRequired: true,
        doc: 'The window\'s state controller.',
      ),
      DocsApiParam(name: 'title', type: 'Widget?', isRequired: false),
      DocsApiParam(
        name: 'actions',
        type: 'Widget?',
        isRequired: false,
        defaultValue: 'const WindowActions()',
        doc: 'Title bar action area; defaults to [WindowActions].',
      ),
      DocsApiParam(
        name: 'content',
        type: 'Widget?',
        isRequired: false,
        doc: 'Window body.',
      ),
      DocsApiParam(name: 'theme', type: 'WindowTheme?', isRequired: false),
    ],
    members: <DocsApiMember>[],
  ),
};

/// Theme tables keyed by component id (all components present).
const Map<String, DocsThemeTable> kThemeTables = <String, DocsThemeTable>{
  'border_loading': DocsThemeTable(
    componentId: 'border_loading',
    themeClass: 'BorderLoadingTheme',
    themeDefaults: 'borderLoadingDefaults',
    userFile: 'border_loading_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        description: 'fill behind the child, default none',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'default radius 12',
      ),
      DocsThemeField(
        name: 'curve',
        type: 'Curve?',
        description: 'easing of normalized progress, default linear',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'cycle of the looping modes, default 1200ms',
      ),
      DocsThemeField(
        name: 'mode',
        type: 'BorderLoadingMode?',
        description: 'sweepGradient | tracer | progress | staticBorder',
      ),
      DocsThemeField(
        name: 'opacity',
        type: 'double?',
        description: 'stroke opacity, default 1',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'default EdgeInsets.all(strokeWidth)',
      ),
      DocsThemeField(
        name: 'strokeWidth',
        type: 'double?',
        description: 'default 2',
      ),
    ],
  ),
  'dot_indicator': DocsThemeTable(
    componentId: 'dot_indicator',
    themeClass: 'DotIndicatorTheme',
    themeDefaults: 'dotIndicatorDefaults',
    userFile: 'dot_indicator_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'active',
        type: 'DotStyle?',
        description: 'the dot at the active index',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'morph duration; null = 150ms',
      ),
      DocsThemeField(
        name: 'inactive',
        type: 'DotStyle?',
        description: 'every other dot',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'padding around the run; null = density base gap',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between dots; null = 8 * scaling',
      ),
    ],
  ),
  'text_animate': DocsThemeTable(
    componentId: 'text_animate',
    themeClass: 'TextAnimateTheme',
    themeDefaults: 'textAnimateDefaults',
    userFile: 'text_animate_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'cursor',
        type: 'TextAnimateCursor?',
        description: 'streaming cursor, hidden',
      ),
      DocsThemeField(
        name: 'effect',
        type: 'TextAnimateEffect?',
        description: 'per-unit animation, none',
      ),
      DocsThemeField(
        name: 'style',
        type: 'TextStyle?',
        description: 'base style, merged over the ambient default',
      ),
      DocsThemeField(
        name: 'typewriter',
        type: 'TextAnimateTypewriter?',
        description: 'reveal pacing, 48 units/s',
      ),
    ],
  ),
  'button': DocsThemeTable(
    componentId: 'button',
    themeClass: 'ButtonTheme',
    themeDefaults: 'buttonDefaults',
    userFile: 'button_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state fill',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'null draws no border',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'used when borderColor resolves',
      ),
      DocsThemeField(
        name: 'decoration',
        type: 'StateValue<TextDecoration>?',
        description: 'link underline',
      ),
      DocsThemeField(
        name: 'destructive',
        type: 'ButtonVariantStyle?',
        description: 'danger row',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state label/icon colour',
      ),
      DocsThemeField(
        name: 'ghost',
        type: 'ButtonVariantStyle?',
        description: 'hover-fill-only row',
      ),
      DocsThemeField(
        name: 'link',
        type: 'ButtonVariantStyle?',
        description: 'underlined-on-hover row',
      ),
      DocsThemeField(
        name: 'outline',
        type: 'ButtonVariantStyle?',
        description: '1px input border row',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = size table, density-scaled',
      ),
      DocsThemeField(
        name: 'primary',
        type: 'ButtonVariantStyle?',
        description: 'filled high-emphasis row',
      ),
      DocsThemeField(
        name: 'secondary',
        type: 'ButtonVariantStyle?',
        description: 'filled lower-emphasis row',
      ),
      DocsThemeField(
        name: 'text',
        type: 'ButtonVariantStyle?',
        description: 'muted label row',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'null = size table',
      ),
    ],
  ),
  'toggle': DocsThemeTable(
    componentId: 'toggle',
    themeClass: 'ToggleTheme',
    themeDefaults: 'toggleDefaults',
    userFile: 'toggle_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state fill',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'null draws no border',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'used when borderColor resolves',
      ),
      DocsThemeField(
        name: 'decoration',
        type: 'StateValue<TextDecoration>?',
        description: 'optional underline',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state label/icon colour',
      ),
      DocsThemeField(
        name: 'off',
        type: 'ToggleStyle?',
        description: 'ghost row (default)',
      ),
      DocsThemeField(
        name: 'on',
        type: 'ToggleStyle?',
        description: 'primary row (default)',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'defaults to px-2 (h8), zero vertical',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'defaults to 14 / w500',
      ),
    ],
  ),
  'color_picker': DocsThemeTable(
    componentId: 'color_picker',
    themeClass: 'ColorPickerTheme',
    themeDefaults: 'colorPickerDefaults',
    userFile: 'color_picker_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'controlSpacing',
        type: 'double?',
        description: 'gap between sliders/fields/buttons, 8 by default',
      ),
      DocsThemeField(
        name: 'enableEyeDropper',
        type: 'bool?',
        description: 'show the eye-dropper button, true by default',
      ),
      DocsThemeField(
        name: 'orientation',
        type: 'Axis?',
        description: 'vertical (pad above fields) by default',
      ),
      DocsThemeField(
        name: 'sliderSize',
        type: 'double?',
        description: 'hue/alpha bar thickness, 24 by default',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between major sections, 12 by default',
      ),
    ],
  ),
  'avatar': DocsThemeTable(
    componentId: 'avatar',
    themeClass: 'AvatarTheme',
    themeDefaults: 'avatarDefaults',
    userFile: 'avatar_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        description: 'muted token',
      ),
      DocsThemeField(
        name: 'badgeAlignment',
        type: 'AlignmentGeometry?',
        description: 'bottom end',
      ),
      DocsThemeField(
        name: 'badgeBorderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = full circle',
      ),
      DocsThemeField(
        name: 'badgeColor',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'badgeForeground',
        type: 'ThemedColor?',
        description: 'primaryForeground token',
      ),
      DocsThemeField(
        name: 'badgeGap',
        type: 'double?',
        description: 'inset of the badge, 0',
      ),
      DocsThemeField(
        name: 'badgeSize',
        type: 'double?',
        description: 'null = 12 * scaling',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = full circle',
      ),
      DocsThemeField(
        name: 'foregroundColor',
        type: 'ThemedColor?',
        description: 'foreground token',
      ),
      DocsThemeField(
        name: 'size',
        type: 'double?',
        description: 'tile diameter; null = 40 * scaling',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'w600, colour from foregroundColor',
      ),
    ],
  ),
  'badge': DocsThemeTable(
    componentId: 'badge',
    themeClass: 'BadgeTheme',
    themeDefaults: 'badgeDefaults',
    userFile: 'badge_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state fill',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'null draws no border',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'used when borderColor resolves',
      ),
      DocsThemeField(
        name: 'destructive',
        type: 'BadgeStyle?',
        description: 'danger row',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state label/icon colour',
      ),
      DocsThemeField(
        name: 'iconSize',
        type: 'double?',
        description: '12 logical pixels',
      ),
      DocsThemeField(
        name: 'outline',
        type: 'BadgeStyle?',
        description: '1px border row',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: '8 x 2',
      ),
      DocsThemeField(
        name: 'primary',
        type: 'BadgeStyle?',
        description: 'filled high-emphasis row',
      ),
      DocsThemeField(
        name: 'secondary',
        type: 'BadgeStyle?',
        description: 'filled lower-emphasis row',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'shared by every variant, 12px',
      ),
    ],
  ),
  'carousel': DocsThemeTable(
    componentId: 'carousel',
    themeClass: 'CarouselTheme',
    themeDefaults: 'carouselDefaults',
    userFile: 'carousel_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'alignment',
        type: 'CarouselAlignment?',
        description: 'where the page sits; null = center',
      ),
      DocsThemeField(
        name: 'autoplayInterval',
        type: 'Duration?',
        description: 'hold time per page; null disables autoplay',
      ),
      DocsThemeField(
        name: 'curve',
        type: 'Curve?',
        description: 'page-change curve; null = Curves.easeInOut',
      ),
      DocsThemeField(
        name: 'direction',
        type: 'Axis?',
        description: 'scroll axis; null = horizontal',
      ),
      DocsThemeField(
        name: 'draggable',
        type: 'bool?',
        description: 'null = true',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'gap between pages; null = 0',
      ),
      DocsThemeField(
        name: 'itemExtent',
        type: 'double?',
        description: 'fixed page extent; wins over viewportFraction',
      ),
      DocsThemeField(
        name: 'pauseOnHover',
        type: 'bool?',
        description: 'null = true',
      ),
      DocsThemeField(
        name: 'speed',
        type: 'Duration?',
        description: 'page-change duration; null = kDefaultDuration',
      ),
      DocsThemeField(
        name: 'transition',
        type: 'CarouselTransition?',
        description: 'sliding or fading; null = sliding',
      ),
      DocsThemeField(
        name: 'viewportFraction',
        type: 'double?',
        description: 'viewport share per page; null = 1',
      ),
      DocsThemeField(name: 'wrap', type: 'bool?', description: 'null = true'),
    ],
  ),
  'chat': DocsThemeTable(
    componentId: 'chat',
    themeClass: 'ChatTheme',
    themeDefaults: 'chatDefaults',
    userFile: 'chat_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'alignment',
        type: 'AlignmentGeometry?',
        description: 'AlignmentDirectional.centerEnd',
      ),
      DocsThemeField(
        name: 'avatarAlignment',
        type: 'AlignmentGeometry?',
        description: 'AlignmentDirectional.topEnd',
      ),
      DocsThemeField(
        name: 'avatarSpacing',
        type: 'double?',
        description: 'gap to the avatar, 8',
      ),
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'null draws no border',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient radiusLg',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: '1 when a border is drawn',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'ThemedColor?',
        description: 'primaryForeground token',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: '12 horizontal / 8 vertical',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between group bubbles, 2',
      ),
      DocsThemeField(
        name: 'tailBehavior',
        type: 'ChatTailBehavior?',
        description: 'first | middle | last | never',
      ),
      DocsThemeField(
        name: 'tailRadius',
        type: 'double?',
        description: 'ambient radiusSm',
      ),
      DocsThemeField(name: 'tailSize', type: 'Size?', description: '8 x 8'),
      DocsThemeField(
        name: 'variant',
        type: 'ChatBubbleVariant?',
        description: 'plain | tail | sharpCorner',
      ),
      DocsThemeField(
        name: 'widthFactor',
        type: 'double?',
        description: 'share of the row width, 0.5',
      ),
    ],
  ),
  'chip': DocsThemeTable(
    componentId: 'chip',
    themeClass: 'ChipTheme',
    themeDefaults: 'chipDefaults',
    userFile: 'chip_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'buttonIconSize',
        type: 'double?',
        description: '12, used by ChipButton',
      ),
      DocsThemeField(
        name: 'buttonPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'zero, used by ChipButton',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: '8 x 2',
      ),
      DocsThemeField(
        name: 'style',
        type: 'ButtonVariantStyle?',
        description: 'extra per-state rows merged over the variant row',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: '12px w500; colour comes from the button style',
      ),
      DocsThemeField(
        name: 'variant',
        type: 'ButtonVariant?',
        description: 'secondary; selects the button style row',
      ),
    ],
  ),
  'country_flag': DocsThemeTable(
    componentId: 'country_flag',
    themeClass: 'CountryFlagTheme',
    themeDefaults: 'countryFlagDefaults',
    userFile: 'country_flag_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'builder',
        type: 'CountryFlagBuilder?',
        description: 'artwork provider, emoji fallback',
      ),
      DocsThemeField(
        name: 'height',
        type: 'double?',
        description: 'default flag height, 18 scaled',
      ),
      DocsThemeField(
        name: 'shape',
        type: 'ShapeBorder?',
        description: 'default clip shape, unclipped',
      ),
      DocsThemeField(
        name: 'width',
        type: 'double?',
        description: 'default flag width, 24 scaled',
      ),
    ],
  ),
  'divider': DocsThemeTable(
    componentId: 'divider',
    themeClass: 'DividerTheme',
    themeDefaults: 'dividerDefaults',
    userFile: 'divider_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'color',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(
        name: 'endIndent',
        type: 'double?',
        description: '0, space after the rule',
      ),
      DocsThemeField(
        name: 'extent',
        type: 'double?',
        description:
            '1; cross-axis size (height when horizontal, width when vertical)',
      ),
      DocsThemeField(
        name: 'indent',
        type: 'double?',
        description: '0, space before the rule',
      ),
      DocsThemeField(
        name: 'labelAlignment',
        type: 'DividerLabelAlignment?',
        description: 'center',
      ),
      DocsThemeField(
        name: 'labelPadding',
        type: 'EdgeInsetsGeometry?',
        description: '8 horizontal',
      ),
      DocsThemeField(
        name: 'labelStyle',
        type: 'TextStyle?',
        description: '12px; colour falls back to mutedForeground',
      ),
      DocsThemeField(
        name: 'thickness',
        type: 'double?',
        description: '1 (shadcn h-px)',
      ),
    ],
  ),
  'empty_state': DocsThemeTable(
    componentId: 'empty_state',
    themeClass: 'EmptyStateTheme',
    themeDefaults: 'emptyStateDefaults',
    userFile: 'empty_state_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'descriptionStyle',
        type: 'TextStyle?',
        description: 'merged onto the size\'s description style',
      ),
      DocsThemeField(
        name: 'iconColor',
        type: 'ThemedColor?',
        description: 'null = mutedForeground',
      ),
      DocsThemeField(
        name: 'iconContainerBackground',
        type: 'ThemedColor?',
        description: 'null = muted',
      ),
      DocsThemeField(
        name: 'iconContainerBorderColor',
        type: 'ThemedColor?',
        description: 'null = border',
      ),
      DocsThemeField(
        name: 'iconContainerBorderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = the size\'s entry (circular 14)',
      ),
      DocsThemeField(
        name: 'iconContainerPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = the size\'s entry',
      ),
      DocsThemeField(
        name: 'maxWidth',
        type: 'double?',
        description: 'null = the size\'s entry (420 / 520)',
      ),
      DocsThemeField(
        name: 'metrics',
        type: 'Map<EmptyStateSize, EmptyStateMetrics>?',
        description: 'a listed size wins as a whole',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = the size\'s entry (24 compact / 32 full page)',
      ),
      DocsThemeField(
        name: 'surface',
        type: 'ThemedColor?',
        description: 'compact surface fill; null = the ambient card token',
      ),
      DocsThemeField(
        name: 'titleStyle',
        type: 'TextStyle?',
        description: 'merged onto the size\'s title style',
      ),
    ],
  ),
  'feature_carousel': DocsThemeTable(
    componentId: 'feature_carousel',
    themeClass: 'FeatureCarouselTheme',
    themeDefaults: 'featureCarouselDefaults',
    userFile: 'feature_carousel_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'accentColor',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'cardBorder',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(
        name: 'cardFill',
        type: 'ThemedColor?',
        description: 'card token',
      ),
      DocsThemeField(
        name: 'controlBackground',
        type: 'ThemedColor?',
        description: 'muted at 35% alpha',
      ),
      DocsThemeField(
        name: 'controlForeground',
        type: 'ThemedColor?',
        description: 'mutedForeground token',
      ),
      DocsThemeField(
        name: 'ghostFill',
        type: 'ThemedColor?',
        description: 'muted token',
      ),
      DocsThemeField(name: 'radius', type: 'double?', description: '12'),
      DocsThemeField(
        name: 'transitionDuration',
        type: 'Duration?',
        description: '260 ms',
      ),
    ],
  ),
  'file_diff_viewer': DocsThemeTable(
    componentId: 'file_diff_viewer',
    themeClass: 'FileDiffViewerTheme',
    themeDefaults: 'fileDiffViewerDefaults',
    userFile: 'file_diff_viewer_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'additionColor',
        type: 'ThemedColor?',
        description: 'chart2 token',
      ),
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'card token',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'border token (frame, gutter, split divider)',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient radiusLg',
      ),
      DocsThemeField(
        name: 'deletionColor',
        type: 'ThemedColor?',
        description: 'destructive token',
      ),
      DocsThemeField(
        name: 'hunkBackground',
        type: 'ThemedColor?',
        description: 'accent token',
      ),
      DocsThemeField(
        name: 'linePadding',
        type: 'EdgeInsetsGeometry?',
        description: 'density-based inset',
      ),
    ],
  ),
  'keyboard_shortcut': DocsThemeTable(
    componentId: 'keyboard_shortcut',
    themeClass: 'KeyboardShortcutTheme',
    themeDefaults: 'keyboardShortcutDefaults',
    userFile: 'keyboard_shortcut_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'keyBackground',
        type: 'ThemedColor?',
        description: 'null = background at 70% alpha',
      ),
      DocsThemeField(
        name: 'keyBorderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = the ambient radiusMd',
      ),
      DocsThemeField(
        name: 'keyForeground',
        type: 'ThemedColor?',
        description: 'null = mutedForeground',
      ),
      DocsThemeField(
        name: 'keyPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = symmetric(6, 4) (shadcn px-1.5 py-0.5)',
      ),
      DocsThemeField(
        name: 'keyShadows',
        type: 'List<BoxShadow>?',
        description: 'null = none (the shadcn look)',
      ),
      DocsThemeField(
        name: 'keyTextStyle',
        type: 'TextStyle?',
        description: 'merged onto the default; null = text-xs (12, w500)',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'null = 2 (shadcn gap-0.5)',
      ),
    ],
  ),
  'number_ticker': DocsThemeTable(
    componentId: 'number_ticker',
    themeClass: 'NumberTickerTheme',
    themeDefaults: 'numberTickerDefaults',
    userFile: 'number_ticker_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'curve',
        type: 'Curve?',
        description: 'animation curve, easeInOut',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'animation duration, 500ms',
      ),
      DocsThemeField(
        name: 'style',
        type: 'TextStyle?',
        description: 'text style, ambient',
      ),
    ],
  ),
  'pinned_sheet': DocsThemeTable(
    componentId: 'pinned_sheet',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'table': DocsThemeTable(
    componentId: 'table',
    themeClass: 'TableTheme',
    themeDefaults: 'tableDefaults',
    userFile: 'table_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'card token',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'no outer border',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient radiusMd',
      ),
      DocsThemeField(name: 'borderWidth', type: 'double?', description: '0'),
      DocsThemeField(
        name: 'cellTheme',
        type: 'TableCellTheme?',
        description: 'merged under row/cell themes',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'none',
      ),
      DocsThemeField(
        name: 'resizerColor',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'resizerThickness',
        type: 'double?',
        description: '4',
      ),
    ],
  ),
  'timeline': DocsThemeTable(
    componentId: 'timeline',
    themeClass: 'TimelineTheme',
    themeDefaults: 'timelineDefaults',
    userFile: 'timeline_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'color',
        type: 'ThemedColor?',
        description: 'indicator/connector, default primary token',
      ),
      DocsThemeField(
        name: 'connectorThickness',
        type: 'double?',
        description: 'null = 2 * scaling',
      ),
      DocsThemeField(
        name: 'dotSize',
        type: 'double?',
        description: 'null = 12 * scaling',
      ),
      DocsThemeField(
        name: 'rowGap',
        type: 'double?',
        description: 'null = 16 * scaling',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'null = density base content padding * scaling',
      ),
      DocsThemeField(
        name: 'timeConstraints',
        type: 'BoxConstraints?',
        description: 'null = 120 * scaling',
      ),
    ],
  ),
  'tracker': DocsThemeTable(
    componentId: 'tracker',
    themeClass: 'TrackerTheme',
    themeDefaults: 'trackerDefaults',
    userFile: 'tracker_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'critical',
        type: 'ThemedColor?',
        description: 'fill of a critical segment (destructive token)',
      ),
      DocsThemeField(
        name: 'fine',
        type: 'ThemedColor?',
        description: 'fill of a fine segment',
      ),
      DocsThemeField(name: 'gap', type: 'double?', description: '2'),
      DocsThemeField(name: 'itemHeight', type: 'double?', description: '32'),
      DocsThemeField(
        name: 'radius',
        type: 'double?',
        description: 'null = ambient radiusMd',
      ),
      DocsThemeField(
        name: 'unknown',
        type: 'ThemedColor?',
        description: 'fill of an unknown segment (mutedForeground token)',
      ),
      DocsThemeField(
        name: 'warning',
        type: 'ThemedColor?',
        description: 'fill of a warning segment',
      ),
    ],
  ),
  'tree': DocsThemeTable(
    componentId: 'tree',
    themeClass: 'TreeTheme',
    themeDefaults: 'treeDefaults',
    userFile: 'tree_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'branchLine',
        type: 'TreeBranchLine?',
        description: 'guide style, default path',
      ),
      DocsThemeField(
        name: 'branchLineColor',
        type: 'ThemedColor?',
        description: 'guide colour, default border',
      ),
      DocsThemeField(
        name: 'indentWidth',
        type: 'double?',
        description: 'space per level, default 16',
      ),
      DocsThemeField(
        name: 'itemGap',
        type: 'double?',
        description: 'gap between adornments and content, default 8',
      ),
      DocsThemeField(
        name: 'itemPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'row padding, default 8x4',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'padding around the tree',
      ),
      DocsThemeField(
        name: 'selectedBackground',
        type: 'ThemedColor?',
        description: 'default primary at 5%',
      ),
      DocsThemeField(
        name: 'selectedFocusedBackground',
        type: 'ThemedColor?',
        description: 'default primary at 10%',
      ),
      DocsThemeField(
        name: 'selectedRadius',
        type: 'BorderRadiusGeometry?',
        description: 'default theme.borderRadiusMd',
      ),
    ],
  ),
  'calendar': DocsThemeTable(
    componentId: 'calendar',
    themeClass: 'CalendarTheme',
    themeDefaults: 'calendarDefaults',
    userFile: 'calendar_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'cellBackground',
        type: 'StateValue<ThemedColor>?',
        description:
            'per-state fill of an unselected cell; rest = transparent, hovered = accent',
      ),
      DocsThemeField(
        name: 'cellBorderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = borderRadiusMd',
      ),
      DocsThemeField(
        name: 'cellForeground',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state label colour; null = foreground',
      ),
      DocsThemeField(
        name: 'cellHeight',
        type: 'double?',
        description: '32 for days, 40 for months and years',
      ),
      DocsThemeField(
        name: 'cellTextStyle',
        type: 'TextStyle?',
        description: 'cell label; its colour is ignored',
      ),
      DocsThemeField(
        name: 'cellWidth',
        type: 'double?',
        description: '32 for days, 56 for months and years',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'cell and row gap; null = 4',
      ),
      DocsThemeField(
        name: 'rangeBackground',
        type: 'ThemedColor?',
        description: 'fill inside a range; null = secondary',
      ),
      DocsThemeField(
        name: 'selectedBackground',
        type: 'ThemedColor?',
        description: 'fill of a selected cell; null = primary',
      ),
      DocsThemeField(
        name: 'selectedForeground',
        type: 'ThemedColor?',
        description: 'label of a selected cell; null = primaryForeground',
      ),
      DocsThemeField(
        name: 'todayBackground',
        type: 'ThemedColor?',
        description: 'fill of today\'s cell; null = secondary',
      ),
      DocsThemeField(
        name: 'weekdayTextStyle',
        type: 'TextStyle?',
        description: 'weekday header; its colour is muted',
      ),
    ],
  ),
  'date_picker': DocsThemeTable(
    componentId: 'date_picker',
    themeClass: 'DatePickerTheme',
    themeDefaults: 'datePickerDefaults',
    userFile: 'date_picker_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'initialView',
        type: 'CalendarView?',
        description: 'month the calendar opens on; null = value/current month',
      ),
      DocsThemeField(
        name: 'initialViewType',
        type: 'CalendarViewType?',
        description: 'grid shown first; null = date',
      ),
      DocsThemeField(
        name: 'mode',
        type: 'PromptMode?',
        description: 'dialog or popover presentation; null = dialog',
      ),
      DocsThemeField(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        description: 'card placement; null = top-left',
      ),
      DocsThemeField(
        name: 'popoverAnchorAlignment',
        type: 'AlignmentGeometry?',
        description: 'anchor edge; null = bottom-left',
      ),
      DocsThemeField(
        name: 'popoverPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = the primitive default',
      ),
    ],
  ),
  'time_picker': DocsThemeTable(
    componentId: 'time_picker',
    themeClass: 'TimePickerTheme',
    themeDefaults: 'timePickerDefaults',
    userFile: 'time_picker_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'dialogTitle',
        type: 'Widget?',
        description: 'title of the dialog prompt; null = none',
      ),
      DocsThemeField(
        name: 'mode',
        type: 'PromptMode?',
        description: 'dialog or popover presentation; null = dialog',
      ),
      DocsThemeField(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        description: 'card placement; null = top-left',
      ),
      DocsThemeField(
        name: 'popoverAnchorAlignment',
        type: 'AlignmentGeometry?',
        description: 'anchor edge; null = bottom-left',
      ),
      DocsThemeField(
        name: 'popoverPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = the primitive default',
      ),
      DocsThemeField(
        name: 'showSeconds',
        type: 'bool?',
        description: 'seconds field; null = false',
      ),
      DocsThemeField(
        name: 'use24HourFormat',
        type: 'bool?',
        description: '12/24-hour clock; null = ambient convention',
      ),
    ],
  ),
  'alert': DocsThemeTable(
    componentId: 'alert',
    themeClass: 'AlertTheme',
    themeDefaults: 'alertDefaults',
    userFile: 'alert_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'surface fill',
      ),
      DocsThemeField(
        name: 'base',
        type: 'AlertStyle?',
        description: 'card-surface banner row',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: '1px border',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = ambient radiusLg',
      ),
      DocsThemeField(
        name: 'contentColor',
        type: 'ThemedColor?',
        description: 'content foreground',
      ),
      DocsThemeField(
        name: 'contentStyle',
        type: 'TextStyle?',
        description: '14 by default',
      ),
      DocsThemeField(
        name: 'destructive',
        type: 'AlertStyle?',
        description: 'destructive-foreground row',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'icon-to-text gap, 12 by default',
      ),
      DocsThemeField(
        name: 'iconColor',
        type: 'ThemedColor?',
        description: 'leading icon colour',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: '16/12 by default',
      ),
      DocsThemeField(
        name: 'titleColor',
        type: 'ThemedColor?',
        description: 'title foreground',
      ),
      DocsThemeField(
        name: 'titleStyle',
        type: 'TextStyle?',
        description: '14 w500 by default',
      ),
    ],
  ),
  'progress': DocsThemeTable(
    componentId: 'progress',
    themeClass: 'ProgressTheme',
    themeDefaults: 'progressDefaults',
    userFile: 'progress_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        description: 'primary token at 20% alpha',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = pill at half the height',
      ),
      DocsThemeField(
        name: 'color',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'disableAnimation',
        type: 'bool?',
        description: 'jump instead of animate, false',
      ),
      DocsThemeField(
        name: 'height',
        type: 'double?',
        description: 'null = 8 * scaling',
      ),
      DocsThemeField(
        name: 'showSparks',
        type: 'bool?',
        description: 'leading-edge glow, false',
      ),
    ],
  ),
  'skeleton': DocsThemeTable(
    componentId: 'skeleton',
    themeClass: 'SkeletonTheme',
    themeDefaults: 'skeletonDefaults',
    userFile: 'skeleton_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = theme borderRadiusMd',
      ),
      DocsThemeField(
        name: 'curve',
        type: 'Curve?',
        description: 'sweep easing; null = Curves.linear',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'one sweep; null = 2 x kDefaultDuration',
      ),
      DocsThemeField(
        name: 'fromColor',
        type: 'ThemedColor?',
        description: 'leading sweep fill; null = muted',
      ),
      DocsThemeField(
        name: 'toColor',
        type: 'ThemedColor?',
        description: 'trailing sweep fill; null = accent',
      ),
    ],
  ),
  'spinner': DocsThemeTable(
    componentId: 'spinner',
    themeClass: 'SpinnerTheme',
    themeDefaults: 'spinnerDefaults',
    userFile: 'spinner_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'color',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'size',
        type: 'double?',
        description: 'null = 24 * scaling',
      ),
      DocsThemeField(
        name: 'strokeWidth',
        type: 'double?',
        description: 'null = size / 12',
      ),
    ],
  ),
  'toast': DocsThemeTable(
    componentId: 'toast',
    themeClass: 'ToastTheme',
    themeDefaults: 'toastDefaults',
    userFile: 'toast_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'animationDuration',
        type: 'Duration?',
        description: 'entry animation',
      ),
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'card fill (popover)',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'card border (border)',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = ambient radiusMd',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: '0 hides the border',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'default auto-dismiss',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'ThemedColor?',
        description: 'content colour (popoverForeground)',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'gap between stacked toasts',
      ),
      DocsThemeField(
        name: 'maxWidth',
        type: 'double?',
        description: 'maximum card width',
      ),
      DocsThemeField(
        name: 'offset',
        type: 'EdgeInsetsGeometry?',
        description: 'stack inset from the screen edges',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'inner padding',
      ),
      DocsThemeField(
        name: 'pauseOnHover',
        type: 'bool?',
        description: 'pause the countdown on hover/press',
      ),
      DocsThemeField(
        name: 'shadows',
        type: 'List<BoxShadow>?',
        description: 'null = ambient shadowLg, [] removes',
      ),
      DocsThemeField(
        name: 'showCloseButton',
        type: 'bool?',
        description: 'per-card close affordance',
      ),
    ],
  ),
  'autocomplete': DocsThemeTable(
    componentId: 'autocomplete',
    themeClass: 'AutoCompleteTheme',
    themeDefaults: 'autocompleteDefaults',
    userFile: 'autocomplete_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'containerBackground',
        type: 'ThemedColor?',
        description: 'popover surface fill',
      ),
      DocsThemeField(
        name: 'containerBorderColor',
        type: 'ThemedColor?',
        description: 'null draws no border',
      ),
      DocsThemeField(
        name: 'containerBorderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = ambient radiusMd',
      ),
      DocsThemeField(
        name: 'containerBorderWidth',
        type: 'double?',
        description: 'used when the border resolves',
      ),
      DocsThemeField(
        name: 'containerForeground',
        type: 'ThemedColor?',
        description: 'label colour inside the popover',
      ),
      DocsThemeField(
        name: 'containerPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'shadcn p-1, so 4 all round',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'vertical space between rows, 0 by default',
      ),
      DocsThemeField(
        name: 'itemBackground',
        type: 'StateValue<ThemedColor>?',
        description: 'accent on hover/press/highlight',
      ),
      DocsThemeField(
        name: 'itemForeground',
        type: 'StateValue<ThemedColor>?',
        description: 'accentForeground while active',
      ),
      DocsThemeField(
        name: 'itemPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'shadcn px-2 py-1.5',
      ),
      DocsThemeField(
        name: 'itemRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = ambient radiusSm',
      ),
      DocsThemeField(
        name: 'itemTextStyle',
        type: 'TextStyle?',
        description: 'null = text-sm (14), colour from itemForeground',
      ),
      DocsThemeField(
        name: 'maxHeight',
        type: 'double?',
        description: 'list height cap, shadcn max-h-60 = 240',
      ),
      DocsThemeField(
        name: 'mode',
        type: 'AutoCompleteMode?',
        description: 'default replacement strategy, replaceWord',
      ),
      DocsThemeField(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        description: 'null = topStart',
      ),
      DocsThemeField(
        name: 'popoverAnchorAlignment',
        type: 'AlignmentGeometry?',
        description: 'null = bottomStart',
      ),
      DocsThemeField(
        name: 'popoverConstraints',
        type: 'BoxConstraints?',
        description: 'null caps the list at maxHeight',
      ),
      DocsThemeField(
        name: 'popoverWidthConstraint',
        type: 'PopoverConstraint?',
        description:
            'null keeps the field width as a minimum and hugs wider suggestions',
      ),
    ],
  ),
  'checkbox': DocsThemeTable(
    componentId: 'checkbox',
    themeClass: 'CheckboxTheme',
    themeDefaults: 'checkboxDefaults',
    userFile: 'checkbox_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state box fill',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'null draws no border',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient radiusSm',
      ),
      DocsThemeField(name: 'borderWidth', type: 'double?', description: '1'),
      DocsThemeField(
        name: 'checked',
        type: 'CheckboxStyle?',
        description: 'primary fill row',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: '8, between box and label',
      ),
      DocsThemeField(
        name: 'indeterminate',
        type: 'CheckboxStyle?',
        description: 'primary fill, dash indicator',
      ),
      DocsThemeField(
        name: 'indicatorColor',
        type: 'ThemedColor?',
        description: 'check/dash colour; null hides it',
      ),
      DocsThemeField(
        name: 'indicatorSize',
        type: 'double?',
        description: 'defaults to size * 0.75',
      ),
      DocsThemeField(
        name: 'labelStyle',
        type: 'TextStyle?',
        description: 'shared by every value, 14px',
      ),
      DocsThemeField(
        name: 'labelStyle(row)',
        type: 'TextStyle?',
        description: 'colour falls back to foreground',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: '2, keeps the focus ring un-clipped',
      ),
      DocsThemeField(name: 'size', type: 'double?', description: '16'),
      DocsThemeField(
        name: 'unchecked',
        type: 'CheckboxStyle?',
        description: 'transparent fill, input border row',
      ),
    ],
  ),
  'chip_input': DocsThemeTable(
    componentId: 'chip_input',
    themeClass: 'ChipInputTheme',
    themeDefaults: 'chipInputDefaults',
    userFile: 'chip_input_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'alignment',
        type: 'PlaceholderAlignment?',
        description: 'middle; how a token sits on the text baseline',
      ),
      DocsThemeField(
        name: 'chipIconSize',
        type: 'double?',
        description: '12; icon size of the remove button',
      ),
      DocsThemeField(
        name: 'chipTheme',
        type: 'ChipTheme?',
        description: 'extra leg for this field\'s tokens only',
      ),
      DocsThemeField(
        name: 'removable',
        type: 'bool?',
        description: 'true; whether each token gets a remove button',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: '4; the rendered gap between two neighbouring tokens',
      ),
    ],
  ),
  'dropzone': DocsThemeTable(
    componentId: 'dropzone',
    themeClass: 'DropzoneTheme',
    themeDefaults: 'dropzoneDefaults',
    userFile: 'dropzone_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'actionGap',
        type: 'double?',
        description: 'null = 24',
      ),
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'null = no fill',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state; the DropzoneState token wins',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = the ambient radiusLg',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'null = 1',
      ),
      DocsThemeField(
        name: 'dragBorder',
        type: 'ThemedColor?',
        description:
            'border while a drag hovers; null = the DropzoneState.dragging token (primary)',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'null = 150ms',
      ),
      DocsThemeField(
        name: 'focusRingColor',
        type: 'ThemedColor?',
        description: 'null = ring',
      ),
      DocsThemeField(
        name: 'focusRingSpread',
        type: 'double?',
        description: 'null = 2',
      ),
      DocsThemeField(name: 'gap', type: 'double?', description: 'null = 16'),
      DocsThemeField(name: 'hintGap', type: 'double?', description: 'null = 4'),
      DocsThemeField(
        name: 'hintStyle',
        type: 'TextStyle?',
        description: 'merged onto the default; null = 12',
      ),
      DocsThemeField(
        name: 'hoverScale',
        type: 'double?',
        description: 'null = 1.05',
      ),
      DocsThemeField(
        name: 'iconColor',
        type: 'ThemedColor?',
        description: 'null = mutedForeground',
      ),
      DocsThemeField(
        name: 'iconSize',
        type: 'double?',
        description: 'null = 28',
      ),
      DocsThemeField(
        name: 'minHeight',
        type: 'double?',
        description: 'null = 0 (the surface hugs its content)',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = 24',
      ),
      DocsThemeField(
        name: 'statusStyle',
        type: 'TextStyle?',
        description: 'merged onto the default; null = 14',
      ),
    ],
  ),
  'file_picker': DocsThemeTable(
    componentId: 'file_picker',
    themeClass: 'FileUploadTheme',
    themeDefaults: 'fileUploadDefaults',
    userFile: 'file_picker_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'tile fill; null = no fill',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'tile border; null = input token',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = the ambient radiusMd',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'null = 1',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'vertical rhythm; null = 12',
      ),
      DocsThemeField(
        name: 'minHeight',
        type: 'double?',
        description: 'tile min height; null = 48',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'tile padding; null = 16x12',
      ),
    ],
  ),
  'form': DocsThemeTable(
    componentId: 'form',
    themeClass: 'FormTheme',
    themeDefaults: 'formDefaults',
    userFile: 'form_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'hintColor',
        type: 'ThemedColor?',
        description: 'default mutedForeground',
      ),
      DocsThemeField(
        name: 'hintStyle',
        type: 'TextStyle?',
        description: 'default 12',
      ),
      DocsThemeField(
        name: 'labelColor',
        type: 'ThemedColor?',
        description: 'default foreground',
      ),
      DocsThemeField(
        name: 'labelStyle',
        type: 'TextStyle?',
        description: 'default 13 / w500',
      ),
      DocsThemeField(
        name: 'messageColor',
        type: 'ThemedColor?',
        description: 'default destructive',
      ),
      DocsThemeField(
        name: 'messageStyle',
        type: 'TextStyle?',
        description: 'default 12 / w500',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'vertical gap between blocks, default 8',
      ),
    ],
  ),
  'formatted_input': DocsThemeTable(
    componentId: 'formatted_input',
    themeClass: 'FormattedInputTheme',
    themeDefaults: 'formattedInputDefaults',
    userFile: 'formatted_input_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'field fill, input at 30%',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'field border, the input token',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'default theme.borderRadiusMd',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'border width, 1',
      ),
      DocsThemeField(
        name: 'height',
        type: 'double?',
        description: 'field height, 36',
      ),
      DocsThemeField(
        name: 'hoveredBackground',
        type: 'ThemedColor?',
        description: 'field fill while hovered, input at 50%',
      ),
      DocsThemeField(
        name: 'leadingGap',
        type: 'double?',
        description: 'space around leading/trailing, 8 (scaled)',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'inner padding, 8 x 4 (scaled)',
      ),
      DocsThemeField(
        name: 'partGap',
        type: 'double?',
        description: 'space between parts, 0',
      ),
      DocsThemeField(
        name: 'placeholderStyle',
        type: 'TextStyle?',
        description: 'default text-sm muted',
      ),
      DocsThemeField(
        name: 'separatorStyle',
        type: 'TextStyle?',
        description: 'default the text style in mutedForeground',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'segment style, theme mono at text-sm',
      ),
    ],
  ),
  'input': DocsThemeTable(
    componentId: 'input',
    themeClass: 'InputTheme',
    themeDefaults: 'inputDefaults',
    userFile: 'input_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'StateValue<ThemedColor>?',
        description:
            'per-state fill, input@0.3 rest / 0.5 hovered / 0 disabled',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'input token; destructive while errorText is set',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null resolves radiusMd',
      ),
      DocsThemeField(name: 'borderWidth', type: 'double?', description: '1.0'),
      DocsThemeField(
        name: 'cursorColor',
        type: 'ThemedColor?',
        description: 'defaults to primary',
      ),
      DocsThemeField(
        name: 'height',
        type: 'double?',
        description: 'minimum field height, 36',
      ),
      DocsThemeField(
        name: 'hintStyle',
        type: 'TextStyle?',
        description: 'defaults to mutedForeground',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'defaults to 12 x 8',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'its color wins over the foreground token',
      ),
    ],
  ),
  'input_otp': DocsThemeTable(
    componentId: 'input_otp',
    themeClass: 'InputOtpTheme',
    themeDefaults: 'inputOtpDefaults',
    userFile: 'input_otp_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state slot fill; null = input@0.3 rest / 0.5 hovered',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state slot border; null = input',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = borderRadiusMd',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'used when borderColor resolves; null = 1',
      ),
      DocsThemeField(
        name: 'boxSize',
        type: 'double?',
        description: 'slot size; null = 36',
      ),
      DocsThemeField(
        name: 'cursorColor',
        type: 'ThemedColor?',
        description: 'caret of the focused slot; null = ring',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = 6 x 0',
      ),
      DocsThemeField(
        name: 'separatorTextStyle',
        type: 'TextStyle?',
        description: 'style of the optional separator',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between slots; null = the density base gap',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'its colour is ignored (taken from foreground)',
      ),
    ],
  ),
  'item_picker': DocsThemeTable(
    componentId: 'item_picker',
    themeClass: 'ItemPickerTheme',
    themeDefaults: 'itemPickerDefaults',
    userFile: 'item_picker_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'constraints',
        type: 'BoxConstraints?',
        description: 'bounds of the items box, 320x320 max',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'padding around the items, 8',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between grid cells, 4',
      ),
    ],
  ),
  'multi_select': DocsThemeTable(
    componentId: 'multi_select',
    themeClass: 'SelectTheme',
    themeDefaults: '',
    userFile: 'select/select_theme.dart',
    userOwned: false,
    hasTheme: true,
    fields: <DocsThemeField>[],
  ),
  'object_input': DocsThemeTable(
    componentId: 'object_input',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'phone_input': DocsThemeTable(
    componentId: 'phone_input',
    themeClass: 'PhoneInputTheme',
    themeDefaults: 'phoneInputDefaults',
    userFile: 'phone_input_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'countryGap',
        type: 'double?',
        description: 'name-to-dial-code gap in popup rows, 16 by default',
      ),
      DocsThemeField(
        name: 'fieldGap',
        type: 'double?',
        description: 'selector-to-field gap, 8 by default',
      ),
      DocsThemeField(
        name: 'flagGap',
        type: 'double?',
        description: 'flag-to-code/name gap, 8 by default',
      ),
      DocsThemeField(
        name: 'flagHeight',
        type: 'double?',
        description: 'flag height, 18 by default',
      ),
      DocsThemeField(
        name: 'flagWidth',
        type: 'double?',
        description: 'flag width, 24 by default',
      ),
      DocsThemeField(
        name: 'inputPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'number field padding, 12/8 by default',
      ),
      DocsThemeField(
        name: 'maxWidth',
        type: 'double?',
        description: 'number field width, 200 by default',
      ),
      DocsThemeField(
        name: 'popupConstraints',
        type: 'BoxConstraints?',
        description: 'popup max size, 250x300 by default',
      ),
      DocsThemeField(
        name: 'selectWidth',
        type: 'double?',
        description:
            'country selector width (the popup is trigger-wide), 180 by default',
      ),
    ],
  ),
  'radio_group': DocsThemeTable(
    componentId: 'radio_group',
    themeClass: 'RadioGroupTheme',
    themeDefaults: 'radioGroupDefaults',
    userFile: 'radio_group_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'card',
        type: 'SelectableCardTheme?',
        description:
            'card surface styling (padding, borderRadius, per-state fill and border, gap)',
      ),
      DocsThemeField(
        name: 'direction',
        type: 'Axis?',
        description: 'arrow-key reading order; null = the widget\'s own',
      ),
      DocsThemeField(
        name: 'items',
        type: 'SelectableRadioTheme?',
        description:
            'row styling (gap, itemPadding, labelStyle, indicator rows)',
      ),
    ],
  ),
  'select': DocsThemeTable(
    componentId: 'select',
    themeClass: 'SelectTheme',
    themeDefaults: 'selectDefaults',
    userFile: 'select_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'constraints',
        type: 'BoxConstraints?',
        description:
            'popup size; null = 128 min wide, 240 high, no max width (hugs the widest option, never narrower than the trigger)',
      ),
      DocsThemeField(
        name: 'itemPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'option row padding; null = px-2 py-1.5',
      ),
      DocsThemeField(
        name: 'popup',
        type: 'MenuPopupTheme?',
        description: 'surface override (menu-owned class)',
      ),
      DocsThemeField(
        name: 'trigger',
        type: 'ButtonVariantStyle?',
        description: 'per-state trigger rows merged over the variant',
      ),
      DocsThemeField(
        name: 'variant',
        type: 'ButtonVariant?',
        description: 'trigger row; null = outline',
      ),
    ],
  ),
  'slider': DocsThemeTable(
    componentId: 'slider',
    themeClass: 'SliderTheme',
    themeDefaults: 'sliderDefaults',
    userFile: 'slider_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'dots',
        type: 'SliderStyle?',
        description: 'step dots overlay',
      ),
      DocsThemeField(
        name: 'fill',
        type: 'StateValue<ThemedColor>?',
        description: 'active fill',
      ),
      DocsThemeField(
        name: 'mark',
        type: 'StateValue<ThemedColor>?',
        description: 'unfilled marks',
      ),
      DocsThemeField(
        name: 'soft',
        type: 'SliderStyle?',
        description: 'thicker track, circle thumb',
      ),
      DocsThemeField(
        name: 'standard',
        type: 'SliderStyle?',
        description: 'pill track, bar thumb',
      ),
      DocsThemeField(
        name: 'thumb',
        type: 'StateValue<ThemedColor>?',
        description: 'thumb fill',
      ),
      DocsThemeField(
        name: 'thumbBorder',
        type: 'StateValue<ThemedColor>?',
        description: 'circle thumb border',
      ),
      DocsThemeField(
        name: 'thumbShape',
        type: 'SliderThumbShape?',
        description: '',
      ),
      DocsThemeField(name: 'thumbSize', type: 'Size?', description: ''),
      DocsThemeField(
        name: 'track',
        type: 'StateValue<ThemedColor>?',
        description: 'remaining track',
      ),
      DocsThemeField(name: 'trackHeight', type: 'double?', description: ''),
      DocsThemeField(name: 'trackRadius', type: 'double?', description: ''),
      DocsThemeField(
        name: 'wave',
        type: 'SliderStyle?',
        description: 'waveform bars overlay',
      ),
    ],
  ),
  'star_rating': DocsThemeTable(
    componentId: 'star_rating',
    themeClass: 'StarRatingTheme',
    themeDefaults: 'starRatingDefaults',
    userFile: 'star_rating_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'activeColor',
        type: 'ThemedColor?',
        description: 'filled part, default primary',
      ),
      DocsThemeField(
        name: 'inactiveColor',
        type: 'ThemedColor?',
        description: 'unfilled part, default muted',
      ),
      DocsThemeField(
        name: 'innerRadiusRatio',
        type: 'double?',
        description: 'valley depth, default 0.4',
      ),
      DocsThemeField(
        name: 'pointRounding',
        type: 'double?',
        description: '0..1 fraction, default 0',
      ),
      DocsThemeField(
        name: 'points',
        type: 'double?',
        description: 'star points, default 5',
      ),
      DocsThemeField(
        name: 'rotation',
        type: 'double?',
        description: 'degrees, default 0',
      ),
      DocsThemeField(
        name: 'size',
        type: 'double?',
        description: 'star side, default 24',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between stars, default 5',
      ),
      DocsThemeField(
        name: 'squash',
        type: 'double?',
        description: '0..1 compression, default 0',
      ),
      DocsThemeField(
        name: 'style',
        type: 'StarRatingStyle?',
        description: 'the star row slice',
      ),
      DocsThemeField(
        name: 'valleyRounding',
        type: 'double?',
        description: '0..1 fraction, default 0',
      ),
    ],
  ),
  'switch': DocsThemeTable(
    componentId: 'switch',
    themeClass: 'SwitchTheme',
    themeDefaults: 'switchDefaults',
    userFile: 'switch_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'borderColor',
        type: 'StateValue<ThemedColor>?',
        description: 'null draws no border',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: '0 by default (shadcn draws a transparent one)',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: '8, between switch and label',
      ),
      DocsThemeField(
        name: 'labelStyle',
        type: 'TextStyle?',
        description: 'shared by both values, 14px',
      ),
      DocsThemeField(
        name: 'labelStyle(row)',
        type: 'TextStyle?',
        description: 'colour falls back to foreground',
      ),
      DocsThemeField(
        name: 'off',
        type: 'SwitchStyle?',
        description: 'input track, foreground thumb',
      ),
      DocsThemeField(
        name: 'on',
        type: 'SwitchStyle?',
        description: 'primary track, background thumb',
      ),
      DocsThemeField(
        name: 'thumbColor',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state thumb fill',
      ),
      DocsThemeField(name: 'thumbSize', type: 'double?', description: '16'),
      DocsThemeField(
        name: 'trackColor',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state track fill',
      ),
      DocsThemeField(name: 'trackSize', type: 'Size?', description: '28 x 20'),
      DocsThemeField(
        name: 'travel',
        type: 'double?',
        description: 'derived from track and thumb at build',
      ),
    ],
  ),
  'text_area': DocsThemeTable(
    componentId: 'text_area',
    themeClass: 'InputTheme',
    themeDefaults: 'inputDefaults',
    userFile: '../input/input_theme.dart',
    userOwned: false,
    hasTheme: true,
    fields: <DocsThemeField>[],
  ),
  'accordion': DocsThemeTable(
    componentId: 'accordion',
    themeClass: 'AccordionTheme',
    themeDefaults: 'accordionDefaults',
    userFile: 'accordion_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'arrowIcon',
        type: 'IconData?',
        description: 'Lucide chevronUp',
      ),
      DocsThemeField(
        name: 'arrowIconColor',
        type: 'ThemedColor?',
        description: 'mutedForeground token',
      ),
      DocsThemeField(name: 'curve', type: 'Curve?', description: 'easeIn'),
      DocsThemeField(
        name: 'dividerColor',
        type: 'ThemedColor?',
        description: 'muted token',
      ),
      DocsThemeField(
        name: 'dividerHeight',
        type: 'double?',
        description: '1 times ambient scaling',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: '200 ms',
      ),
      DocsThemeField(
        name: 'iconGap',
        type: 'double?',
        description: '18 times ambient scaling',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'double?',
        description: 'content density, vertical trigger/content padding',
      ),
      DocsThemeField(
        name: 'reverseCurve',
        type: 'Curve?',
        description: 'easeOut',
      ),
    ],
  ),
  'card': DocsThemeTable(
    componentId: 'card',
    themeClass: 'CardTheme',
    themeDefaults: 'cardDefaults',
    userFile: 'card_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'card token',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient radiusXl',
      ),
      DocsThemeField(name: 'borderWidth', type: 'double?', description: '1.0'),
      DocsThemeField(
        name: 'foreground',
        type: 'ThemedColor?',
        description: 'cardForeground token',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: '24',
      ),
      DocsThemeField(
        name: 'shadows',
        type: 'List<BoxShadow>?',
        description: 'ambient shadowSm; const [] removes them',
      ),
    ],
  ),
  'card_image': DocsThemeTable(
    componentId: 'card_image',
    themeClass: 'CardImageTheme',
    themeDefaults: 'cardImageDefaults',
    userFile: 'card_image_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'direction',
        type: 'Axis?',
        description: 'composition axis; null = vertical',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'image/text gap; null = 12',
      ),
      DocsThemeField(
        name: 'hoverScale',
        type: 'double?',
        description: 'image scale while hovered; null = 1.05',
      ),
      DocsThemeField(
        name: 'imageBackground',
        type: 'ThemedColor?',
        description: 'image fill; null = transparent token',
      ),
      DocsThemeField(
        name: 'imageBorderColor',
        type: 'ThemedColor?',
        description: 'image border; null = transparent token',
      ),
      DocsThemeField(
        name: 'imageRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = ambient radiusXl',
      ),
      DocsThemeField(
        name: 'normalScale',
        type: 'double?',
        description: 'image scale at rest; null = 1',
      ),
    ],
  ),
  'collapsible': DocsThemeTable(
    componentId: 'collapsible',
    themeClass: 'CollapsibleTheme',
    themeDefaults: 'collapsibleDefaults',
    userFile: 'collapsible_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'crossAxisAlignment',
        type: 'CrossAxisAlignment?',
        description: 'stretch',
      ),
      DocsThemeField(
        name: 'iconCollapsed',
        type: 'IconData?',
        description: 'Lucide chevrons-up-down',
      ),
      DocsThemeField(
        name: 'iconExpanded',
        type: 'IconData?',
        description: 'Lucide chevrons-down-up',
      ),
      DocsThemeField(
        name: 'iconGap',
        type: 'double?',
        description: '16 times ambient scaling',
      ),
      DocsThemeField(
        name: 'mainAxisAlignment',
        type: 'MainAxisAlignment?',
        description: 'start',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'double?',
        description: 'content density, horizontal trigger padding',
      ),
    ],
  ),
  'filter_bar': DocsThemeTable(
    componentId: 'filter_bar',
    themeClass: 'FilterBarTheme',
    themeDefaults: 'filterBarDefaults',
    userFile: 'filter_bar_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'controlWidth',
        type: 'double?',
        description: 'sort/date control width, 180 by default',
      ),
      DocsThemeField(
        name: 'dense',
        type: 'bool?',
        description: 'compact padding and small buttons, false by default',
      ),
      DocsThemeField(
        name: 'runSpacing',
        type: 'double?',
        description: 'gap between wrapped runs, 8 by default',
      ),
      DocsThemeField(
        name: 'searchWidth',
        type: 'double?',
        description: 'search field width, 220 by default',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between controls, 12 by default',
      ),
    ],
  ),
  'overflow_marquee': DocsThemeTable(
    componentId: 'overflow_marquee',
    themeClass: 'OverflowMarqueeTheme',
    themeDefaults: 'overflowMarqueeDefaults',
    userFile: 'overflow_marquee_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'curve',
        type: 'Curve?',
        description: 'easing of each run',
      ),
      DocsThemeField(
        name: 'delayDuration',
        type: 'Duration?',
        description: 'pause at each end',
      ),
      DocsThemeField(
        name: 'direction',
        type: 'Axis?',
        description: 'horizontal | vertical',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'time of one `step` run',
      ),
      DocsThemeField(
        name: 'fadePortion',
        type: 'double?',
        description: 'edge fade fraction of the visible extent, clamped 0..0.5',
      ),
      DocsThemeField(
        name: 'step',
        type: 'double?',
        description: 'pixels covered per `duration`',
      ),
    ],
  ),
  'resizable': DocsThemeTable(
    componentId: 'resizable',
    themeClass: 'ResizableTheme',
    themeDefaults: 'resizableDefaults',
    userFile: 'resizable_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'gripColor',
        type: 'ThemedColor?',
        description: 'grip colour (border)',
      ),
      DocsThemeField(
        name: 'gripSize',
        type: 'Size?',
        description: 'grip size for a horizontal group (4x16)',
      ),
      DocsThemeField(
        name: 'handleColor',
        type: 'StateValue<ThemedColor>?',
        description: 'border / ring on hover+press',
      ),
      DocsThemeField(
        name: 'handleThickness',
        type: 'double?',
        description: 'divider line thickness (1)',
      ),
      DocsThemeField(
        name: 'hitThickness',
        type: 'double?',
        description: 'gesture hit area (10)',
      ),
    ],
  ),
  'scaffold': DocsThemeTable(
    componentId: 'scaffold',
    themeClass: 'ScaffoldTheme',
    themeDefaults: 'scaffoldDefaults',
    userFile: 'scaffold_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'appBarBackground',
        type: 'ThemedColor?',
        description: 'bar fill, card token (AppBarTheme.background)',
      ),
      DocsThemeField(
        name: 'appBarPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'density padding (AppBarTheme.padding)',
      ),
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'body fill, background token',
      ),
      DocsThemeField(
        name: 'contentGap',
        type: 'double?',
        description: 'gap between bar sections',
      ),
      DocsThemeField(
        name: 'footerBackground',
        type: 'ThemedColor?',
        description: 'null = transparent',
      ),
      DocsThemeField(
        name: 'headerBackground',
        type: 'ThemedColor?',
        description: 'null = transparent',
      ),
      DocsThemeField(
        name: 'leadingGap',
        type: 'double?',
        description: 'gap between leading widgets',
      ),
      DocsThemeField(
        name: 'resizeToAvoidBottomInset',
        type: 'bool?',
        description: 'pad body for keyboard, true',
      ),
      DocsThemeField(
        name: 'showLoadingSparks',
        type: 'bool?',
        description: 'loading bar sparks, false',
      ),
      DocsThemeField(
        name: 'surfaceBlur',
        type: 'double?',
        description: 'backdrop blur under the bar',
      ),
      DocsThemeField(
        name: 'surfaceOpacity',
        type: 'double?',
        description: 'multiplied onto the bar fill, 1',
      ),
      DocsThemeField(
        name: 'trailingGap',
        type: 'double?',
        description: 'gap between trailing widgets',
      ),
    ],
  ),
  'scrollbar': DocsThemeTable(
    componentId: 'scrollbar',
    themeClass: 'ScrollbarTheme',
    themeDefaults: 'scrollbarDefaults',
    userFile: 'scrollbar_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'color',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(name: 'interactive', type: 'bool?', description: 'true'),
      DocsThemeField(
        name: 'minOverscrollLength',
        type: 'double?',
        description: 'null follows minThumbLength',
      ),
      DocsThemeField(
        name: 'minThumbLength',
        type: 'double?',
        description: '48 (kMinScrollbarThumbExtent)',
      ),
      DocsThemeField(
        name: 'radius',
        type: 'Radius?',
        description: 'radiusSm token',
      ),
      DocsThemeField(
        name: 'thickness',
        type: 'double?',
        description: '7 times ambient scaling',
      ),
    ],
  ),
  'sortable': DocsThemeTable(
    componentId: 'sortable',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'steps': DocsThemeTable(
    componentId: 'steps',
    themeClass: 'StepsTheme',
    themeDefaults: 'stepsDefaults',
    userFile: 'steps_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'connectorColor',
        type: 'ThemedColor?',
        description: 'connector line colour',
      ),
      DocsThemeField(
        name: 'connectorThickness',
        type: 'double?',
        description: 'connector line thickness',
      ),
      DocsThemeField(
        name: 'indicatorColor',
        type: 'ThemedColor?',
        description: 'circle fill',
      ),
      DocsThemeField(
        name: 'indicatorForeground',
        type: 'ThemedColor?',
        description: 'step number colour',
      ),
      DocsThemeField(
        name: 'indicatorSize',
        type: 'double?',
        description: 'numbered circle diameter (× scaling)',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between indicator column and content',
      ),
    ],
  ),
  'command': DocsThemeTable(
    componentId: 'command',
    themeClass: 'CommandTheme',
    themeDefaults: 'commandDefaults',
    userFile: 'command_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'palette surface, default popover',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'surface border',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = radiusLg',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'null draws no border at 0',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'ThemedColor?',
        description: 'item title colour',
      ),
      DocsThemeField(
        name: 'itemHighlight',
        type: 'ThemedColor?',
        description: 'focused row fill, default accent',
      ),
      DocsThemeField(
        name: 'itemHighlightForeground',
        type: 'ThemedColor?',
        description: 'focused row content',
      ),
      DocsThemeField(
        name: 'itemPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'row padding, default 8/6',
      ),
      DocsThemeField(
        name: 'maxHeight',
        type: 'double?',
        description: 'dialog height, default 349',
      ),
      DocsThemeField(
        name: 'maxWidth',
        type: 'double?',
        description: 'dialog width, default 512 (max-w-lg)',
      ),
      DocsThemeField(
        name: 'mutedForeground',
        type: 'ThemedColor?',
        description: 'secondary text',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'content padding, default 4',
      ),
      DocsThemeField(
        name: 'shadows',
        type: 'List<BoxShadow>?',
        description: 'surface shadows; empty draws none',
      ),
    ],
  ),
  'context_menu': DocsThemeTable(
    componentId: 'context_menu',
    themeClass: 'MenuTheme',
    themeDefaults: 'menuDefaults',
    userFile: 'menu/menu_theme.dart',
    userOwned: false,
    hasTheme: true,
    fields: <DocsThemeField>[],
  ),
  'dropdown_menu': DocsThemeTable(
    componentId: 'dropdown_menu',
    themeClass: 'MenuPopupTheme',
    themeDefaults: 'menuPopupDefaults',
    userFile: 'menu/menu_theme.dart',
    userOwned: false,
    hasTheme: true,
    fields: <DocsThemeField>[],
  ),
  'menu': DocsThemeTable(
    componentId: 'menu',
    themeClass: 'MenuTheme',
    themeDefaults: 'menuDefaults',
    userFile: 'menu_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state row fill; hovered/focused = accent',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = borderRadiusSm',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'StateValue<ThemedColor>?',
        description: 'per-state label/icon colour',
      ),
      DocsThemeField(
        name: 'itemPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = px-2 py-1.5',
      ),
      DocsThemeField(
        name: 'subMenuOffset',
        type: 'Offset?',
        description: 'submenu offset; null = Offset(8, -4)',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'label style; its colour is ignored',
      ),
    ],
  ),
  'menubar': DocsThemeTable(
    componentId: 'menubar',
    themeClass: 'MenubarTheme',
    themeDefaults: 'menubarDefaults',
    userFile: 'menu/menu_theme.dart',
    userOwned: false,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'bar fill; null = background',
      ),
      DocsThemeField(
        name: 'border',
        type: 'bool?',
        description: 'whether the bar draws its border; null = true',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'null = border',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = borderRadiusMd',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'null = 1.0',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = all 4',
      ),
      DocsThemeField(
        name: 'subMenuOffset',
        type: 'Offset?',
        description: 'null = Offset(-4, 8)',
      ),
    ],
  ),
  'breadcrumb': DocsThemeTable(
    componentId: 'breadcrumb',
    themeClass: 'BreadcrumbTheme',
    themeDefaults: 'breadcrumbDefaults',
    userFile: 'breadcrumb_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'strip padding',
      ),
      DocsThemeField(
        name: 'separator',
        type: 'Widget?',
        description: 'widget between crumbs, null = chevron',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap on each side of the separator',
      ),
    ],
  ),
  'navigation_bar': DocsThemeTable(
    componentId: 'navigation_bar',
    themeClass: 'NavigationBarTheme',
    themeDefaults: 'navigationBarDefaults',
    userFile: 'navigation_bar_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'activeItemStyle',
        type: 'NavigationItemStyle?',
        description: 'selected item slice',
      ),
      DocsThemeField(
        name: 'alignment',
        type: 'MainAxisAlignment?',
        description: 'bar distribution',
      ),
      DocsThemeField(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        description: 'container fill; bar/rail default to background',
      ),
      DocsThemeField(
        name: 'direction',
        type: 'Axis?',
        description: 'null resolves from the container type',
      ),
      DocsThemeField(
        name: 'itemStyle',
        type: 'NavigationItemStyle?',
        description: 'unselected item slice',
      ),
      DocsThemeField(
        name: 'labelPosition',
        type: 'NavigationLabelPosition?',
        description: 'bottom',
      ),
      DocsThemeField(
        name: 'labelSize',
        type: 'NavigationLabelSize?',
        description: 'small',
      ),
      DocsThemeField(
        name: 'labelType',
        type: 'NavigationLabelType?',
        description: 'sidebar defaults to expanded',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: '12x8',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'space between items, 8',
      ),
    ],
  ),
  'navigation_menu': DocsThemeTable(
    componentId: 'navigation_menu',
    themeClass: 'NavigationMenuTheme',
    themeDefaults: 'navigationMenuDefaults',
    userFile: 'navigation_menu_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'margin',
        type: 'EdgeInsetsGeometry?',
        description: 'margin around the popover, density gap',
      ),
      DocsThemeField(
        name: 'maxWidth',
        type: 'double?',
        description: 'maximum popover width, unconstrained',
      ),
      DocsThemeField(
        name: 'offset',
        type: 'Offset?',
        description: 'popover offset from the trigger, (0, 4)',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'padding inside the popover, density',
      ),
      DocsThemeField(
        name: 'surfaceBlur',
        type: 'double?',
        description: 'popover backdrop blur, ambient or 0',
      ),
      DocsThemeField(
        name: 'surfaceOpacity',
        type: 'double?',
        description: 'popover surface opacity, ambient or 1',
      ),
    ],
  ),
  'pagination': DocsThemeTable(
    componentId: 'pagination',
    themeClass: 'PaginationTheme',
    themeDefaults: 'paginationDefaults',
    userFile: 'pagination_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'gap between controls (× scaling)',
      ),
      DocsThemeField(
        name: 'showLabel',
        type: 'bool?',
        description: 'whether previous/next show a text label',
      ),
    ],
  ),
  'stepper': DocsThemeTable(
    componentId: 'stepper',
    themeClass: 'StepperTheme',
    themeDefaults: 'stepperDefaults',
    userFile: 'stepper_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'active',
        type: 'StepperIndicatorStyle?',
        description: 'the active step\'s ring',
      ),
      DocsThemeField(
        name: 'completed',
        type: 'StepperIndicatorStyle?',
        description: 'a finished step\'s ring',
      ),
      DocsThemeField(
        name: 'connectorColor',
        type: 'ThemedColor?',
        description: 'connector up to the active step',
      ),
      DocsThemeField(
        name: 'connectorPendingColor',
        type: 'ThemedColor?',
        description: 'connector after it',
      ),
      DocsThemeField(
        name: 'connectorThickness',
        type: 'double?',
        description: 'connector thickness, default 2',
      ),
      DocsThemeField(
        name: 'direction',
        type: 'Axis?',
        description: 'horizontal (default) or vertical',
      ),
      DocsThemeField(
        name: 'failed',
        type: 'StepperIndicatorStyle?',
        description: 'a step flagged failed',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'space around the indicator, default 8',
      ),
      DocsThemeField(
        name: 'pending',
        type: 'StepperIndicatorStyle?',
        description: 'a step after the active one',
      ),
      DocsThemeField(
        name: 'size',
        type: 'StepperSize?',
        description: 'indicator size, default md (40px circle)',
      ),
      DocsThemeField(
        name: 'titleStyle',
        type: 'TextStyle?',
        description: 'default is the size typography',
      ),
    ],
  ),
  'tabs': DocsThemeTable(
    componentId: 'tabs',
    themeClass: 'TabsTheme',
    themeDefaults: 'tabsDefaults',
    userFile: 'tabs_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'strip/tab radius, ambient radiusLg/Md',
      ),
      DocsThemeField(
        name: 'containerColor',
        type: 'StateValue<ThemedColor>?',
        description: 'strip fill, muted',
      ),
      DocsThemeField(
        name: 'containerPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'strip padding, all 3 (p-[3px])',
      ),
      DocsThemeField(
        name: 'labelColor',
        type: 'StateValue<ThemedColor>?',
        description: 'idle label, mutedForeground',
      ),
      DocsThemeField(
        name: 'selectedColor',
        type: 'StateValue<ThemedColor>?',
        description: 'selected tab fill, background',
      ),
      DocsThemeField(
        name: 'selectedLabelColor',
        type: 'StateValue<ThemedColor>?',
        description: 'selected label, foreground',
      ),
      DocsThemeField(
        name: 'tabPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'horizontal tab padding, px-2',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'label style, 14 w500',
      ),
    ],
  ),
  'alert_dialog': DocsThemeTable(
    componentId: 'alert_dialog',
    themeClass: 'AlertDialogTheme',
    themeDefaults: 'alertDialogDefaults',
    userFile: 'alert_dialog_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'actionGap',
        type: 'double?',
        description: '8, between footer actions',
      ),
      DocsThemeField(
        name: 'descriptionStyle',
        type: 'TextStyle?',
        description: '14px; colour falls back to mutedForeground',
      ),
      DocsThemeField(
        name: 'footerAlignment',
        type: 'MainAxisAlignment?',
        description: 'end',
      ),
      DocsThemeField(
        name: 'footerGap',
        type: 'double?',
        description: '24, between header and footer',
      ),
      DocsThemeField(
        name: 'headerGap',
        type: 'double?',
        description: '8, between title and description',
      ),
      DocsThemeField(
        name: 'iconColor',
        type: 'ThemedColor?',
        description: 'header icon colour, mutedForeground token',
      ),
      DocsThemeField(name: 'iconGap', type: 'double?', description: '16'),
      DocsThemeField(
        name: 'titleStyle',
        type: 'TextStyle?',
        description: '16px w600; colour falls back to foreground',
      ),
    ],
  ),
  'dialog': DocsThemeTable(
    componentId: 'dialog',
    themeClass: 'DialogTheme',
    themeDefaults: 'dialogDefaults',
    userFile: 'dialog_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'card token',
      ),
      DocsThemeField(
        name: 'barrierColor',
        type: 'ThemedColor?',
        description: 'black at 50%',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient radiusLg',
      ),
      DocsThemeField(name: 'borderWidth', type: 'double?', description: '1.0'),
      DocsThemeField(
        name: 'insetPadding',
        type: 'EdgeInsetsGeometry?',
        description:
            'screen edge inset, padSm x density content padding; zero when fullScreen',
      ),
      DocsThemeField(name: 'maxWidth', type: 'double?', description: '480.0'),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'card padding, padMd x density content padding',
      ),
      DocsThemeField(
        name: 'shadows',
        type: 'List<BoxShadow>?',
        description: 'ambient shadowLg',
      ),
      DocsThemeField(
        name: 'transitionDuration',
        type: 'Duration?',
        description: '150ms',
      ),
    ],
  ),
  'drawer': DocsThemeTable(
    componentId: 'drawer',
    themeClass: 'DrawerTheme',
    themeDefaults: 'drawerDefaults',
    userFile: 'drawer_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'panel fill (background)',
      ),
      DocsThemeField(
        name: 'barrierColor',
        type: 'ThemedColor?',
        description: 'barrier colour (black at 50%)',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'inner-edge border (border)',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadius?',
        description: 'inner-corner radius; null = ambient radiusLg',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: '0 hides the border',
      ),
      DocsThemeField(
        name: 'dragHandleColor',
        type: 'ThemedColor?',
        description: 'drag handle colour',
      ),
      DocsThemeField(
        name: 'dragHandleSize',
        type: 'Size?',
        description: 'drag handle size',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'ThemedColor?',
        description: 'panel content colour (foreground)',
      ),
      DocsThemeField(
        name: 'maxSize',
        type: 'double?',
        description: 'panel extent along the slide axis',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'panel padding',
      ),
      DocsThemeField(
        name: 'shadows',
        type: 'List<BoxShadow>?',
        description: 'null = ambient shadowLg, [] removes',
      ),
      DocsThemeField(
        name: 'showDragHandle',
        type: 'bool?',
        description: 'draw the drag handle',
      ),
      DocsThemeField(
        name: 'transitionDuration',
        type: 'Duration?',
        description: 'open/close transition',
      ),
    ],
  ),
  'gooey_toast': DocsThemeTable(
    componentId: 'gooey_toast',
    themeClass: 'GooeyToastTheme',
    themeDefaults: 'gooeyToastDefaults',
    userFile: 'gooey_toast_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'actionTone',
        type: 'ThemedColor?',
        description: 'action accent (#7A8DFF)',
      ),
      DocsThemeField(
        name: 'animationStyle',
        type: 'GooeyToastAnimationStyle?',
        description: 'open/close profile (sileo)',
      ),
      DocsThemeField(
        name: 'bodyAnimationStyle',
        type: 'GooeyToastBodyAnimationStyle?',
        description: 'body content profile (fade)',
      ),
      DocsThemeField(
        name: 'descriptionStyle',
        type: 'TextStyle?',
        description: 'expanded body text',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'default auto-dismiss (6s)',
      ),
      DocsThemeField(
        name: 'enableGooeyBlur',
        type: 'bool?',
        description: 'metaball blur pass (true)',
      ),
      DocsThemeField(
        name: 'errorTone',
        type: 'ThemedColor?',
        description: 'error accent (#EF5E5E)',
      ),
      DocsThemeField(
        name: 'fill',
        type: 'ThemedColor?',
        description: 'surface fill (#0D1117 by default)',
      ),
      DocsThemeField(
        name: 'infoTone',
        type: 'ThemedColor?',
        description: 'info accent (#6EA8FF)',
      ),
      DocsThemeField(
        name: 'loadingTone',
        type: 'ThemedColor?',
        description: 'loading accent (#8A8F98)',
      ),
      DocsThemeField(
        name: 'roundness',
        type: 'double?',
        description: 'base corner roundness before the shape style (18)',
      ),
      DocsThemeField(
        name: 'shapeStyle',
        type: 'GooeyToastShapeStyle?',
        description: 'corner profile (defaultShape)',
      ),
      DocsThemeField(
        name: 'successTone',
        type: 'ThemedColor?',
        description: 'success accent (#63C65E)',
      ),
      DocsThemeField(
        name: 'titleStyle',
        type: 'TextStyle?',
        description: 'compact label; null adds the state tone',
      ),
      DocsThemeField(
        name: 'warningTone',
        type: 'ThemedColor?',
        description: 'warning accent (#EABB4B)',
      ),
      DocsThemeField(
        name: 'width',
        type: 'double?',
        description: 'surface width (350)',
      ),
    ],
  ),
  'hover_card': DocsThemeTable(
    componentId: 'hover_card',
    themeClass: 'HoverCardTheme',
    themeDefaults: 'hoverCardDefaults',
    userFile: 'hover_card_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'anchorAlignment',
        type: 'AlignmentGeometry?',
        description: 'anchor edge; null = bottom-center',
      ),
      DocsThemeField(
        name: 'behavior',
        type: 'HitTestBehavior?',
        description: 'anchor hit-testing; null = deferToChild',
      ),
      DocsThemeField(
        name: 'debounce',
        type: 'Duration?',
        description: 'hide delay after the pointer leaves; null = 500 ms',
      ),
      DocsThemeField(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        description: 'card placement; null = top-center',
      ),
      DocsThemeField(
        name: 'popoverOffset',
        type: 'Offset?',
        description: 'gap between anchor and card; null = Offset(0, 8)',
      ),
      DocsThemeField(
        name: 'wait',
        type: 'Duration?',
        description: 'show delay after the pointer enters; null = 500 ms',
      ),
    ],
  ),
  'popup': DocsThemeTable(
    componentId: 'popup',
    themeClass: 'MenuPopupTheme',
    themeDefaults: 'menuPopupDefaults',
    userFile: 'menu/menu_theme.dart',
    userOwned: false,
    hasTheme: true,
    fields: <DocsThemeField>[],
  ),
  'refresh_trigger': DocsThemeTable(
    componentId: 'refresh_trigger',
    themeClass: 'RefreshTriggerTheme',
    themeDefaults: 'refreshTriggerDefaults',
    userFile: 'refresh_trigger_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'completeDuration',
        type: 'Duration?',
        description: 'completion display time, 500ms',
      ),
      DocsThemeField(
        name: 'curve',
        type: 'Curve?',
        description: 'extent animation curve, easeOutSine',
      ),
      DocsThemeField(
        name: 'indicatorBuilder',
        type: 'RefreshIndicatorBuilder?',
        description: 'custom indicator, default pill',
      ),
      DocsThemeField(
        name: 'maxExtent',
        type: 'double?',
        description: 'maximum pull distance, 150',
      ),
      DocsThemeField(
        name: 'minExtent',
        type: 'double?',
        description: 'pull distance arming the refresh, 75',
      ),
    ],
  ),
  'tooltip': DocsThemeTable(
    componentId: 'tooltip',
    themeClass: 'TooltipTheme',
    themeDefaults: 'tooltipDefaults',
    userFile: 'tooltip_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'surface fill; null = primary',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = borderRadiusSm',
      ),
      DocsThemeField(
        name: 'foreground',
        type: 'ThemedColor?',
        description: 'label colour; null = primaryForeground',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'null = density base gap at 0.75x',
      ),
      DocsThemeField(
        name: 'surfaceBlur',
        type: 'double?',
        description: 'null = the app theme\'s surfaceBlur',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'its colour is ignored (taken from foreground)',
      ),
    ],
  ),
  'code_snippet': DocsThemeTable(
    componentId: 'code_snippet',
    themeClass: 'CodeSnippetTheme',
    themeDefaults: 'codeSnippetDefaults',
    userFile: 'code_snippet_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'container fill, card token',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'border color, border token',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = ambient radiusLg',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'scaled border width, 1',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'density padding, wider on the right',
      ),
    ],
  ),
  'image': DocsThemeTable(
    componentId: 'image',
    themeClass: 'ImageTheme',
    themeDefaults: 'imageDefaults',
    userFile: 'image_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'background',
        type: 'ThemedColor?',
        description: 'fill behind the image and the default placeholder',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = radiusLg',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'fade-in of the decoded picture; default 150ms',
      ),
    ],
  ),
  'markdown': DocsThemeTable(
    componentId: 'markdown',
    themeClass: 'MarkdownTheme',
    themeDefaults: 'markdownDefaults',
    userFile: 'markdown_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(name: 'blockSpacing', type: 'double?', description: '6'),
      DocsThemeField(
        name: 'codeBackgroundColor',
        type: 'ThemedColor?',
        description: 'foreground at 7%',
      ),
      DocsThemeField(
        name: 'codeStyle',
        type: 'TextStyle?',
        description: 'code shape; family falls back to fontMono',
      ),
      DocsThemeField(
        name: 'heading1Style',
        type: 'TextStyle?',
        description: '28px w800',
      ),
      DocsThemeField(
        name: 'heading2Style',
        type: 'TextStyle?',
        description: '23px w800',
      ),
      DocsThemeField(
        name: 'heading3Style',
        type: 'TextStyle?',
        description: '20px w700',
      ),
      DocsThemeField(
        name: 'heading4Style',
        type: 'TextStyle?',
        description: '18px w700',
      ),
      DocsThemeField(
        name: 'heading5Style',
        type: 'TextStyle?',
        description: '16px w700',
      ),
      DocsThemeField(
        name: 'heading6Style',
        type: 'TextStyle?',
        description: '14px w700',
      ),
      DocsThemeField(
        name: 'horizontalRuleColor',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(
        name: 'linkColor',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'linkStyle',
        type: 'TextStyle?',
        description: 'link shape; color falls back to linkColor',
      ),
      DocsThemeField(
        name: 'quoteBorderColor',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(
        name: 'style',
        type: 'TextStyle?',
        description: 'body shape; color falls back to foreground',
      ),
      DocsThemeField(
        name: 'tableBorderColor',
        type: 'ThemedColor?',
        description: 'border token',
      ),
      DocsThemeField(
        name: 'tableHeaderBackgroundColor',
        type: 'ThemedColor?',
        description: 'muted at 50%',
      ),
      DocsThemeField(
        name: 'tableHeaderStyle',
        type: 'TextStyle?',
        description: 'table header shape',
      ),
    ],
  ),
  'alpha': DocsThemeTable(
    componentId: 'alpha',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'anchor': DocsThemeTable(
    componentId: 'anchor',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'app': DocsThemeTable(
    componentId: 'app',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'async': DocsThemeTable(
    componentId: 'async',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'backdrop_transform': DocsThemeTable(
    componentId: 'backdrop_transform',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'color': DocsThemeTable(
    componentId: 'color',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'color_field': DocsThemeTable(
    componentId: 'color_field',
    themeClass: 'ColorFieldTheme',
    themeDefaults: 'colorFieldDefaults',
    userFile: 'color_field_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'ring colour, border token by default',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null = ambient radiusMd',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: '1 by default, 0 hides the ring',
      ),
      DocsThemeField(
        name: 'checkerboard',
        type: 'bool?',
        description: 'transparency checkerboard, true by default',
      ),
    ],
  ),
  'color_input': DocsThemeTable(
    componentId: 'color_input',
    themeClass: 'ColorInputTheme',
    themeDefaults: 'colorInputDefaults',
    userFile: 'color_input_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'enableEyeDropper',
        type: 'bool?',
        description: 'picker screen sampling, true by default',
      ),
      DocsThemeField(
        name: 'gap',
        type: 'double?',
        description: 'gap between the well and the hex field, 8 by default',
      ),
      DocsThemeField(
        name: 'mode',
        type: 'PromptMode?',
        description: 'popover at 768px+ (desktop), dialog below',
      ),
      DocsThemeField(
        name: 'pickerMode',
        type: 'ColorPickerMode?',
        description: 'channel mode the picker opens in, rgb by default',
      ),
      DocsThemeField(
        name: 'popoverAlignment',
        type: 'AlignmentGeometry?',
        description: 'popover placement, top-left by default',
      ),
      DocsThemeField(
        name: 'popoverAnchorAlignment',
        type: 'AlignmentGeometry?',
        description: 'popover anchor edge, bottom-left by default',
      ),
      DocsThemeField(
        name: 'popoverPadding',
        type: 'EdgeInsetsGeometry?',
        description: 'popover inner padding, 16 by default',
      ),
      DocsThemeField(
        name: 'showAlpha',
        type: 'bool?',
        description: 'picker alpha editing, true by default',
      ),
      DocsThemeField(
        name: 'showHistory',
        type: 'bool?',
        description: 'picker history toggle, true by default',
      ),
      DocsThemeField(
        name: 'swatchBorderColor',
        type: 'ThemedColor?',
        description: 'well border, the border token',
      ),
      DocsThemeField(
        name: 'swatchBorderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'well corner radius, ambient radiusMd',
      ),
      DocsThemeField(
        name: 'swatchSize',
        type: 'double?',
        description: 'colour well edge, 36 by default',
      ),
    ],
  ),
  'drawer_container': DocsThemeTable(
    componentId: 'drawer_container',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'error_system': DocsThemeTable(
    componentId: 'error_system',
    themeClass: 'ErrorSystemTheme',
    themeDefaults: 'errorSystemDefaults',
    userFile: 'error_system_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'bannerBackground',
        type: 'ThemedColor?',
        description: 'card token',
      ),
      DocsThemeField(
        name: 'bannerBorder',
        type: 'ThemedColor?',
        description: 'destructive token',
      ),
      DocsThemeField(
        name: 'bannerPadding',
        type: 'EdgeInsetsGeometry?',
        description: '16/12',
      ),
      DocsThemeField(
        name: 'cardPadding',
        type: 'EdgeInsetsGeometry?',
        description: '24',
      ),
      DocsThemeField(
        name: 'iconColor',
        type: 'ThemedColor?',
        description: 'destructive token',
      ),
      DocsThemeField(name: 'iconSize', type: 'double?', description: '36'),
      DocsThemeField(
        name: 'messageStyle',
        type: 'TextStyle?',
        description: '14; colour falls back to mutedForeground',
      ),
      DocsThemeField(
        name: 'titleStyle',
        type: 'TextStyle?',
        description: '16/w600; colour falls back to foreground',
      ),
    ],
  ),
  'eye_dropper': DocsThemeTable(
    componentId: 'eye_dropper',
    themeClass: 'EyeDropperTheme',
    themeDefaults: 'eyeDropperDefaults',
    userFile: 'eye_dropper_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        description: 'preview backing, background token by default',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'preview ring, border token by default',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: 'ring width, 1 by default',
      ),
      DocsThemeField(
        name: 'previewScale',
        type: 'double?',
        description: 'magnification, 8 by default',
      ),
      DocsThemeField(
        name: 'previewSize',
        type: 'Size?',
        description: 'magnified preview size, 100x100 by default',
      ),
      DocsThemeField(
        name: 'selectedBorderColor',
        type: 'ThemedColor?',
        description: 'centre cell highlight, primary by default',
      ),
      DocsThemeField(
        name: 'selectedBorderWidth',
        type: 'double?',
        description: 'centre highlight width, 2 by default',
      ),
      DocsThemeField(
        name: 'showPreview',
        type: 'bool?',
        description: 'show the preview at all, true by default',
      ),
    ],
  ),
  'formatter': DocsThemeTable(
    componentId: 'formatter',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'group': DocsThemeTable(
    componentId: 'group',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'history': DocsThemeTable(
    componentId: 'history',
    themeClass: 'HistoryTheme',
    themeDefaults: 'historyDefaults',
    userFile: 'history_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'null resolves radiusMd',
      ),
      DocsThemeField(
        name: 'selectedBorder',
        type: 'ThemedColor?',
        description: 'selection ring colour',
      ),
      DocsThemeField(
        name: 'selectedBorderWidth',
        type: 'double?',
        description: 'ring width, default 2',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between swatches',
      ),
      DocsThemeField(
        name: 'tileSize',
        type: 'double?',
        description: 'swatch edge length',
      ),
    ],
  ),
  'hsl': DocsThemeTable(
    componentId: 'hsl',
    themeClass: 'HSLSliderTheme',
    themeDefaults: 'hslSliderDefaults',
    userFile: 'hsl_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'cursorColor',
        type: 'ThemedColor?',
        description: 'cursor ring colour (default white)',
      ),
      DocsThemeField(
        name: 'cursorSize',
        type: 'double?',
        description: 'cursor diameter',
      ),
      DocsThemeField(
        name: 'cursorWidth',
        type: 'double?',
        description: 'ring width',
      ),
      DocsThemeField(
        name: 'slider',
        type: 'HSLSliderStyle?',
        description: 'cursor styling',
      ),
    ],
  ),
  'hsv': DocsThemeTable(
    componentId: 'hsv',
    themeClass: 'HSVSliderTheme',
    themeDefaults: 'hsvSliderDefaults',
    userFile: 'hsv_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'cursorColor',
        type: 'ThemedColor?',
        description: 'cursor ring colour (default white)',
      ),
      DocsThemeField(
        name: 'cursorSize',
        type: 'double?',
        description: 'cursor diameter',
      ),
      DocsThemeField(
        name: 'cursorWidth',
        type: 'double?',
        description: 'ring width',
      ),
      DocsThemeField(
        name: 'slider',
        type: 'HSVSliderStyle?',
        description: 'cursor styling',
      ),
    ],
  ),
  'icon': DocsThemeTable(
    componentId: 'icon',
    themeClass: 'IconContainerTheme',
    themeDefaults: 'iconContainerDefaults',
    userFile: 'icon_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient radiusMd',
      ),
      DocsThemeField(
        name: 'iconColor',
        type: 'ThemedColor?',
        description: 'primaryForeground token',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'padXs x container density',
      ),
    ],
  ),
  'locale_utils': DocsThemeTable(
    componentId: 'locale_utils',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'media_query': DocsThemeTable(
    componentId: 'media_query',
    themeClass: 'MediaQueryVisibilityTheme',
    themeDefaults: 'mediaQueryVisibilityDefaults',
    userFile: 'media_query_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'maxWidth',
        type: 'double?',
        description: 'widest inclusive width that shows the child',
      ),
      DocsThemeField(
        name: 'minWidth',
        type: 'double?',
        description: 'narrowest inclusive width that shows the child',
      ),
    ],
  ),
  'multiple_choice': DocsThemeTable(
    componentId: 'multiple_choice',
    themeClass: 'MultipleChoiceTheme',
    themeDefaults: 'multipleChoiceDefaults / multipleAnswerDefaults',
    userFile: 'multiple_choice_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'allowUnselect',
        type: 'bool?',
        description: 're-selecting the current item clears/toggles it',
      ),
    ],
  ),
  'outlined_container': DocsThemeTable(
    componentId: 'outlined_container',
    themeClass: 'OutlinedContainerTheme',
    themeDefaults: 'outlinedContainerDefaults',
    userFile: 'outlined_container_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'backgroundColor',
        type: 'ThemedColor?',
        description: 'background token',
      ),
      DocsThemeField(
        name: 'borderColor',
        type: 'ThemedColor?',
        description: 'muted token',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadiusGeometry?',
        description: 'ambient borderRadiusXl',
      ),
      DocsThemeField(
        name: 'borderStyle',
        type: 'BorderStyle?',
        description: 'solid',
      ),
      DocsThemeField(
        name: 'borderWidth',
        type: 'double?',
        description: '1 times ambient scaling',
      ),
      DocsThemeField(
        name: 'boxShadow',
        type: 'List<BoxShadow>?',
        description: 'none',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description: 'zero',
      ),
      DocsThemeField(
        name: 'surfaceBlur',
        type: 'double?',
        description: 'backdrop blur sigma; null draws none',
      ),
      DocsThemeField(
        name: 'surfaceOpacity',
        type: 'double?',
        description: 'multiplies the fill alpha',
      ),
    ],
  ),
  'overlay_configuration': DocsThemeTable(
    componentId: 'overlay_configuration',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'page_route': DocsThemeTable(
    componentId: 'page_route',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'patch': DocsThemeTable(
    componentId: 'patch',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'scrollable': DocsThemeTable(
    componentId: 'scrollable',
    themeClass: 'ScrollableTheme',
    themeDefaults: 'scrollableDefaults',
    userFile: 'scrollable_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'fadeExtent',
        type: 'double?',
        description: '20, scroll distance to full fade',
      ),
      DocsThemeField(
        name: 'fadeSize',
        type: 'double?',
        description: '50, gradient length',
      ),
    ],
  ),
  'scrollable_client': DocsThemeTable(
    componentId: 'scrollable_client',
    themeClass: 'ScrollableClientTheme',
    themeDefaults: 'scrollableClientDefaults',
    userFile: 'scrollable_client_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'clipBehavior',
        type: 'Clip?',
        description: 'hardEdge',
      ),
      DocsThemeField(
        name: 'diagonalDragBehavior',
        type: 'DiagonalDragBehavior?',
        description: 'none',
      ),
      DocsThemeField(
        name: 'dragStartBehavior',
        type: 'DragStartBehavior?',
        description: 'start',
      ),
      DocsThemeField(
        name: 'hitTestBehavior',
        type: 'HitTestBehavior?',
        description: 'opaque',
      ),
      DocsThemeField(
        name: 'keyboardDismissBehavior',
        type: 'ScrollViewKeyboardDismissBehavior?',
        description: 'manual',
      ),
      DocsThemeField(name: 'overscroll', type: 'bool?', description: 'false'),
    ],
  ),
  'scrollview': DocsThemeTable(
    componentId: 'scrollview',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'selectable': DocsThemeTable(
    componentId: 'selectable',
    themeClass: 'SelectableTextTheme',
    themeDefaults: 'selectableDefaults',
    userFile: 'selectable_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'cursorColor',
        type: 'ThemedColor?',
        description: 'primary token',
      ),
      DocsThemeField(
        name: 'cursorHeight',
        type: 'double?',
        description: 'line height',
      ),
      DocsThemeField(
        name: 'cursorRadius',
        type: 'Radius?',
        description: 'square',
      ),
      DocsThemeField(name: 'cursorWidth', type: 'double?', description: '2'),
      DocsThemeField(
        name: 'enableInteractiveSelection',
        type: 'bool?',
        description: 'true',
      ),
      DocsThemeField(
        name: 'selectionHeightStyle',
        type: 'BoxHeightStyle?',
        description: 'tight',
      ),
      DocsThemeField(
        name: 'selectionWidthStyle',
        type: 'BoxWidthStyle?',
        description: 'tight',
      ),
      DocsThemeField(
        name: 'textStyle',
        type: 'TextStyle?',
        description: 'merged under widget style',
      ),
    ],
  ),
  'spell_check_suggestions_toolbar': DocsThemeTable(
    componentId: 'spell_check_suggestions_toolbar',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'stage_container': DocsThemeTable(
    componentId: 'stage_container',
    themeClass: 'StageContainerTheme',
    themeDefaults: 'stageContainerDefaults',
    userFile: 'stage_container_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'breakpoint',
        type: 'StageBreakpoint?',
        description: 'width strategy; null = defaultBreakpoints',
      ),
      DocsThemeField(
        name: 'padding',
        type: 'EdgeInsetsGeometry?',
        description:
            'base outer padding; a density-aware value scales with the preset',
      ),
    ],
  ),
  'swiper': DocsThemeTable(
    componentId: 'swiper',
    themeClass: 'SwiperTheme',
    themeDefaults: 'swiperDefaults',
    userFile: 'swiper_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'barrierColor',
        type: 'ThemedColor?',
        description: 'barrier colour; null is black at 50%',
      ),
      DocsThemeField(
        name: 'barrierDismissible',
        type: 'bool?',
        description: 'barrier tap dismisses the panel',
      ),
      DocsThemeField(
        name: 'behavior',
        type: 'HitTestBehavior?',
        description: 'hit test behaviour of the swipe gesture',
      ),
      DocsThemeField(
        name: 'borderRadius',
        type: 'BorderRadius?',
        description: 'panel inner-corner radius; null keeps DrawerTheme',
      ),
      DocsThemeField(
        name: 'draggable',
        type: 'bool?',
        description: 'the open panel can be dragged away',
      ),
      DocsThemeField(
        name: 'expands',
        type: 'bool?',
        description: 'panel fills its slide axis (drawer: false, sheet: true)',
      ),
      DocsThemeField(
        name: 'maxSize',
        type: 'double?',
        description:
            'panel extent along its slide axis; null keeps DrawerTheme',
      ),
      DocsThemeField(
        name: 'showDragHandle',
        type: 'bool?',
        description: 'draw the panel drag handle; null keeps DrawerTheme',
      ),
      DocsThemeField(
        name: 'threshold',
        type: 'double?',
        description: 'fraction (0..1) of the panel a release must pass to open',
      ),
      DocsThemeField(
        name: 'useSafeArea',
        type: 'bool?',
        description: 'panel respects the device safe area',
      ),
    ],
  ),
  'switcher': DocsThemeTable(
    componentId: 'switcher',
    themeClass: 'SwitcherTheme',
    themeDefaults: 'switcherDefaults',
    userFile: 'switcher_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'curve',
        type: 'Curve?',
        description: 'snap-back curve; default Curves.easeInOut',
      ),
      DocsThemeField(
        name: 'duration',
        type: 'Duration?',
        description: 'snap-back duration; default 150ms',
      ),
    ],
  ),
  'timeline_animation': DocsThemeTable(
    componentId: 'timeline_animation',
    themeClass: '',
    themeDefaults: '',
    userFile: '',
    userOwned: false,
    hasTheme: false,
    fields: <DocsThemeField>[],
  ),
  'triple_dots': DocsThemeTable(
    componentId: 'triple_dots',
    themeClass: 'TripleDotsTheme',
    themeDefaults: 'tripleDotsDefaults',
    userFile: 'triple_dots_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'color',
        type: 'ThemedColor?',
        description: 'mutedForeground token',
      ),
      DocsThemeField(
        name: 'size',
        type: 'double?',
        description: 'dot diameter, null = 4 * scaling',
      ),
      DocsThemeField(
        name: 'spacing',
        type: 'double?',
        description: 'gap between dots, 2',
      ),
    ],
  ),
  'window': DocsThemeTable(
    componentId: 'window',
    themeClass: 'WindowTheme',
    themeDefaults: 'windowDefaults',
    userFile: 'window_theme.dart',
    userOwned: true,
    hasTheme: true,
    fields: <DocsThemeField>[
      DocsThemeField(
        name: 'resizeThickness',
        type: 'double?',
        description: 'edge grab thickness, 8 by default',
      ),
      DocsThemeField(
        name: 'snapOverlayBlur',
        type: 'double?',
        description: 'preview backdrop blur, 8 by default',
      ),
      DocsThemeField(
        name: 'snapOverlayColor',
        type: 'ThemedColor?',
        description: 'snap preview fill, card by default',
      ),
      DocsThemeField(
        name: 'snapOverlayOpacity',
        type: 'double?',
        description: '0.8 by default',
      ),
      DocsThemeField(
        name: 'titleBarHeight',
        type: 'double?',
        description: '32 by default (scaled)',
      ),
      DocsThemeField(
        name: 'titleBarPadding',
        type: 'EdgeInsetsGeometry?',
        description: '8 horizontal by default',
      ),
      DocsThemeField(
        name: 'titleColor',
        type: 'ThemedColor?',
        description: 'title colour, foreground by default',
      ),
    ],
  ),
};
