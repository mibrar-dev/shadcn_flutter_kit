// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/foundation.dart';

import '../utils/feature_carousel_animation_style.dart';
import '../utils/feature_carousel_models.dart';

/// FeatureCarouselController controls runtime behavior and interactions for feature carousel.
class FeatureCarouselController extends ChangeNotifier {
  /// Creates `FeatureCarouselController` for configuring or rendering feature carousel.
  FeatureCarouselController({
    int initialIndex = 0,
    this.showCta = true,
    this.showNavArrows = true,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.animationStyle = FeatureCarouselAnimationStyle.slideFade,
    this.cycleAnimationStyles = true,
    this.enableKeyboardNavigation = true,
    this.enableSwipe = true,
    this.primaryActionLabel = 'Add to chat',
    this.onPrimaryAction,
    this.onIndexChanged,
  }) : _index = initialIndex;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  int _index;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  bool showCta;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  bool showNavArrows;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  bool autoPlay;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  Duration autoPlayInterval;

  /// Animation/progress setting used by feature carousel transitions.
  FeatureCarouselAnimationStyle animationStyle;

  /// Animation/progress setting used by feature carousel transitions.
  bool cycleAnimationStyles;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  bool enableKeyboardNavigation;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  bool enableSwipe;

  /// Input parameter used by `FeatureCarouselController` during rendering and behavior handling.
  String primaryActionLabel;
  void Function(FeatureCarouselItem item, int index)? onPrimaryAction;
  void Function(int index)? onIndexChanged;

  int get index => _index;

  /// Implements `index` behavior for feature carousel.
  set index(int value) {
    if (_index == value) return;
    _index = value;
    notifyListeners();
    onIndexChanged?.call(_index);
  }

  /// Implements `next` behavior for feature carousel.
  void next(int itemCount) {
    if (itemCount == 0) return;
    index = (index + 1) % itemCount;
  }

  /// Implements `previous` behavior for feature carousel.
  void previous(int itemCount) {
    if (itemCount == 0) return;
    index = (index - 1 + itemCount) % itemCount;
  }

  void update({
    bool? showCta,
    bool? showNavArrows,
    bool? autoPlay,
    Duration? autoPlayInterval,
    FeatureCarouselAnimationStyle? animationStyle,
    bool? cycleAnimationStyles,
    bool? enableKeyboardNavigation,
    bool? enableSwipe,
    String? primaryActionLabel,
    void Function(FeatureCarouselItem item, int index)? onPrimaryAction,
    void Function(int index)? onIndexChanged,
  }) {
    var dirty = false;
    if (showCta != null && showCta != this.showCta) {
      this.showCta = showCta;
      dirty = true;
    }
    if (showNavArrows != null && showNavArrows != this.showNavArrows) {
      this.showNavArrows = showNavArrows;
      dirty = true;
    }
    if (autoPlay != null && autoPlay != this.autoPlay) {
      this.autoPlay = autoPlay;
      dirty = true;
    }
    if (autoPlayInterval != null && autoPlayInterval != this.autoPlayInterval) {
      this.autoPlayInterval = autoPlayInterval;
      dirty = true;
    }
    if (animationStyle != null && animationStyle != this.animationStyle) {
      this.animationStyle = animationStyle;
      dirty = true;
    }
    if (cycleAnimationStyles != null &&
        cycleAnimationStyles != this.cycleAnimationStyles) {
      this.cycleAnimationStyles = cycleAnimationStyles;
      dirty = true;
    }
    if (enableKeyboardNavigation != null &&
        enableKeyboardNavigation != this.enableKeyboardNavigation) {
      this.enableKeyboardNavigation = enableKeyboardNavigation;
      dirty = true;
    }
    if (enableSwipe != null && enableSwipe != this.enableSwipe) {
      this.enableSwipe = enableSwipe;
      dirty = true;
    }
    if (primaryActionLabel != null &&
        primaryActionLabel != this.primaryActionLabel) {
      this.primaryActionLabel = primaryActionLabel;
      dirty = true;
    }
    if (onPrimaryAction != null) {
      this.onPrimaryAction = onPrimaryAction;
      dirty = true;
    }
    if (onIndexChanged != null) {
      this.onIndexChanged = onIndexChanged;
      dirty = true;
    }
    if (dirty) {
      notifyListeners();
    }
  }
}
