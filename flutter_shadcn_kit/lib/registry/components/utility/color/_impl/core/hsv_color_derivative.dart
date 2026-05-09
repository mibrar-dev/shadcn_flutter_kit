// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color.dart';

final class _HSVColor extends ColorDerivative {
  /// Stores `color` state/configuration for this implementation.
  final HSVColor color;
  const _HSVColor(this.color);

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
    return color;
  }

  @override
  /// Executes `toHSLColor` behavior for this component/composite.
  HSLColor toHSLColor() {
    return HSLColor.fromColor(color.toColor());
  }

  @override
  /// Stores `opacity` state/configuration for this implementation.
  double get opacity => color.alpha;

  @override
  /// Executes `changeToOpacity` behavior for this component/composite.
  ColorDerivative changeToOpacity(double alpha) {
    return _HSVColor(color.withAlpha(alpha));
  }

  @override
  /// Executes `changeToHSVHue` behavior for this component/composite.
  ColorDerivative changeToHSVHue(double hue) {
    return _HSVColor(color.withHue(hue));
  }

  @override
  /// Executes `changeToHSVSaturation` behavior for this component/composite.
  ColorDerivative changeToHSVSaturation(double saturation) {
    return _HSVColor(color.withSaturation(saturation));
  }

  @override
  /// Executes `changeToHSVValue` behavior for this component/composite.
  ColorDerivative changeToHSVValue(double value) {
    return _HSVColor(color.withValue(value));
  }

  @override
  /// Executes `transform` behavior for this component/composite.
  ColorDerivative transform(ColorDerivative old) {
    if (old is _HSVColor) {
      return _HSVColor(color);
    } else if (old is _HSLColor) {
      return _HSLColor(HSLColor.fromColor(color.toColor()));
    } else {
      throw FlutterError('Invalid color type');
    }
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is _HSLColor) {
      return color == other.toHSVColor();
    }

    return other is _HSVColor && other.color == color;
  }

  @override
  /// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => color.hashCode;

  @override
  double get hslHue => HSLColor.fromColor(color.toColor()).hue;

  @override
  double get hslSat => HSLColor.fromColor(color.toColor()).saturation;

  @override
  double get hslVal => HSLColor.fromColor(color.toColor()).lightness;

  @override
  /// Stores `hsvHue` state/configuration for this implementation.
  double get hsvHue => color.hue;

  @override
  /// Stores `hsvSat` state/configuration for this implementation.
  double get hsvSat => color.saturation;

  @override
  /// Stores `hsvVal` state/configuration for this implementation.
  double get hsvVal => color.value;

  @override
  int get red => (color.toColor().r * 255).round() & 0xFF;

  @override
  int get green => (color.toColor().g * 255).round() & 0xFF;

  @override
  int get blue => (color.toColor().b * 255).round() & 0xFF;
}
