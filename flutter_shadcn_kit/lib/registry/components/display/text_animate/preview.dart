// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:flutter/material.dart' as m;
import '../../layout/flex/flex.dart';

import 'text_animate.dart';

part '_impl/state/_text_animate_preview_state.dart';

/// Core class used by the text animate component.
class TextAnimatePreview extends m.StatefulWidget {
  const TextAnimatePreview({super.key});

  @override
  m.State<TextAnimatePreview> createState() => _TextAnimatePreviewState();
}
