// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:flutter/material.dart' hide TextField;
import 'package:intl/intl.dart';

import '../number_ticker/number_ticker.dart';
import '../../../shared/theme/theme.dart';
import '../../form/text_field/text_field.dart';

part '_number_ticker_preview_state.dart';

/// Core class used by the number ticker component.
class NumberTickerPreview extends StatefulWidget {
  const NumberTickerPreview({super.key});

  /// Creates the State object used by this number ticker widget.
  @override
  State<NumberTickerPreview> createState() => _NumberTickerPreviewState();
}
