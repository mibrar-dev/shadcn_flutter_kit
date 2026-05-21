// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../accordion.dart';

/// _AccordionTriggerState defines a reusable type for this registry module.
class _AccordionTriggerState extends State<AccordionTrigger> {
  /// Stores `_expanded` state/configuration for this implementation.
  bool _expanded = false;

  /// Stores `_hovering` state/configuration for this implementation.
  bool _hovering = false;

  /// Stores `_focusing` state/configuration for this implementation.
  bool _focusing = false;

  /// Stores `_item` state/configuration for this implementation.
  _AccordionItemState? _item;

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newItem = Data.of<_AccordionItemState>(context);
    if (newItem != _item) {
      _item?._expanded.removeListener(_onExpandedChanged);
      newItem._expanded.addListener(_onExpandedChanged);
      _item = newItem;
    }
  }

  /// Executes `_onExpandedChanged` behavior for this component/composite.
  void _onExpandedChanged() {
    if (_expanded != (_item?._expanded.value ?? false)) {
      /// Creates a `setState` instance.
      setState(() {
        _expanded = _item?._expanded.value ?? false;
      });
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _item?._expanded.removeListener(_onExpandedChanged);
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accTheme = ComponentTheme.maybeOf<AccordionTheme>(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;

    final arrowColor =
        accTheme?.arrowIconColor ?? theme.colorScheme.mutedForeground;
    final baseIconSize =
        theme.iconTheme.medium.size ??
        theme.iconTheme.small.size ??
        theme.iconTheme.xSmall.size ??
        (20 * scaling);

    final tween = _expanded
        ? Tween<double>(begin: 1.0, end: 0.0)
        : Tween<double>(begin: 0.0, end: 1.0);

    return GestureDetector(
      onTap: _item?._dispatchToggle,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (value) {
          /// Creates a `setState` instance.
          setState(() {
            _focusing = value;
          });
        },
        onShowHoverHighlight: (value) {
          /// Creates a `setState` instance.
          setState(() {
            _hovering = value;
          });
        },
        shortcuts: const {
          /// Creates a `SingleActivator` instance.
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),

          /// Creates a `SingleActivator` instance.
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction(
            onInvoke: (intent) {
              _item?._dispatchToggle();
              return true;
            },
          ),
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _focusing
                  ? theme.colorScheme.ring
                  : theme.colorScheme.ring.withAlpha(0),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(theme.radiusXs),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical:
                  accTheme?.padding ??
                  theme.density.baseContentPadding * scaling,
            ),
            child: Row(
              children: [
                /// Creates a `Expanded` instance.
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        decoration: _hovering
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),

                /// Creates a `SizedBox` instance.
                SizedBox(
                  width:
                      accTheme?.iconGap ??
                      theme.density.baseContentPadding * scaling * 1.125,
                ),
                TweenAnimationBuilder<double>(
                  tween: tween,
                  duration: accTheme?.duration ?? kDefaultDuration,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * pi,
                      child: IconTheme(
                        data: IconThemeData(
                          color: arrowColor,
                          size: baseIconSize,
                        ),
                        child: Icon(
                          accTheme?.arrowIcon ?? Icons.keyboard_arrow_up,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ).medium().small(),
        ),
      ),
    );
  }
}
