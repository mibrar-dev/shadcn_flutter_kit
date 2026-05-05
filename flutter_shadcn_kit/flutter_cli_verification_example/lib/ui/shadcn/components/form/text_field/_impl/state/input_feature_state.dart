part of '../../text_field.dart';

/// Abstract base state class for input features.
///
/// Manages the lifecycle and state of features that extend text field
/// functionality, such as clear buttons, counters, or custom decorations.
abstract class InputFeatureState<T extends InputFeature> {
  /// Field storing `_attached` for this form implementation.
  _AttachedInputFeature? _attached;

  /// Field storing `_inputState` for this form implementation.
  TextFieldState? _inputState;

  /// The input feature associated with this state.
  T get feature {
    assert(
      _attached != null && _attached!.feature is T,
      'Feature not attached',
    );
    return _attached!.feature as T;
  }

  /// The ticker provider for animations.
  TickerProvider get tickerProvider {
    var inputState = _inputState;
    assert(inputState != null, 'Feature not attached');
    return inputState!;
  }

  /// The build context for this feature.
  BuildContext get context {
    var inputState = _inputState;
    assert(inputState != null, 'Feature not attached');

    final context = inputState!.editableTextKey.currentContext;
    if (context == null) {
      throw FlutterError(
        'InputFeatureState.context was accessed but editableTextKey.currentContext is null.\n'
        'This usually means the widget is not mounted. Ensure the widget is mounted before accessing context.',
      );
    }
    return context;
  }

  /// The parent text field widget.
  TextField get input {
    var inputState = _inputState;
    assert(inputState != null, 'Feature not attached');
    return inputState!.widget;
  }

  /// Whether this feature is currently attached to a text field.
  bool get attached => _attached != null;

  /// The text editing controller for the text field.
  TextEditingController get controller {
    var inputState = _inputState;
    assert(inputState != null, 'Feature not attached');
    return inputState!.effectiveController;
  }

  /// Controller used to coordinate `_visibilityController` behavior.
  late AnimationController _visibilityController;

  Iterable<Widget> _internalBuildLeading() sync* {
    if (_visibilityController.value == 0) {
      return;
    }
    for (final widget in buildLeading()) {
      yield Hidden(
        hidden: _visibilityController.value < 1,
        duration: kDefaultDuration,
        child: widget,
      );
    }
  }

  Iterable<Widget> _internalBuildTrailing() sync* {
    if (_visibilityController.value == 0) {
      return;
    }
    for (final widget in buildTrailing()) {
      yield Hidden(
        hidden: _visibilityController.value < 1,
        duration: kDefaultDuration,
        child: widget,
      );
    }
  }

  /// Initializes this feature state.
  ///
  /// Called when the feature is first attached to a text field.
  void initState() {
    _visibilityController = AnimationController(
      vsync: tickerProvider,
      duration: kDefaultDuration,
    );
    _visibilityController.value = feature.visibility.canShow(_inputState!)
        ? 1
        : 0;
    _visibilityController.addListener(_updateAnimation);
    for (var dependency in feature.visibility.getDependencies(_inputState!)) {
      dependency.addListener(_updateVisibility);
    }
  }

  /// Called when dependencies change.
  ///
  /// Override to respond to dependency changes in the widget tree.
  void didChangeDependencies() {}

  /// Performs `_updateAnimation` logic for this form component.
  void _updateAnimation() {
    /// Triggers a rebuild after mutating local state.
    setState(() {});
  }

  /// Performs `_updateVisibility` logic for this form component.
  void _updateVisibility() {
    bool canShow = feature.visibility.canShow(_inputState!);
    if (canShow && _visibilityController.value == 1) return;
    if (!canShow && _visibilityController.value == 0) return;
    if (canShow) {
      _visibilityController.forward();
    } else {
      _visibilityController.reverse();
    }
  }

  /// Disposes resources used by this feature state.
  ///
  /// Called when the feature is detached from the text field.
  void dispose() {
    _visibilityController.dispose();
    for (var dependency in feature.visibility.getDependencies(_inputState!)) {
      dependency.removeListener(_updateVisibility);
    }
  }

  /// Called when the feature is updated.
  ///
  /// Override to respond to feature configuration changes.
  void didFeatureUpdate(InputFeature oldFeature) {
    if (oldFeature.visibility != feature.visibility) {
      for (var oldDependency in oldFeature.visibility.getDependencies(
        _inputState!,
      )) {
        oldDependency.removeListener(_updateVisibility);
      }
      for (var newDependency in feature.visibility.getDependencies(
        _inputState!,
      )) {
        newDependency.addListener(_updateVisibility);
      }
    }
  }

  /// Called when the text field's text changes.
  ///
  /// Override to respond to text changes.
  void onTextChanged(String text) {}

  /// Called when the text field's selection changes.
  ///
  /// Override to respond to selection changes.
  void onSelectionChanged(TextSelection selection) {}

  /// Builds leading widgets for the text field.
  ///
  /// Override to provide widgets shown before the input.
  Iterable<Widget> buildLeading() sync* {}

  /// Builds trailing widgets for the text field.
  ///
  /// Override to provide widgets shown after the input.
  Iterable<Widget> buildTrailing() sync* {}

  /// Builds actions for keyboard shortcuts.
  ///
  /// Override to provide custom actions.
  Iterable<MapEntry<Type, Action<Intent>>> buildActions() sync* {}

  /// Builds keyboard shortcuts.
  ///
  /// Override to provide custom keyboard shortcuts.
  Iterable<MapEntry<ShortcutActivator, Intent>> buildShortcuts() sync* {}

  /// Wraps the text field widget.
  ///
  /// Override to wrap the field with additional widgets.
  Widget wrap(Widget child) => child;

  /// Intercepts and modifies the text field configuration.
  ///
  /// Override to modify the text field before rendering.
  TextField interceptInput(TextField input) => input;

  /// Triggers a state update for the attached text field.
  ///
  /// Parameters:
  /// - [fn] (`VoidCallback`, required): State update callback.
  ///
  /// Throws: AssertionError if feature is not attached.
  void setState(VoidCallback fn) {
    assert(attached, 'Feature not attached');
    _inputState!._setStateFeature(fn);
  }
}
