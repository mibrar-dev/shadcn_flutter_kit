// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../filter_bar.dart';

/// Type alias for `FilterBarClearResolver` used by public or internal APIs.
typedef FilterBarClearResolver = FilterState Function(FilterState current);

/// Type alias for `FilterStateChanged` used by public or internal APIs.
typedef FilterStateChanged = void Function(FilterState next);

/// Type alias for `FilterCustomFilterBuilder` used by public or internal APIs.
typedef FilterCustomFilterBuilder =
    Widget Function(
      BuildContext context,
      FilterState state,
      FilterStateChanged onStateChanged,
    );

/// Type alias for `FilterTypedCustomFilterBuilder` used by public or internal APIs.
typedef FilterTypedCustomFilterBuilder<T> =
    Widget Function(BuildContext context, T? value, ValueChanged<T?> onChanged);

/// Type alias for `FilterSheetItemBuilder` used by public or internal APIs.
typedef FilterSheetItemBuilder =
    Widget Function(
      BuildContext context,
      FilterState state,
      FilterStateChanged onStateChanged,
    );

/// FilterBarPresentation defines a reusable type for this registry module.
enum FilterBarPresentation { autoSheet, inline, sheet }

@immutable
/// FilterCustomFilter defines a reusable type for this registry module.
class FilterCustomFilter {
  /// Stores `id` state/configuration for this implementation.
  final String id;

  /// Stores `builder` state/configuration for this implementation.
  final FilterCustomFilterBuilder builder;

  const FilterCustomFilter({required this.id, required this.builder});

  /// Executes `typed` behavior for this component/composite.
  static FilterCustomFilter typed<T>({
    required FilterField<T> field,
    required FilterTypedCustomFilterBuilder<T> builder,
  }) {
    return FilterCustomFilter(
      id: field.id,
      builder: (context, state, onStateChanged) {
        return builder(context, state.valueOf<T>(field), (next) {
          onStateChanged(state.setValue<T>(field, next));
        });
      },
    );
  }
}

@immutable
/// FilterGroup defines a reusable type for this registry module.
class FilterGroup {
  /// Stores `id` state/configuration for this implementation.
  final String id;

  /// Stores `title` state/configuration for this implementation.
  final String title;

  /// Stores `filterIds` state/configuration for this implementation.
  final List<String> filterIds;

  /// Stores `itemBuilder` state/configuration for this implementation.
  final FilterSheetItemBuilder? itemBuilder;

  /// Creates a `FilterGroup` instance.
  const FilterGroup({
    required this.id,
    required this.title,
    this.filterIds = const [],
    this.itemBuilder,
  });
}

/// FilterBarSheetScaffold defines a reusable type for this registry module.
class FilterBarSheetScaffold extends StatelessWidget {
  /// Creates a `FilterBarSheetScaffold` instance.
  const FilterBarSheetScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
    this.footer,
    this.maxHeight = 560,
    this.contentPadding,
  });

  /// Stores `title` state/configuration for this implementation.
  final String title;

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `onClose` state/configuration for this implementation.
  final VoidCallback? onClose;

  /// Stores `footer` state/configuration for this implementation.
  final Widget? footer;

  /// Stores `maxHeight` state/configuration for this implementation.
  final double maxHeight;

  /// Stores `contentPadding` state/configuration for this implementation.
  final EdgeInsetsGeometry? contentPadding;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.card,
          border: Border.all(color: theme.colorScheme.border),
          borderRadius: BorderRadius.circular(16 * scaling),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.foreground.withOpacity(0.08),
              blurRadius: 24 * scaling,
              offset: Offset(0, 10 * scaling),
            ),
          ],
        ),
        padding: contentPadding ?? EdgeInsets.all(16 * scaling),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight * scaling),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: theme.typography.large)),
                  GhostButton(
                    onPressed: onClose ?? () => closeSheet(context),
                    size: ButtonSize.small,
                    child: const Icon(LucideIcons.x),
                  ),
                ],
              ),
              SizedBox(height: 12 * scaling),
              Flexible(child: SingleChildScrollView(child: child)),
              if (footer != null) ...[SizedBox(height: 12 * scaling), footer!],
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
/// FilterBarStyle defines a reusable type for this registry module.
class FilterBarStyle {
  /// Stores `spacing` state/configuration for this implementation.
  final double spacing;

  /// Stores `runSpacing` state/configuration for this implementation.
  final double runSpacing;

  /// Stores `minSearchWidth` state/configuration for this implementation.
  final double minSearchWidth;

  /// Stores `minSortWidth` state/configuration for this implementation.
  final double minSortWidth;

  /// Stores `dense` state/configuration for this implementation.
  final bool dense;

  /// Creates a `FilterBarStyle` instance.
  const FilterBarStyle({
    this.spacing = 12,
    this.runSpacing = 8,
    this.minSearchWidth = 220,
    this.minSortWidth = 180,
    this.dense = false,
  });

  /// Creates a `FilterBarStyle` instance.
  FilterBarStyle copyWith({
    double? spacing,
    double? runSpacing,
    double? minSearchWidth,
    double? minSortWidth,
    bool? dense,
  }) {
    return FilterBarStyle(
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      minSearchWidth: minSearchWidth ?? this.minSearchWidth,
      minSortWidth: minSortWidth ?? this.minSortWidth,
      dense: dense ?? this.dense,
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterBarStyle &&
        other.spacing == spacing &&
        other.runSpacing == runSpacing &&
        other.minSearchWidth == minSearchWidth &&
        other.minSortWidth == minSortWidth &&
        other.dense == dense;
  }

  @override
  int get hashCode =>
      Object.hash(spacing, runSpacing, minSearchWidth, minSortWidth, dense);
}
