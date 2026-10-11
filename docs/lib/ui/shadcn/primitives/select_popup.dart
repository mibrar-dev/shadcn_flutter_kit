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
import '../theme/density.dart';
import '../theme/theme.dart';
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
/// paints the shared menu row hover/focus highlight. Plain-text labels stay
/// on one line (`maxLines: 1`, ellipsis) so the popup grows to the widest
/// option instead of wrapping per character; the viewport is the only cap.
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

  /// Row padding; null resolves the menu row default (shadcn `px-2 py-1.5`)
  /// against the ambient density.
  final EdgeInsetsGeometry? padding;

  /// Minimum row height.
  final double minHeight;

  /// Default row padding for a selectable row: shadcn `px-2 py-1.5`, as
  /// density multipliers resolved at build.
  static const EdgeInsetsGeometry defaultRowPadding =
      EdgeInsetsDensity.pxSymmetric(horizontal: 8, vertical: 6);

  @override
  Widget build(BuildContext context) {
    // 16 is shadcn `size-4`: the fixed box the check glyph and its reserved
    // gutter live in, not spacing.
    final Widget? indicator = selected
        ? const Icon(LucideIcons.check, size: 16)
        : (reserveIndicator ? const SizedBox(width: 16, height: 16) : null);
    // A select row owns its padding, so it resolves the density multipliers
    // here (theme-free primitive, no component import).
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return RovingRow(
      enabled: enabled,
      onPressed: enabled ? onPressed : null,
      padding: resolveEdgeInsets(
        padding ?? defaultRowPadding,
        theme.density.baseContentPadding * theme.scaling,
      ),
      minHeight: minHeight,
      trailing: indicator,
      child: _singleLine(child),
    );
  }
}

/// Keeps a plain-text label on one line; rich content passes through (its
/// own widgets own their wrapping).
Widget _singleLine(Widget child) {
  if (child is! Text || child.data == null) return child;
  final Text text = child;
  if (text.maxLines == 1 &&
      text.overflow == TextOverflow.ellipsis &&
      text.softWrap == false) {
    return text;
  }
  return Text(
    text.data!,
    key: text.key,
    style: text.style,
    textAlign: text.textAlign,
    textDirection: text.textDirection,
    locale: text.locale,
    strutStyle: text.strutStyle,
    textWidthBasis: text.textWidthBasis,
    textHeightBehavior: text.textHeightBehavior,
    selectionColor: text.selectionColor,
    semanticsLabel: text.semanticsLabel,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
  );
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

  /// Size constraints; defaults to a 128 minimum width and 240 high. There
  /// is no maximum width: the popup hugs the widest option (never narrower
  /// than the trigger through the popover's anchor-minimum sizing) and the
  /// viewport caps it.
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
          const BoxConstraints(minWidth: 128, maxHeight: 240),
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
                    // Loading stub height: a layout cap, not padding.
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
    // The 48 empty/loading stub is a layout cap, not component padding.
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
