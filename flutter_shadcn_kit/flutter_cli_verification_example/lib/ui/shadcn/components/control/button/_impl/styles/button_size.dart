/// ButtonSize defines a reusable type for this registry module.
class ButtonSize {
  /// The scaling factor applied to button dimensions.
  ///
  /// A value of 1.0 represents normal size, values less than 1.0 create smaller
  /// buttons, and values greater than 1.0 create larger buttons.
  final double scale;

  /// Creates a [ButtonSize] with the specified scaling factor.
  const ButtonSize(this.scale);

  /// Standard button size (scale: 1.0).
  static const ButtonSize normal = ButtonSize(1);

  /// Extra small button size (scale: 0.5).
  static const ButtonSize xSmall = ButtonSize(1 / 2);

  /// Small button size (scale: 0.75).
  static const ButtonSize small = ButtonSize(3 / 4);

  /// Large button size (scale: 2.0).
  static const ButtonSize large = ButtonSize(2);

  /// Extra large button size (scale: 3.0).
  static const ButtonSize xLarge = ButtonSize(3);
}
