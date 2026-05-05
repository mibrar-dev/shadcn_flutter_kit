const kDefaultDuration = Duration(milliseconds: 150);

/// Converts degrees to radians.
double degToRad(double deg) => deg * (3.141592653589793 / 180);

/// Converts radians to degrees.
double radToDeg(double rad) => rad * (180 / 3.141592653589793);

/// The direction for sorting.
enum SortDirection {
  /// No sorting applied.
  none,

  /// Sort in ascending order (A to Z, 0 to 9).
  ascending,

  /// Sort in descending order (Z to A, 9 to 0).
  descending,
}
