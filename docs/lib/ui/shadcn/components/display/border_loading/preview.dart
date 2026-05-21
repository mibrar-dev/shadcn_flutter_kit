// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import 'border_loading.dart';

/// Gallery preview for all `BorderLoading` modes.
class BorderLoadingPreview extends m.StatefulWidget {
  /// Creates the preview page.
  const BorderLoadingPreview({super.key});

  @override
  m.State<BorderLoadingPreview> createState() => _BorderLoadingPreviewState();
}

/// Stateful preview to drive interactive determinate progress.
class _BorderLoadingPreviewState extends m.State<BorderLoadingPreview> {
  /// Slider-controlled progress value for the upload demo tile.
  double _uploadProgress = 0.62;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: m.SingleChildScrollView(
          padding: const m.EdgeInsets.all(24),
          child: m.Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: m.WrapAlignment.center,
            children: [
              // Sweep gradient loading demo.
              _demoTile(
                title: 'Sweep',
                child: BorderLoading(
                  mode: BorderLoadingMode.sweepGradient,
                  spec: const BorderGradientSpec(
                    type: BorderGradientType.sweep,
                    colors: [
                      m.Color(0x00000000),

                      m.Color(0xFF3B82F6),

                      m.Color(0xFF22C55E),

                      m.Color(0xFFF59E0B),

                      m.Color(0x00000000),
                    ],
                    gap: 0.24,
                  ),
                  child: const m.Padding(
                    padding: m.EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: m.Text('Saving...'),
                  ),
                ),
              ),
              // Circular shape loading demo.
              _demoTile(
                title: 'Circle',
                child: BorderLoading(
                  shapeBorder: const m.CircleBorder(),
                  strokeWidth: 3,
                  padding: const m.EdgeInsets.all(3),
                  spec: const BorderGradientSpec(
                    type: BorderGradientType.sweep,
                    colors: [
                      m.Color(0x00000000),

                      m.Color(0xFF3B82F6),

                      m.Color(0x00000000),
                    ],
                    gap: 0.30,
                  ),
                  child: const m.SizedBox(width: 56, height: 56),
                ),
              ),
              // Tracer segment demo.
              _demoTile(
                title: 'Tracer',
                child: BorderLoading(
                  mode: BorderLoadingMode.tracer,
                  tracer: const BorderTracerSpec(
                    lengthFraction: 0.12,
                    dashCount: 2,
                  ),
                  spec: const BorderGradientSpec(
                    type: BorderGradientType.linear,
                    colors: [m.Color(0xFF3B82F6), m.Color(0xFF22C55E)],
                  ),
                  child: const m.Padding(
                    padding: m.EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: m.Text('Uploading...'),
                  ),
                ),
              ),
              // Determinate progress demo with interactive slider.
              _demoTile(
                title: 'Upload Progress',
                child: m.Column(
                  mainAxisSize: m.MainAxisSize.min,
                  children: [
                    BorderLoading(
                      mode: BorderLoadingMode.progress,
                      progress: _uploadProgress,
                      spec: const BorderGradientSpec(
                        type: BorderGradientType.linear,
                        colors: [m.Color(0xFF3B82F6), m.Color(0xFF22C55E)],
                      ),
                      child: m.Padding(
                        padding: const m.EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        child: m.Text('${(_uploadProgress * 100).round()}%'),
                      ),
                    ),

                    const m.SizedBox(height: 12),

                    m.SizedBox(
                      width: 170,
                      child: m.Slider(
                        value: _uploadProgress,
                        onChanged: (value) {
                          /// Implements `setState` behavior for border loading.
                          setState(() => _uploadProgress = value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shared tile shell used for each preview variant.
m.Widget _demoTile({required String title, required m.Widget child}) {
  return m.Container(
    width: 240,
    padding: const m.EdgeInsets.all(16),
    decoration: m.BoxDecoration(
      border: m.Border.all(color: const m.Color(0x11000000)),
      borderRadius: m.BorderRadius.circular(12),
    ),
    child: m.Column(
      mainAxisSize: m.MainAxisSize.min,
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: [
        m.Text(
          title,
          style: const m.TextStyle(fontSize: 13, fontWeight: m.FontWeight.w600),
        ),

        const m.SizedBox(height: 12),

        m.Center(child: child),
      ],
    ),
  );
}
