// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// WindowActions defines a reusable type for this registry module.
class WindowActions extends StatelessWidget {
  /// Creates a default window actions widget.
  ///
  /// This widget automatically displays appropriate control buttons based on
  /// the window's configuration and capabilities.
  const WindowActions({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    WindowHandle? handle = Data.maybeOf<WindowHandle>(context);
    WindowViewport? viewport = Data.maybeOf<WindowViewport>(context);
    return Row(
      children: [
        if (handle?.minimizable ?? true)
          /// Creates a `IconButton.ghost` instance.
          IconButton.ghost(
            icon: const Icon(Icons.minimize),
            size: ButtonSize.small,
            onPressed: () {
              handle?.minimized = !handle.minimized;
            },
          ),
        if (handle?.maximizable ?? true)
          /// Creates a `IconButton.ghost` instance.
          IconButton.ghost(
            icon: const Icon(Icons.crop_square),
            size: ButtonSize.small,
            onPressed: () {
              if (handle != null) {
                if (handle.maximized != null) {
                  handle.maximized = null;
                } else {
                  handle.maximized =
                      viewport
                          ?.navigator
                          ._state
                          ._snappingStrategy
                          .value
                          ?.relativeBounds ??
                      const Rect.fromLTWH(0, 0, 1, 1);
                }
              }
            },
          ),
        if (handle?.closable ?? true)
          /// Creates a `IconButton.ghost` instance.
          IconButton.ghost(
            icon: const Icon(Icons.close),
            size: ButtonSize.small,
            onPressed: () {
              handle?.close();
            },
          ),
      ],
    );
  }
}
