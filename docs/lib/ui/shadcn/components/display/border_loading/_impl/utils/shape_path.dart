// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../border_loading.dart';

/// Resolves the shape used for border path generation.
ShapeBorder _resolveShapeBorder({
  required BorderRadius borderRadius,
  ShapeBorder? shapeBorder,
}) {
  // Prefer explicit shape when provided.
  if (shapeBorder != null) return shapeBorder;
  // Fallback to rounded rectangle built from borderRadius.
  return RoundedRectangleBorder(borderRadius: borderRadius);
}

/// Builds the outer perimeter path for the resolved shape.
Path _buildOuterPath({
  required Rect rect,
  required BorderRadius borderRadius,
  ShapeBorder? shapeBorder,
}) {
  // Resolve final shape definition.
  final resolvedShape = _resolveShapeBorder(
    borderRadius: borderRadius,
    shapeBorder: shapeBorder,
  );
  // Query shape for its outer contour path.
  return resolvedShape.getOuterPath(rect);
}
