// Generic slider machinery shared by every slider-flavoured control: the
// `slider` component plus the B04 colour sliders (alpha, hsl, hsv).
//
// Layer 2 primitive: imports only foundation/theme/widgets — never a
// component. Styling (variants, tokens) stays in each component.

export 'slider_controller.dart';
export 'slider_logic.dart';
export 'slider_painter.dart';
