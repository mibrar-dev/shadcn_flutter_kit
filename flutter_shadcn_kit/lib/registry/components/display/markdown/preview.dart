// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:flutter/foundation.dart' as f;
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart' show rootBundle;

import '../../../shared/theme/theme.dart' as shadcn;
import '../../../shared/utils/axis.dart';
import '../chat/chat.dart';
import 'markdown.dart';
import '../text_animate/text_animate.dart' as ta;
import '../text_animate/_impl/extensions/markdown_streaming_extension.dart';

part '_impl/state/_markdown_preview_state.dart';

class MarkdownPreview extends m.StatefulWidget {
  const MarkdownPreview({super.key});

  @override
  m.State<MarkdownPreview> createState() => _MarkdownPreviewState();
}
