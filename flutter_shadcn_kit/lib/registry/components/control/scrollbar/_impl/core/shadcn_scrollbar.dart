// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/utils/style_value.dart';
import '../themes/base/scrollbar_theme.dart';
import '../state/shadcn_scrollbar_state.dart';

const Duration _kScrollbarFadeDuration = Duration(milliseconds: 300);
const Duration _kScrollbarTimeToFade = Duration(milliseconds: 600);

/// ShadcnScrollbar defines a reusable type for this registry module.
class ShadcnScrollbar extends RawScrollbar {
  /// Creates a `ShadcnScrollbar` instance.
  const ShadcnScrollbar({
    super.key,
    required super.child,
    super.controller,
    super.thumbVisibility,
    super.trackVisibility,
    super.thickness,
    super.radius,
    this.color,
    ScrollNotificationPredicate? notificationPredicate,
    super.interactive,
    super.scrollbarOrientation,
  }) : super(
         fadeDuration: _kScrollbarFadeDuration,
         timeToFade: _kScrollbarTimeToFade,
         pressDuration: Duration.zero,
         notificationPredicate:
             notificationPredicate ?? defaultScrollNotificationPredicate,
       );

  /// Stores `color` state/configuration for this implementation.
  final Color? color;

  @override
  /// Executes `createState` behavior for this component/composite.
  RawScrollbarState<ShadcnScrollbar> createState() => ShadcnScrollbarState();
}
