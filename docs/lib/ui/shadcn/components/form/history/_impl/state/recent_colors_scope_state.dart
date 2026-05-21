// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../history.dart';

/// State class for [RecentColorsScope] implementing color history storage.
///
/// Manages the list of recently used colors and provides storage functionality
/// for color history tracking.
class RecentColorsScopeState extends State<RecentColorsScope>
    implements ColorHistoryStorage {
  late _ColorListNotifier _recentColors;

  @override
  int get capacity => widget.maxRecentColors;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _recentColors = _ColorListNotifier(List.from(widget.initialRecentColors));
  }

  @override
  List<Color> get recentColors =>
      List.unmodifiable(_recentColors._recentColors);

  /// Performs `addHistory` logic for this form component.
  @override
  void addHistory(Color color) {
    var recentColors = _recentColors._recentColors;
    if (recentColors.contains(color)) {
      recentColors.remove(color);
    }
    recentColors.insert(0, color);
    if (recentColors.length > widget.maxRecentColors) {
      recentColors.removeLast();
    }
    widget.onRecentColorsChanged?.call(recentColors);
    _recentColors._notify();
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    super.dispose();
    _recentColors.dispose();
  }

  /// Performs `clear` logic for this form component.
  @override
  void clear() {
    _recentColors._recentColors.clear();
    widget.onRecentColorsChanged?.call(recentColors);
    _recentColors._notify();
  }

  /// Performs `setHistory` logic for this form component.
  @override
  void setHistory(List<Color> colors) {
    _recentColors._recentColors = colors;
    widget.onRecentColorsChanged?.call(recentColors);
    _recentColors._notify();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return ForwardableData<ColorHistoryStorage>(
      data: this,
      child: Data<ColorHistoryStorage>.inherit(data: this, child: widget.child),
    );
  }

  /// Performs `addListener` logic for this form component.
  @override
  void addListener(VoidCallback listener) {
    _recentColors.addListener(listener);
  }

  /// Performs `removeListener` logic for this form component.
  @override
  void removeListener(VoidCallback listener) {
    _recentColors.removeListener(listener);
  }
}
