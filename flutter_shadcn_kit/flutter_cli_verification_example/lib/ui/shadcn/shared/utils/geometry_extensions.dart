import 'package:flutter/widgets.dart';

/// Extension helpers used by this registry module.
extension AlignmentGeometryExtension on AlignmentGeometry {
/// Executes `optionallyResolve` behavior for this component/composite.
  Alignment optionallyResolve(BuildContext context) {
    if (this is Alignment) {
      return this as Alignment;
    }
    return resolve(Directionality.of(context));
  }
}

/// Extension helpers used by this registry module.
extension BorderRadiusGeometryExtension on BorderRadiusGeometry {
/// Executes `optionallyResolve` behavior for this component/composite.
  BorderRadius optionallyResolve(BuildContext context) {
    if (this is BorderRadius) {
      return this as BorderRadius;
    }
    return resolve(Directionality.of(context));
  }
}

/// Extension helpers used by this registry module.
extension EdgeInsetsGeometryExtension on EdgeInsetsGeometry {
/// Executes `optionallyResolve` behavior for this component/composite.
  EdgeInsets optionallyResolve(BuildContext context) {
    if (this is EdgeInsets) {
      return this as EdgeInsets;
    }
    return resolve(Directionality.of(context));
  }
}
