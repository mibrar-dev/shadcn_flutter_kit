// ignore_for_file: avoid_web_libraries_in_flutter,dead_code,deprecated_member_use,duplicate_import,sort_child_properties_last,unnecessary_import,unnecessary_null_comparison,unused_import,use_null_aware_elements
import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'file_drop_adapter.dart';
import 'file_like.dart';

FileDropAdapter createAdapter() => _WebFileDropAdapter();

class _WebFileDropAdapter implements FileDropAdapter {
  @override
  bool get supportsDragDrop => true;

  @override
  Widget buildDropTarget({
    required Widget child,
    required bool enabled,
    required bool withData,
    required ValueChanged<bool> onDragActive,
    required ValueChanged<List<FileLike>> onDrop,
    VoidCallback? onTap,
  }) {
    if (!enabled) return child;
    return _WebDropTargetView(
      child: child,
      withData: withData,
      onDragActive: onDragActive,
      onDrop: onDrop,
      onTap: onTap,
      handleDrop: _handleDrop,
    );
  }

  Future<void> _handleDrop(
    web.FileList files,
    bool withData,
    ValueChanged<List<FileLike>> onDrop,
  ) async {
    final futures = <Future<FileLike>>[];
    for (var index = 0; index < files.length; index++) {
      final file = files.item(index);
      if (file == null) continue;
      futures.add(_fromWebFile(file, withData));
    }
    onDrop(await Future.wait(futures));
  }

  Future<Uint8List> _readWebFileBytes(web.File file) {
    final completer = Completer<Uint8List>();
    final reader = web.FileReader();
    reader.onload = ((web.Event _) {
      final result = reader.result;
      if (result == null) {
        completer.completeError(StateError('FileReader result was null'));
        return;
      }
      final buffer = (result as JSArrayBuffer).toDart;
      completer.complete(Uint8List.view(buffer));
    }).toJS;
    reader.onerror = ((web.Event _) {
      completer.completeError(StateError('FileReader failed for ${file.name}'));
    }).toJS;
    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  Future<FileLike> _fromWebFile(web.File file, bool withData) async {
    final bytes = withData ? await _readWebFileBytes(file) : null;
    return FileLike(
      id: '${DateTime.now().microsecondsSinceEpoch}-${file.name}',
      name: file.name,
      size: file.size,
      bytes: bytes,
      mimeType: file.type,
      extension: _extensionFromName(file.name),
      source: file,
    );
  }

  String? _extensionFromName(String name) {
    final parts = name.split('.');
    if (parts.length <= 1) return null;
    return parts.last.toLowerCase();
  }
}

class _WebDropTargetView extends StatefulWidget {
  const _WebDropTargetView({
    required this.child,
    required this.withData,
    required this.onDragActive,
    required this.onDrop,
    required this.onTap,
    required this.handleDrop,
  });

  final Widget child;
  final bool withData;
  final ValueChanged<bool> onDragActive;
  final ValueChanged<List<FileLike>> onDrop;
  final VoidCallback? onTap;
  final Future<void> Function(
    web.FileList files,
    bool withData,
    ValueChanged<List<FileLike>> onDrop,
  )
  handleDrop;

  @override
  State<_WebDropTargetView> createState() => _WebDropTargetViewState();
}

class _WebDropTargetViewState extends State<_WebDropTargetView> {
  static int _counter = 0;

  late final String _viewType;
  late final web.HTMLDivElement _div;

  var _dragDepth = 0;
  var _isActive = false;

  void _setActive(bool value) {
    if (_isActive == value) return;
    _isActive = value;
    widget.onDragActive(value);
  }

  @override
  void initState() {
    super.initState();
    _viewType = 'shadcn-file-dropzone-${_counter++}';
    _div = web.HTMLDivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.backgroundColor = 'transparent'
      ..style.pointerEvents = 'auto';

    _div.onDragOver.listen((event) {
      event.preventDefault();
      event.stopPropagation();
      if (_dragDepth == 0) _dragDepth = 1;
      _setActive(true);
    });
    _div.onDragEnter.listen((event) {
      event.preventDefault();
      event.stopPropagation();
      _dragDepth += 1;
      _setActive(true);
    });
    _div.onDragLeave.listen((event) {
      event.preventDefault();
      event.stopPropagation();
      _dragDepth = (_dragDepth - 1).clamp(0, 1 << 31);
      if (_dragDepth == 0) {
        _setActive(false);
      }
    });
    _div.onDrop.listen((event) {
      event.preventDefault();
      event.stopPropagation();
      _dragDepth = 0;
      _setActive(false);
      final dragEvent = event as web.DragEvent;
      final dataTransfer = dragEvent.dataTransfer;
      if (dataTransfer == null) return;
      final files = dataTransfer.files;
      unawaited(widget.handleDrop(files, widget.withData, widget.onDrop));
    });
    if (widget.onTap != null) {
      _div.onclick = ((web.Event _) {
        widget.onTap?.call();
      }).toJS;
    }

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      return _div;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(child: HtmlElementView(viewType: _viewType)),
      ],
    );
  }
}
