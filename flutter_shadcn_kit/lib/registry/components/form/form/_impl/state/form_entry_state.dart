// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// State class for [FormEntry] widgets.
///
/// Manages form field lifecycle and integrates with parent [FormController]
/// for validation and value reporting.
class FormEntryState extends State<FormEntry> with FormFieldHandle {
  /// Controller used to coordinate `_controller` behavior.
  FormController? _controller;

  /// Current value stored for `_cachedValue`.
  _FormEntryCachedValue? _cachedValue;
  final ValueNotifier<ValidationResult?> _validity = ValueNotifier(null);

  /// Field storing `formKey` for this form implementation.
  @override
  FormKey get formKey => widget.key;

  /// Field storing `validity` for this form implementation.
  @override
  ValueListenable<ValidationResult?>? get validity => _validity;

  /// Field storing `_toWaitCounter` for this form implementation.
  int _toWaitCounter = 0;

  /// Field storing `_toWait` for this form implementation.
  FutureOr<ValidationResult?>? _toWait;

  /// Updates derived state when inherited dependencies change.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var oldController = _controller;
    var newController = Data.maybeOf<FormController>(context);
    if (oldController != newController) {
      oldController?.removeListener(_onControllerChanged);
      // oldController?.detach(this);
      _controller = newController;
      _onControllerChanged();
      newController?.addListener(_onControllerChanged);
      // Always attach so validator-only fields are still tracked when value is
      // currently null.
      newController?.attach(
        context,
        this,
        _cachedValue?.value,
        widget.validator,
      );
    }
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _controller?.removeListener(_onControllerChanged);
    // _controller?.detach(this);
    super.dispose();
  }

  /// Performs `_onControllerChanged` logic for this form component.
  void _onControllerChanged() {
    var validityFuture = _controller?.getError(widget.key);
    if (validityFuture == _toWait) {
      return;
    }
    _toWait = validityFuture;
    int counter = ++_toWaitCounter;
    if (_toWait is Future<ValidationResult?>) {
      (_toWait as Future<ValidationResult?>).then((value) {
        if (counter == _toWaitCounter) {
          _validity.value = value;
        }
      });
    } else {
      _validity.value = _toWait as ValidationResult?;
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Data<FormFieldHandle>.inherit(data: this, child: widget.child);
  }

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    bool isSameType = widget.key.type == T;
    if (!isSameType) {
      var parentLookup = Data.maybeFind<FormFieldHandle>(context);
      assert(parentLookup != this, 'FormEntry cannot be its own parent');
      return parentLookup?.reportNewFormValue<T>(value);
    }
    var cachedValue = _cachedValue;
    if (cachedValue != null && cachedValue.value == value) {
      return _validity.value;
    }
    _cachedValue = _FormEntryCachedValue(value);
    return _controller?.attach(context, this, value, widget.validator);
  }

  /// Performs `revalidate` logic for this form component.
  @override
  FutureOr<ValidationResult?> revalidate() {
    return _controller?.attach(
      context,
      this,
      _cachedValue?.value,
      widget.validator,
      true,
    );
  }
}
