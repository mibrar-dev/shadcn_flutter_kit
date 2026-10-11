// The `history` component: recently-used colour storage plus the grid widget
// that shows it. Widgets-only; storage is exposed through foundation/data.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../alpha/alpha.dart';
import '../button/button.dart';
import 'history_style.dart';

export 'history_style.dart';

/// In-memory store of recently used colours, listenable for changes.
///
/// Provide one with [RecentColorsScope], then read it with
/// [ColorHistoryStorage.of] from a builder below the scope.
abstract class ColorHistoryStorage implements Listenable {
  /// Adds [color] to the front of the history (most-recent first).
  ///
  /// A colour already present moves to the front instead of duplicating.
  void addHistory(Color color);

  /// Replaces the whole history (clamped to [capacity]).
  void setHistory(List<Color> colors);

  /// Removes every colour.
  void clear();

  /// Maximum number of stored colours.
  int get capacity;

  /// Colours, most-recent first.
  List<Color> get recentColors;

  /// The nearest storage above [context]; throws when absent.
  static ColorHistoryStorage of(BuildContext context) {
    final found =
        Data.maybeFind<ColorHistoryStorage>(context) ??
        Data.maybeFindMessenger<ColorHistoryStorage>(context);
    if (found == null) {
      throw FlutterError(
        'No ColorHistoryStorage found in context. Wrap the tree with '
        'a RecentColorsScope.',
      );
    }
    return found;
  }
}

/// Provides a [ColorHistoryStorage] to descendants.
class RecentColorsScope extends StatefulWidget {
  /// Creates a scope.
  const RecentColorsScope({
    super.key,
    this.initialRecentColors = const <Color>[],
    this.maxRecentColors = 50,
    this.onRecentColorsChanged,
    required this.child,
  });

  /// Seed colours.
  final List<Color> initialRecentColors;

  /// Maximum stored colours.
  final int maxRecentColors;

  /// Called whenever the list changes.
  final ValueChanged<List<Color>>? onRecentColorsChanged;

  /// Content below the scope.
  final Widget child;

  @override
  State<RecentColorsScope> createState() => RecentColorsScopeState();
}

/// Thin [ChangeNotifier] subclass so the state can hold it by composition.
class _ChangeNotifierBox extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// State of [RecentColorsScope], itself the storage implementation.
class RecentColorsScopeState extends State<RecentColorsScope>
    implements ColorHistoryStorage {
  final List<Color> _recentColors = <Color>[];
  final _ChangeNotifierBox _notifier = _ChangeNotifierBox();

  @override
  void initState() {
    super.initState();
    _recentColors.addAll(
      widget.initialRecentColors.take(widget.maxRecentColors),
    );
  }

  @override
  int get capacity => widget.maxRecentColors;

  @override
  List<Color> get recentColors => List<Color>.unmodifiable(_recentColors);

  @override
  void addHistory(Color color) {
    final value = color.toARGB32();
    _recentColors.removeWhere((c) => c.toARGB32() == value);
    _recentColors.insert(0, color);
    if (_recentColors.length > capacity) {
      _recentColors.removeRange(capacity, _recentColors.length);
    }
    widget.onRecentColorsChanged?.call(recentColors);
    _notifier.notify();
  }

  @override
  void clear() {
    _recentColors.clear();
    widget.onRecentColorsChanged?.call(recentColors);
    _notifier.notify();
  }

  @override
  void setHistory(List<Color> colors) {
    _recentColors
      ..clear()
      ..addAll(colors.take(capacity));
    widget.onRecentColorsChanged?.call(recentColors);
    _notifier.notify();
  }

  @override
  void addListener(VoidCallback listener) => _notifier.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _notifier.removeListener(listener);

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Data<ColorHistoryStorage>.inherit(data: this, child: widget.child);
  }
}

/// Grid view over a [ColorHistoryStorage].
class ColorHistoryGrid extends StatelessWidget {
  /// Creates the grid.
  const ColorHistoryGrid({
    super.key,
    required this.storage,
    this.onColorPicked,
    this.spacing,
    this.crossAxisCount = 10,
    this.selectedColor,
    this.maxTotalColors,
    this.theme,
  }) : assert(crossAxisCount > 0);

  /// Backing storage.
  final ColorHistoryStorage storage;

  /// Called when a swatch is tapped.
  final ValueChanged<Color>? onColorPicked;

  /// Gap between swatches; null uses the theme default.
  final double? spacing;

  /// Swatches per row.
  final int crossAxisCount;

  /// Colour highlighted with the selection ring.
  final Color? selectedColor;

  /// Caps the number of rendered slots.
  final int? maxTotalColors;

  /// Widget-leg theme override.
  final HistoryTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcn = ShadcnTheme.of(context);
    final HistoryTheme resolved =
        resolveComponentStyle<HistoryTheme, HistoryTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: historyDefaults,
        );
    final double gap = spacing ?? resolved.spacing ?? 4;
    final double tile = resolved.tileSize ?? 32;
    final BorderRadiusGeometry radius =
        resolved.borderRadius ?? shadcn.borderRadiusMd;
    final Color ringColor =
        resolved.selectedBorder?.resolve(shadcn.colors) ??
        shadcn.colors.primary;
    final double ringWidth = resolved.selectedBorderWidth ?? 2;

    Widget tileFor(Color? color) {
      if (color == null) {
        return SizedBox(width: tile, height: tile);
      }
      final bool selected =
          selectedColor != null &&
          selectedColor!.toARGB32() == color.toARGB32();
      return SizedBox(
        width: tile,
        height: tile,
        child: Button(
          variant: ButtonVariant.outline,
          size: ButtonSize.icon,
          onPressed: () => onColorPicked?.call(color),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: selected
                  ? Border.all(color: ringColor, width: ringWidth)
                  : null,
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  const CustomPaint(painter: AlphaPainter()),
                  ColoredBox(color: color),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: ListenableBuilder(
        listenable: storage,
        builder: (context, _) {
          final rows = <Widget>[];
          for (
            int i = 0;
            i < storage.capacity &&
                (maxTotalColors == null || i < maxTotalColors!);
            i += crossAxisCount
          ) {
            final tiles = <Widget>[];
            for (int j = 0; j < crossAxisCount; j++) {
              final index = i + j;
              final Color? color = index < storage.recentColors.length
                  ? storage.recentColors[index]
                  : null;
              final bool inRange =
                  index < storage.capacity &&
                  (maxTotalColors == null || index < maxTotalColors!);
              tiles.add(
                inRange ? tileFor(color) : SizedBox(width: tile, height: tile),
              );
              if (j < crossAxisCount - 1) {
                tiles.add(Gap(gap));
              }
            }
            rows.add(
              IntrinsicHeight(
                child: Row(mainAxisSize: MainAxisSize.min, children: tiles),
              ),
            );
            if (i + crossAxisCount < storage.capacity &&
                (maxTotalColors == null ||
                    i + crossAxisCount < maxTotalColors!)) {
              rows.add(Gap(gap));
            }
          }
          return IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rows,
            ),
          );
        },
      ),
    );
  }
}
