// Shared select machinery for the `select` and `multi_select` components:
// the selection-state data type, the single-selection defaults, a selectable
// row (on the shared menu row) and the popup body with its search query and
// async row resolution.
//
// Layer-clean by design: nothing here imports a component. The `select`
// component supplies the menu surface and the input search field through
// builders, so this primitive stays usable by any picker at layer 2.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../foundation/icons/lucide_icons.dart';
import 'menu_rows.dart';

/// The selection state option rows read: enabled flag, whether any value is
/// selected (reserves the check gutter) and the selection test/callback.
typedef SelectData = ({
  bool enabled,
  bool hasSelection,
  bool Function(Object? test) isSelected,
  void Function(Object? value, bool selected) onChanged,
});

/// Single-selection mapping: picking selects the item, deselecting clears it.
T? singleSelectionHandler<T>(T? oldValue, Object? item, bool selected) {
  if (item is! T?) {
    return oldValue;
  }
  return selected ? item : null;
}

/// Single-selection test: the value equals the tested item.
bool singleSelectionPredicate<T>(T? value, Object? test) => value == test;

/// One selectable row: a [RovingRow] with the optional trailing check
/// indicator (shadcn reserves the gutter whenever something is selected).
///
/// Place it inside a `MenuGroup`; the row joins that group's traversal and
/// paints the shared menu row hover/focus highlight.
class SelectRow extends StatelessWidget {
  /// Creates a select row.
  const SelectRow({
    super.key,
    required this.child,
    this.selected = false,
    this.reserveIndicator = false,
    this.enabled = true,
    this.onPressed,
    this.padding,
    this.minHeight = 32,
  });

  /// Row content.
  final Widget child;

  /// Whether the check indicator is shown.
  final bool selected;

  /// Whether the check gutter is reserved while [selected] is false.
  final bool reserveIndicator;

  /// Whether the row can be activated.
  final bool enabled;

  /// Called on tap and on Enter/Space while focused.
  final VoidCallback? onPressed;

  /// Row padding; null resolves the menu row default (px-2 py-1.5).
  final EdgeInsetsGeometry? padding;

  /// Minimum row height.
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final Widget? indicator = selected
        ? const Icon(LucideIcons.check, size: 16)
        : (reserveIndicator ? const SizedBox(width: 16, height: 16) : null);
    return RovingRow(
      enabled: enabled,
      onPressed: enabled ? onPressed : null,
      padding: padding,
      minHeight: minHeight,
      trailing: indicator,
      child: child,
    );
  }
}

/// Wraps the popup body (search field + rows) in the caller's surface.
typedef SelectPopupSurfaceBuilder =
    Widget Function(BuildContext context, Widget content);

/// Builds the search field; receives the popup's own text controller.
typedef SelectPopupSearchBuilder =
    Widget Function(BuildContext context, TextEditingController controller);

/// Builds the popup rows for a search query (null when the query is empty).
typedef SelectPopupItemsBuilder =
    FutureOr<List<Widget>> Function(BuildContext context, String? query);

/// The body of a select popup: resolves the row widgets for the current
/// search query and lays them out inside [surface].
///
/// [searchField] enables the query field (and the query passed to
/// [builder]); [spacer] is inserted between the field and the rows. The
/// surface and search field are builders so this widget stays at layer 2.
class SelectPopupBody extends StatefulWidget {
  /// Creates a popup body.
  const SelectPopupBody({
    super.key,
    required this.surface,
    this.searchField,
    this.spacer,
    this.items,
    this.builder,
    this.emptyBuilder,
    this.constraints,
  });

  /// Wraps the resolved content in the component's surface.
  final SelectPopupSurfaceBuilder surface;

  /// Builds the search field; null hides it and disables the search query.
  final SelectPopupSearchBuilder? searchField;

  /// Inserted between the search field and the rows.
  final Widget? spacer;

  /// Static rows; ignored when [builder] is set.
  final FutureOr<List<Widget>>? items;

  /// Builds the rows for a search query; enables the query when set.
  final SelectPopupItemsBuilder? builder;

  /// Shown when the resolved row list is empty; defaults to a 48px spacer.
  final WidgetBuilder? emptyBuilder;

  /// Size constraints; defaults to 192-320 wide and 240 high.
  final BoxConstraints? constraints;

  @override
  State<SelectPopupBody> createState() => _SelectPopupBodyState();
}

class _SelectPopupBodyState extends State<SelectPopupBody> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool searching = widget.searchField != null;
    return ConstrainedBox(
      constraints:
          widget.constraints ??
          const BoxConstraints(minWidth: 192, maxWidth: 320, maxHeight: 240),
      child: widget.surface(
        context,
        ListenableBuilder(
          listenable: _search,
          builder: (context, _) {
            final String? query = searching && _search.text.isNotEmpty
                ? _search.text
                : null;
            final FutureOr<List<Widget>> resolved = widget.builder != null
                ? widget.builder!(context, query)
                : widget.items ?? const <Widget>[];
            if (resolved is Future<List<Widget>>) {
              return FutureBuilder<List<Widget>>(
                future: resolved,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                    ? const SizedBox(height: 48)
                    : _resolve(searching, snapshot.data ?? const <Widget>[]),
              );
            }
            return _resolve(searching, resolved);
          },
        ),
      ),
    );
  }

  /// The search field (optional) plus the resolved rows.
  Widget _resolve(bool searching, List<Widget> rows) {
    final Widget resolvedRows = rows.isEmpty
        ? widget.emptyBuilder?.call(context) ?? const SizedBox(height: 48)
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows,
          );
    if (!searching) {
      return resolvedRows;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        widget.searchField!(context, _search),
        ?widget.spacer,
        resolvedRows,
      ],
    );
  }
}
