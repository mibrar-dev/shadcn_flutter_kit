import 'package:flutter/animation.dart';

/// The design's single entrance/morph easing: cubic-bezier(0.16, 1, 0.3, 1).
const Curve kEaseOutExpo = Cubic(0.16, 1, 0.3, 1);

/// Exit easing (motion spec: exits use ease-in, 150ms).
const Curve kEaseIn = Curves.easeIn;

/// Hero-piece spring-in: cubic-bezier(0.34, 1.4, 0.64, 1). The overshoot is
/// bounded to ≤ 4px by the widget test in `test/motion_test.dart`.
const Curve kEaseSpring = Cubic(0.34, 1.4, 0.64, 1);

// Durations straight from the motion spec (`rearch/reports/P6_DOCS_DESIGN.md`).

/// Exit / scrim / small-state durations.
const Duration kDurationFast = Duration(milliseconds: 150);

/// Route transitions (fade + 8px rise).
const Duration kDurationPage = Duration(milliseconds: 200);

/// Theme (preset/mode) colour tween.
const Duration kDurationTheme = Duration(milliseconds: 300);

/// Reveal-on-scroll (fade + 12px rise), staggered by [kRevealStagger].
const Duration kDurationReveal = Duration(milliseconds: 300);

/// Reveal stagger step between sibling elements.
const Duration kRevealStagger = Duration(milliseconds: 40);

/// Hero entrance.
const Duration kDurationHero = Duration(milliseconds: 500);

/// Copy-button "Copied" feedback (label swap).
const Duration kDurationCopyFeedback = Duration(milliseconds: 1500);

/// Marquee loop.
const Duration kDurationMarquee = Duration(seconds: 40);

/// Idle hero float loop (±3px).
const Duration kDurationFloat = Duration(seconds: 6);
