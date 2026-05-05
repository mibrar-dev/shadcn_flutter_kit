import 'dart:async';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

part '_impl/core/__form_entry_cached_value.dart';
part '_impl/core/form_key.dart';
part '_impl/core/replace_result.dart';
part '_impl/core/validation_result.dart';

/// Defines when form field validation should occur during the component lifecycle.
enum FormValidationMode {
  initial,
  changed,
  submitted,
}

/// A key that uniquely identifies a form field and its type.
