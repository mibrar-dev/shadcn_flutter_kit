// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// A low-level sortable list widget with customizable rendering.
///
/// Provides the foundation for building sortable lists with custom item
/// rendering and change tracking. Use this when you need fine-grained control
/// over the sortable list behavior.
///
/// **Work in Progress** — like upstream, [build] throws [UnimplementedError].
/// The delegate/change-tracking model ([SortableListDelegate], [ListChanges])
/// is fully ported and usable; pair it with the registry `layout/sortable`
/// drag-and-drop system for rendering until this widget is implemented.
///
/// Upstream parity: ported from `sortable.dart` upstream.
class RawSortableList<T> extends StatelessWidget {
  /// The delegate that provides item data.
  final SortableListDelegate<T> delegate;

  /// Builder for creating item widgets.
  final SortableWidgetBuilder<T> builder;

  /// Callback invoked when the list order changes.
  ///
  /// Receives a [ListChanges] object containing all modifications.
  final ValueChanged<ListChanges<T>>? onChanged;

  /// Whether the list accepts reordering interactions.
  final bool enabled;

  /// Creates a [RawSortableList].
  ///
  /// Parameters:
  /// - [delegate] (`SortableListDelegate<T>`, required): Provides item data.
  /// - [builder] (`SortableWidgetBuilder<T>`, required): Builds item widgets.
  /// - [onChanged] (`ValueChanged<ListChanges<T>>?`, optional): Change callback.
  /// - [enabled] (`bool`, default: `true`): Whether reordering is enabled.
  const RawSortableList({
    super.key,
    required this.delegate,
    required this.builder,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
