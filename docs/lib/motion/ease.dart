import 'package:flutter/animation.dart';

// Motion constants for the docs site, per `P6_SHADCN_SITE_SPEC.md` §3.3/§5.2:
// colour transitions 150ms cubic-bezier(.4,0,.2,1) everywhere; the palette
// panel 200ms `ease`; the mobile nav popper 100ms; the heading `#` anchor
// 200ms linear; copy feedback resets after 2000ms. The reference site has no
// scroll reveals, route transitions, springs, floats or marquees — none of
// those constants exist here on purpose.

/// The theme tween easing: cubic-bezier(0.16, 1, 0.3, 1).
///
/// Retained only for the theme (preset/mode) tween; `AnimatedShadcnTheme` is
/// our documented deviation (the reference swaps CSS variables instantly).
const Curve kEaseOutExpo = Cubic(0.16, 1, 0.3, 1);

/// Tailwind `ease` / `--default-transition-timing-function`:
/// cubic-bezier(0.4, 0, 0.2, 1) — hover colour transitions, palette panel.
const Curve kEaseStandard = Curves.fastOutSlowIn;

/// Exit easing (motion spec: exits use ease-in, 150ms).
const Curve kEaseIn = Curves.easeIn;

/// Hover/press colour transitions (shadcn `duration-150`).
const Duration kDurationFast = Duration(milliseconds: 150);

/// Mobile-nav popper open/close (shadcn `duration-100`).
const Duration kDurationPopper = Duration(milliseconds: 100);

/// Command palette panel enter/exit (shadcn `duration-200 ease`).
const Duration kDurationPalette = Duration(milliseconds: 200);

/// Heading `#` anchor reveal (`margin, opacity 0.2s linear`).
const Duration kDurationHeadingAnchor = Duration(milliseconds: 200);

/// Theme (preset/mode) colour tween — our deviation, layout untouched.
const Duration kDurationTheme = Duration(milliseconds: 300);

/// Copy-button "Copied" feedback; the check icon resets after 2000ms.
const Duration kDurationCopyFeedback = Duration(milliseconds: 2000);
