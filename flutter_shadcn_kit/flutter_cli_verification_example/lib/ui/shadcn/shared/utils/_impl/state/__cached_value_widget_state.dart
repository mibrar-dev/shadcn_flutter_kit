// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../util.dart';

/// _CachedValueWidgetState defines a reusable type for this registry module.
class _CachedValueWidgetState<T> extends State<CachedValueWidget<T>> {
  /// Stores `_cachedWidget` state/configuration for this implementation.
  Widget? _cachedWidget;

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant CachedValueWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (T is CachedValue) {
      if ((widget.value as CachedValue).shouldRebuild(
        oldWidget.value as CachedValue,
      )) {
        _cachedWidget = null;
      }
    } else {
      if (widget.value != oldWidget.value) {
        _cachedWidget = null;
      }
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    _cachedWidget ??= widget.builder(context, widget.value);
    return _cachedWidget!;
  }
}
