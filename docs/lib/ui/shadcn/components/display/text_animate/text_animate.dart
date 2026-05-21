// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/core/streaming_cursor.dart';
part '_impl/core/streaming_text_effect_adapter.dart';
part '_impl/core/typewriter_effect.dart';
part '_impl/core/blur_in_effect.dart';
part '_impl/core/fade_in_effect.dart';
part '_impl/core/slide_in_effect.dart';
part '_impl/core/scramble_in_effect.dart';
part '_impl/core/combined_effect.dart';

part '_impl/styles/character_span_factory.dart';

part '_impl/utils/text_diff.dart';
part '_impl/utils/time_math.dart';

part '_impl/themes/base/text_animate_theme.dart';

part '_impl/state/streaming_text_state.dart';

/// Callback fired once when the latest text update has fully settled.
typedef StreamingTextSettled = void Function(String text);

/// Stream-aware text renderer for incremental text updates.
class StreamingText extends StatefulWidget {
  /// Creates `StreamingText` for configuring or rendering text animate.
  const StreamingText({
    super.key,
    required this.text,
    this.style,
    this.typewriter,
    this.animateByWord = false,
    this.effect,
    this.cursor,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.locale,
    this.smoothLayout = true,
    this.layoutAnimationDuration = const Duration(milliseconds: 180),
    this.layoutAnimationCurve = Curves.easeOutCubic,
    this.onSettled,
  });

  /// Latest full text value received from the stream.
  final String text;

  /// Optional base style for rendered text.
  final TextStyle? style;

  /// Typewriter behavior for newly appended characters.
  final TypewriterEffect? typewriter;

  /// When true, reveal/effect units are words (with trailing whitespace)
  /// instead of individual characters.
  final bool animateByWord;

  /// Visual effect applied to newly revealed characters.
  final StreamingTextEffectAdapter? effect;

  /// Cursor behavior.
  final StreamingCursor? cursor;

  /// Data consumed by `StreamingText` to render text animate content.
  final TextAlign? textAlign;

  /// Data consumed by `StreamingText` to render text animate content.
  final TextDirection? textDirection;

  /// Input parameter used by `StreamingText` during rendering and behavior handling.
  final bool? softWrap;

  /// Input parameter used by `StreamingText` during rendering and behavior handling.
  final TextOverflow? overflow;

  /// Input parameter used by `StreamingText` during rendering and behavior handling.
  final int? maxLines;

  /// Layout/size setting that affects text animate rendering.
  final TextWidthBasis? textWidthBasis;

  /// Layout/size setting that affects text animate rendering.
  final TextHeightBehavior? textHeightBehavior;

  /// Input parameter used by `StreamingText` during rendering and behavior handling.
  final Locale? locale;

  /// Smoothly animates widget height when line wrapping/new lines change layout.
  final bool smoothLayout;

  /// Duration used for the smooth layout height transition.
  final Duration layoutAnimationDuration;

  /// Curve used for the smooth layout height transition.
  final Curve layoutAnimationCurve;

  /// Invoked once each time a new text revision has completely settled.
  final StreamingTextSettled? onSettled;

  /// Creates the State object used by this text animate widget.
  @override
  State<StreamingText> createState() => _StreamingTextState();
}
