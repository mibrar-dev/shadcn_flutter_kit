import 'package:flutter/widgets.dart';

import 'data.dart';

/// Wraps a subtree with captured themes and captured data.
///
/// Overlay routes capture both from the opening context and re-inject them
/// into the route subtree; see [Data.capture].
class CapturedWrapper extends StatefulWidget {
  /// Captured inherited themes, if any.
  final CapturedThemes? themes;

  /// Captured data, if any.
  final CapturedData? data;

  /// The child widget.
  final Widget child;

  const CapturedWrapper({
    super.key,
    this.themes,
    this.data,
    required this.child,
  });

  @override
  State<CapturedWrapper> createState() => _CapturedWrapperState();
}

class _CapturedWrapperState extends State<CapturedWrapper> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget child = KeyedSubtree(key: _key, child: widget.child);
    if (widget.themes != null) {
      child = widget.themes!.wrap(child);
    }
    if (widget.data != null) {
      child = widget.data!.wrap(child);
    }
    return child;
  }
}
