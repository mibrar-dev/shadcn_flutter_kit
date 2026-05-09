// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

class _MarkdownTapReporter extends StatefulWidget {
  const _MarkdownTapReporter({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_MarkdownTapReporter> createState() => _MarkdownTapReporterState();
}

class _MarkdownTapReporterState extends State<_MarkdownTapReporter> {
  static const double _maxTapMovement = 10;
  static const Duration _maxTapDuration = Duration(milliseconds: 260);

  Offset? _pointerDownPosition;
  Duration? _pointerDownTime;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _pointerDownPosition = event.position;
        _pointerDownTime = event.timeStamp;
      },
      onPointerCancel: (_) {
        _pointerDownPosition = null;
        _pointerDownTime = null;
      },
      onPointerUp: (event) {
        final pointerDownPosition = _pointerDownPosition;
        final pointerDownTime = _pointerDownTime;
        _pointerDownPosition = null;
        _pointerDownTime = null;
        if (pointerDownPosition == null || pointerDownTime == null) {
          return;
        }
        if ((event.position - pointerDownPosition).distance > _maxTapMovement) {
          return;
        }
        if (event.timeStamp - pointerDownTime > _maxTapDuration) {
          return;
        }
        widget.onTap();
      },
      child: widget.child,
    );
  }
}
