// The bridge between an [EditableTextHost]-based widget state and the
// [InputFeatureState] contract features build against.
//
// Field components mix [InputFeatureHostState] into their state and provide
// the host, the slot store and the password override; every other member of
// the feature contract is derived here.

import 'package:flutter/widgets.dart';

import '../text_editing/editable_text_host.dart';
import 'input_features.dart';

/// Implements [InputFeatureState] over an [EditableTextHost]-based state.
mixin InputFeatureHostState<T extends StatefulWidget> on State<T>
    implements InputFeatureState {
  /// The editing host of this field.
  EditableTextHost get editingHost;

  /// Per-feature slots of this field.
  InputFeatureSlots get featureSlots;

  /// The password-feature override, or null for the widget value.
  bool? get obscureOverride;

  /// Assigns the password override (and rebuilds).
  void setObscureOverride(bool? value);

  /// The widget's own obscure flag.
  bool get widgetObscureText;

  @override
  BuildContext get featureContext => context;

  @override
  TextEditingController get controller => editingHost.controller;

  @override
  String get text => editingHost.controller.text;

  @override
  TextSelection get selection => editingHost.controller.selection;

  @override
  bool get focused => editingHost.focusNode.hasFocus;

  @override
  bool get hovered => editingHost.states.value.contains(WidgetState.hovered);

  @override
  bool get obscureText => obscureOverride ?? widgetObscureText;

  @override
  void setObscureText(bool? value) => setObscureOverride(value);

  @override
  void setFeatureState(VoidCallback fn) => setState(fn);

  @override
  T2 slot<T2 extends Object>(InputFeature feature, T2 Function() create) =>
      featureSlots.slot(feature, create);

  @override
  Object? featureSlotOf(InputFeature feature) => featureSlots.slotOf(feature);
}
