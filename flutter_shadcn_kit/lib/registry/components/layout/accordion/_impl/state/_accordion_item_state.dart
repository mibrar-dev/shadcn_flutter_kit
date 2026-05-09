// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../accordion.dart';

/// _AccordionItemState defines a reusable type for this registry module.
class _AccordionItemState extends State<AccordionItem>
    with SingleTickerProviderStateMixin {
  /// Stores `accordion` state/configuration for this implementation.
  AccordionState? accordion;
  final ValueNotifier<bool> _expanded = ValueNotifier(false);

  /// Stores `_controller` state/configuration for this implementation.
  late AnimationController _controller;

  /// Stores `_easeInAnimation` state/configuration for this implementation.
  late CurvedAnimation _easeInAnimation;

  /// Stores `_theme` state/configuration for this implementation.
  AccordionTheme? _theme;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _expanded.value = widget.expanded;
    _controller = AnimationController(vsync: this);
    _updateAnimations();
  }

  /// Executes `_updateAnimations` behavior for this component/composite.
  void _updateAnimations() {
    _controller.duration =
        _theme?.duration ?? const Duration(milliseconds: 200);
    _controller.value = _expanded.value ? 1 : 0;
    _easeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: _theme?.curve ?? Curves.easeIn,
      reverseCurve: _theme?.reverseCurve ?? Curves.easeOut,
    );
  }

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newAccordion = Data.of<AccordionState>(context);
    if (newAccordion != accordion) {
      accordion?._expanded.removeListener(_onExpandedChanged);
      newAccordion._expanded.addListener(_onExpandedChanged);
      accordion = newAccordion;
    }

    final theme = ComponentTheme.maybeOf<AccordionTheme>(context);
    if (_theme != theme) {
      _theme = theme;
      _updateAnimations();
    }

    if (accordion != null &&
        accordion!._expanded.value == null &&
        widget.expanded) {
      accordion!._expanded.value = this;
    }
    _onExpandedChanged();
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _controller.dispose();
    accordion?._expanded.removeListener(_onExpandedChanged);
    super.dispose();
  }

  /// Executes `_onExpandedChanged` behavior for this component/composite.
  void _onExpandedChanged() {
    /// Stores `shouldBeExpanded` state/configuration for this implementation.
    final shouldBeExpanded = accordion?._expanded.value == this;
    if (_expanded.value != shouldBeExpanded) {
      /// Creates a `setState` instance.
      setState(() {
        _expanded.value = shouldBeExpanded;
        if (shouldBeExpanded) {
          _expand();
        } else {
          _collapse();
        }
      });
    }
  }

  /// Executes `_expand` behavior for this component/composite.
  void _expand() {
    _controller.forward();
    _expanded.value = true;
  }

  /// Executes `_collapse` behavior for this component/composite.
  void _collapse() {
    _controller.reverse();
    _expanded.value = false;
  }

  /// Executes `_dispatchToggle` behavior for this component/composite.
  void _dispatchToggle() {
    if (accordion?._expanded.value == this) {
      accordion?._expanded.value = null;
    } else {
      accordion?._expanded.value = this;
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;

    return Data.inherit(
      data: this,
      child: GestureDetector(
        child: Column(
          children: [
            widget.trigger,

            /// Creates a `SizeTransition` instance.
            SizeTransition(
              key: const ValueKey('accordion_size_transition'),
              sizeFactor: _easeInAnimation,
              axisAlignment: -1,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      _theme?.padding ??
                      theme.density.baseContentPadding * scaling,
                ),
                child: widget.content,
              ).small().normal(),
            ),
          ],
        ),
      ),
    );
  }
}
