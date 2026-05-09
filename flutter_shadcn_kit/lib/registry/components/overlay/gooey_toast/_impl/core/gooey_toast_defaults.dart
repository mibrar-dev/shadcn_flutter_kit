part of '../../gooey_toast.dart';

/// Global defaults for Gooey Toast behavior and visuals.
///
/// Edit values here when you want broad component-level defaults without
/// changing app theme configuration.
class GooeyToastDefaults {
  const GooeyToastDefaults._();

  /// Base compact header height.
  static const double toastHeight = 40;

  /// Default toast width.
  static const double toastWidth = 350;

  /// Default corner roundness.
  static const double roundness = 18;

  /// Gooey blur sigma ratio based on roundness.
  static const double blurRatio = 0.5;

  /// Extra compact pill horizontal padding.
  static const double pillPadding = 10;

  /// Minimum expanded-to-compact height ratio.
  static const double minExpandRatio = 2.25;

  /// Morph animation duration for sileo profile.
  static const Duration morphDuration = Duration(milliseconds: 600);

  /// Default auto-dismiss duration.
  static const Duration duration = Duration(milliseconds: 6000);

  /// Default delay before auto-expand.
  static const Duration expandDelay = Duration(milliseconds: 150);

  /// Default delay before auto-collapse.
  static const Duration collapseDelay = Duration(milliseconds: 4000);

  /// Default surface fill color.
  static const Color fill = Color(0xFF0D1117);

  /// Default gooey blur toggle.
  static const bool enableGooeyBlur = true;

  /// Default interaction pauses dismiss timer.
  static const bool pauseOnHover = true;

  /// Default swipe dismiss enablement.
  static const bool swipeToDismiss = true;

  /// Default swipe distance threshold.
  static const double dismissDragThreshold = 72;

  /// Default spacing between region-stacked toasts.
  static const double spacing = 8;

  /// Default overlap stack toggle.
  static const bool overlapStackWhenMultiple = false;

  /// Default overlap offset between stacked toasts.
  static const double overlapStackOffset = 8;

  /// Default multi-toast auto-dismiss pause toggle.
  static const bool pauseAutoDismissWhenMultiple = false;

  /// Default stack reflow animation duration.
  static const Duration stackAnimationDuration = Duration(milliseconds: 220);

  /// Default max visible stack entries. `0` keeps all entries visible.
  static const int maxVisibleCount = 0;

  /// Default whole-stack dismissal toggle.
  static const bool dismissWholeStackWhenMultiple = false;

  /// Default behavior when a new toast is shown in same region.
  static const GooeyToastNewToastBehavior newToastBehavior =
      GooeyToastNewToastBehavior.stack;

  /// Default expansion animation style.
  static const GooeyToastAnimationStyle animationStyle =
      GooeyToastAnimationStyle.sileo;

  /// Default shape variant.
  static const GooeyToastShapeStyle shapeStyle =
      GooeyToastShapeStyle.defaultShape;

  /// Default expanded content animation style.
  static const GooeyToastBodyAnimationStyle bodyAnimationStyle =
      GooeyToastBodyAnimationStyle.fade;

  /// Default success state tone.
  static const Color successTone = Color(0xFF63C65E);

  /// Default loading state tone.
  static const Color loadingTone = Color(0xFF8A8F98);

  /// Default error state tone.
  static const Color errorTone = Color(0xFFEF5E5E);

  /// Default warning state tone.
  static const Color warningTone = Color(0xFFEABB4B);

  /// Default info state tone.
  static const Color infoTone = Color(0xFF6EA8FF);

  /// Default action state tone.
  static const Color actionTone = Color(0xFF7A8DFF);
}
