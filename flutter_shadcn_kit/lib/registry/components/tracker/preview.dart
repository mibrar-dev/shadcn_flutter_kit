// Gallery preview for the `tracker` component: the four levels, a custom
// height/gap, a scoped theme leg and the dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'tracker.dart';

/// Renders the tracker gallery.
class TrackerPreview extends StatelessWidget {
  /// Creates the preview.
  const TrackerPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('All levels', SizedBox(width: 320, child: _all())),
                const Gap(24),
                _section('Custom size', SizedBox(width: 320, child: _custom())),
                const Gap(24),
                _section(
                  'Scoped theme',
                  SizedBox(width: 320, child: _scoped()),
                ),
                const Gap(24),
                _section('Dark', SizedBox(width: 320, child: _dark())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _all() {
    return const Tracker(
      data: <TrackerData>[
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Degraded'), level: TrackerLevel.warning),
        TrackerData(tooltip: Text('Down'), level: TrackerLevel.critical),
        TrackerData(tooltip: Text('No data'), level: TrackerLevel.unknown),
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
      ],
    );
  }

  Widget _custom() {
    return Tracker(
      theme: const TrackerTheme(itemHeight: 24, gap: 4, radius: 4),
      data: const <TrackerData>[
        TrackerData(tooltip: Text('One'), level: TrackerLevel.fine),
        TrackerData(tooltip: Text('Two'), level: TrackerLevel.critical),
        TrackerData(tooltip: Text('Three'), level: TrackerLevel.warning),
      ],
    );
  }

  Widget _scoped() {
    return ComponentTheme<TrackerTheme>(
      data: const TrackerTheme(
        fine: ThemedColor.ref(ColorRef.primary),
        itemHeight: 16,
      ),
      child: const Tracker(
        data: <TrackerData>[
          TrackerData(tooltip: Text('One'), level: TrackerLevel.fine),
          TrackerData(tooltip: Text('Two'), level: TrackerLevel.fine),
          TrackerData(tooltip: Text('Three'), level: TrackerLevel.fine),
        ],
      ),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: const Tracker(
        data: <TrackerData>[
          TrackerData(tooltip: Text('Healthy'), level: TrackerLevel.fine),
          TrackerData(tooltip: Text('Degraded'), level: TrackerLevel.warning),
          TrackerData(tooltip: Text('Down'), level: TrackerLevel.critical),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
