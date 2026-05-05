part of '../../dialog.dart';

/// _DialogOverlayWrapper defines a reusable type for this registry module.
class _DialogOverlayWrapper<T> extends StatefulWidget {
/// Stores `route` state/configuration for this implementation.
  final DialogRoute<T> route;
/// Stores `child` state/configuration for this implementation.
  final Widget child;

/// Creates a `_DialogOverlayWrapper` instance.
  const _DialogOverlayWrapper({
    super.key,
    required this.route,
    required this.child,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  State<_DialogOverlayWrapper<T>> createState() =>
      _DialogOverlayWrapperState<T>();
}
