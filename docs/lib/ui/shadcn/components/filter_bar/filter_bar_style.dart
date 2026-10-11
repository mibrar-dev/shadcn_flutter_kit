// Registry-owned logic for the `filter_bar` component: [FilterBarTheme] and
// its token-derived `filterBarDefaults`, the presentation enum, the custom
// filter descriptor, the sheet chrome and the control sub-widgets (search,
// sort, date, clear, sheet trigger).
//
// The flat component folder puts the old `filter_bar_style.dart` here (its
// `FilterBarSheetScaffold` was public there too); the value engine lives in
// `primitives/filter_core/`. User-owned overrides live in
// `filter_bar_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/filter_core/filter_state.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../primitives/input_features/adornment_features.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../date_picker/date_picker.dart';
import '../input/input.dart';
import '../select/select.dart';

export '../../primitives/filter_core/filter_group.dart';
export '../../primitives/filter_core/filter_theme.dart';

/// How a `FilterBar` presents its controls.
enum FilterBarPresentation { inline, sheet, autoSheet }

/// Resolves the next state when "clear all" runs.
typedef FilterBarClearResolver = FilterState Function(FilterState current);

/// The search field of a `FilterBar` (leading icon + clear action).
class FilterBarSearchField extends StatelessWidget {
  /// Creates the search field.
  const FilterBarSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.width = 220,
  });

  /// Owns the query text.
  final TextEditingController controller;

  /// Called on every edit (the bar debounces it).
  final ValueChanged<String> onChanged;

  /// Fixed field width.
  final double width;

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    return SizedBox(
      width: width,
      child: Semantics(
        textField: true,
        label: l10n.filterSearch,
        child: Input(
          controller: controller,
          placeholder: Text(l10n.filterSearch),
          onChanged: onChanged,
          // v5 keeps the h-9 box: the leading icon (24) plus the default v8
          // padding would measure 40+.
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          features: const [
            InputLeadingFeature(Icon(LucideIcons.search)),
            InputClearFeature(),
          ],
        ),
      ),
    );
  }
}

/// The sort dropdown of a `FilterBar`.
class FilterBarSortControl extends StatelessWidget {
  /// Creates the sort control.
  const FilterBarSortControl({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.width = 180,
  });

  /// Selected option id, or null.
  final String? value;

  /// Options offered by the dropdown.
  final List<FilterSortOption> options;

  /// Called with the next option id (null clears the sort).
  final ValueChanged<String?> onChanged;

  /// Fixed control width.
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Select<String>(
        value: value,
        onChanged: onChanged,
        placeholder: Text(ShadcnLocalizations.of(context).filterSort),
        itemBuilder: (context, value) => Text(_label(value)),
        items: <Widget>[
          for (final FilterSortOption option in options)
            SelectItem<String>(value: option.id, child: Text(option.label)),
        ],
      ),
    );
  }

  String _label(String id) {
    for (final FilterSortOption option in options) {
      if (option.id == id) {
        return option.label;
      }
    }
    return id;
  }
}

/// The date-range control of a `FilterBar` (popover editor).
class FilterBarDateControl extends StatelessWidget {
  /// Creates the date control.
  const FilterBarDateControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 180,
  });

  /// Selected span, or null.
  final FilterDateRange? value;

  /// Called with the next span (null clears it).
  final ValueChanged<FilterDateRange?> onChanged;

  /// Fixed control width.
  final double width;

  @override
  Widget build(BuildContext context) {
    final FilterDateRange? range = value;
    // h-9 like every other control: the ObjectFormField trigger's own
    // padding/minHeight would otherwise measure 54. A fixed box height, the
    // border-box metric the `button` size table also keeps as a literal
    // (h-9 = 36), so it is deliberately NOT density-scaled; only padding is.
    return SizedBox(
      width: width,
      height: 36,
      child: DateRangePicker(
        value: range == null
            ? null
            : DateTimeRange(
                range.start ?? range.end!,
                range.end ?? range.start!,
              ),
        mode: PromptMode.popover,
        placeholder: Text(ShadcnLocalizations.of(context).filterDateRange),
        onChanged: (DateTimeRange? next) => onChanged(
          next == null
              ? null
              : FilterDateRange(start: next.start, end: next.end),
        ),
      ),
    );
  }
}

/// The clear-all action of a `FilterBar`.
class FilterBarClearButton extends StatelessWidget {
  /// Creates the clear button.
  const FilterBarClearButton({
    super.key,
    required this.enabled,
    required this.onPressed,
    this.dense = false,
  });

  /// Whether the action is active.
  final bool enabled;

  /// Called when pressed.
  final VoidCallback onPressed;

  /// Compact size.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Button(
      variant: ButtonVariant.ghost,
      size: dense ? ButtonSize.sm : ButtonSize.md,
      onPressed: enabled ? onPressed : null,
      child: Text(ShadcnLocalizations.of(context).filterClearAll),
    );
  }
}

/// The sheet trigger of a `FilterBar` (label plus active-filter count).
class FilterBarSheetTrigger extends StatelessWidget {
  /// Creates the sheet trigger.
  const FilterBarSheetTrigger({
    super.key,
    required this.activeCount,
    required this.onPressed,
    this.dense = false,
  });

  /// Number of active filters, appended to the label when non-zero.
  final int activeCount;

  /// Opens the sheet.
  final VoidCallback onPressed;

  /// Compact size.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final String label = ShadcnLocalizations.of(context).filterFilters;
    return Button(
      variant: ButtonVariant.secondary,
      size: dense ? ButtonSize.sm : ButtonSize.md,
      onPressed: onPressed,
      leading: const Icon(LucideIcons.slidersHorizontal),
      child: Text(activeCount == 0 ? label : '$label ($activeCount)'),
    );
  }
}

/// The card used inside the mobile filter sheet.
///
/// Public because the old `filter_bar_style.dart` exposed it and apps may
/// reuse the sheet chrome; `FilterBar` builds it internally.
class FilterBarSheetScaffold extends StatelessWidget {
  /// Creates a sheet scaffold.
  const FilterBarSheetScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
    this.footer,
    this.maxHeight = 560,
    this.contentPadding,
  });

  /// Sheet title.
  final String title;

  /// Sheet body.
  final Widget child;

  /// Called by the close button; null hides it.
  final VoidCallback? onClose;

  /// Optional footer pinned below the body.
  final Widget? footer;

  /// Maximum card height before the body scrolls.
  final double maxHeight;

  /// Padding around the body.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final double scale = ambient.scaling;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(ambient.spacing.sm),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: ambient.colors.card,
            border: Border.all(color: ambient.colors.border),
            borderRadius: ambient.borderRadiusXl,
            boxShadow: ambient.tokens.shadows.shadowLg,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight * scale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    ambient.spacing.md,
                    ambient.spacing.sm,
                    ambient.spacing.sm,
                    ambient.spacing.sm,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          style: ambient.typography.large.copyWith(
                            color: ambient.colors.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (onClose != null)
                        Button(
                          variant: ButtonVariant.ghost,
                          size: ButtonSize.icon,
                          onPressed: onClose,
                          child: const Icon(LucideIcons.x),
                        ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding:
                        contentPadding ??
                        // Flush under the title row (it already carries the
                        // `sm` bottom), so the top inset is a deliberate 0.
                        EdgeInsetsDirectional.fromSTEB(
                          ambient.spacing.md,
                          0,
                          ambient.spacing.md,
                          ambient.spacing.md,
                        ),
                    child: child,
                  ),
                ),
                if (footer != null)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      // Flush under the scrolling body (it already carries the
                      // `md` bottom), so the top inset is a deliberate 0.
                      ambient.spacing.md,
                      0,
                      ambient.spacing.md,
                      ambient.spacing.md,
                    ),
                    child: footer,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
