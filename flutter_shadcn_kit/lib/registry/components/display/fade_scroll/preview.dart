// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';
import '../fade_scroll/fade_scroll.dart';

/// Core class used by the fade scroll component.
class FadeScrollPreview extends StatefulWidget {
  const FadeScrollPreview({super.key});

  @override
  State<FadeScrollPreview> createState() => _FadeScrollPreviewState();
}

class _FadeScrollPreviewState extends State<FadeScrollPreview> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds the widget tree for fade scroll.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 240,
            child: FadeScroll(
              controller: _controller,
              child: ListView.builder(
                controller: _controller,
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item ${index + 1}'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
