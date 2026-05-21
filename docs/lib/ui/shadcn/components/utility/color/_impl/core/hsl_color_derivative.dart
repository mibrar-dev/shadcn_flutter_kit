// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color.dart';

final class _HSLColor extends ColorDerivative {
  /// Stores `color` state/configuration for this implementation.
  final HSLColor color;
  const _HSLColor(this.color);
  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() => color.toString();

  @override
  /// Executes `toColor` behavior for this component/composite.
  Color toColor() {
    return color.toColor();
  }

  @override
  /// Executes `toHSVColor` behavior for this component/composite.
  HSVColor toHSVColor() {
    return HSVColor.fromColor(color.toColor());
  }

  @override
  /// Executes `toHSLColor` behavior for this component/composite.
  HSLColor toHSLColor() {
    return color;
  }

  @override
  /// Stores `opacity` state/configuration for this implementation.
  double get opacity => color.alpha;

  @override
  /// Executes `changeToOpacity` behavior for this component/composite.
  ColorDerivative changeToOpacity(double alpha) {
    return _HSLColor(color.withAlpha(alpha));
  }

  @override
  /// Executes `changeToHSLHue` behavior for this component/composite.
  ColorDerivative changeToHSLHue(double hue) {
    return _HSLColor(color.withHue(hue));
  }

  @override
  /// Executes `changeToHSLSaturation` behavior for this component/composite.
  ColorDerivative changeToHSLSaturation(double saturation) {
    return _HSLColor(color.withSaturation(saturation));
  }

  @override
  /// Executes `changeToHSLLightness` behavior for this component/composite.
  ColorDerivative changeToHSLLightness(double lightness) {
    return _HSLColor(color.withLightness(lightness));
  }

  @override
  /// Executes `changeToHSVHue` behavior for this component/composite.
  ColorDerivative changeToHSVHue(double hue) {
    // should be the same as changing HSL hue
    return _HSLColor(color.withHue(hue));
  }

  @override
  /// Executes `transform` behavior for this component/composite.
  ColorDerivative transform(ColorDerivative old) {
    if (old is _HSVColor) {
      return _HSVColor(HSVColor.fromColor(color.toColor()));
    } else if (old is _HSLColor) {
      return _HSLColor(color);
    } else {
      throw FlutterError('Invalid color type');
    }
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is _HSVColor) {
      return color == other.toHSLColor();
    }

    return other is _HSLColor && other.color == color;
  }

  @override
  /// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => color.hashCode;

  @override
  /// Stores `hslHue` state/configuration for this implementation.
  double get hslHue => color.hue;

  @override
  /// Stores `hslSat` state/configuration for this implementation.
  double get hslSat => color.saturation;

  @override
  /// Stores `hslVal` state/configuration for this implementation.
  double get hslVal => color.lightness;

  @override
  double get hsvHue => HSVColor.fromColor(color.toColor()).hue;

  @override
  double get hsvSat => HSVColor.fromColor(color.toColor()).saturation;

  @override
  double get hsvVal => HSVColor.fromColor(color.toColor()).value;

  @override
  int get red => (color.toColor().r * 255).toInt() & 0xFF;

  @override
  int get green => (color.toColor().g * 255).toInt() & 0xFF;

  @override
  int get blue => (color.toColor().b * 255).toInt() & 0xFF;
}
