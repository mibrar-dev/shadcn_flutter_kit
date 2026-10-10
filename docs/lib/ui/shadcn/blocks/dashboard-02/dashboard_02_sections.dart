// The `dashboard-02` block, part 2: the chart, the traffic-source card, the
// device split and the tab strip. Imported by `dashboard_02.dart`; a block
// never imports another block.

import 'package:flutter/widgets.dart';

import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../components/progress/progress.dart';
import '../../components/tabs/tabs.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';

class Dashboard02Chart extends StatelessWidget {
  const Dashboard02Chart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<double> series = <double>[
      0.28,
      0.45,
      0.36,
      0.62,
      0.51,
      0.74,
      0.60,
      0.86,
      0.70,
      0.93,
      0.78,
      1.0,
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text('Visitors', style: theme.typography.textLarge),
              ),
              const Spacer(),
              const _Dashboard02Legend('Desktop', 0),
              Gap(spacing.lg),
              const _Dashboard02Legend('Mobile', 1),
            ],
          ),
          Gap(spacing.lg),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (var i = 0; i < series.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xs),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 220 * series[i],
                            decoration: BoxDecoration(
                              // One series, one token (see dashboard-01).
                              color: theme.colors.chart1,
                              borderRadius: theme.borderRadiusSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dashboard02Legend extends StatelessWidget {
  const _Dashboard02Legend(this.label, this.chartIndex);

  final String label;
  final int chartIndex;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: theme.colors.chartColors[chartIndex],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const Gap(0, crossAxisExtent: 6),
        Text(
          label,
          style: theme.typography.textSmall.copyWith(
            color: theme.colors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

/// Traffic sources, each with a share bar.
class Dashboard02Sources extends StatelessWidget {
  /// Creates the traffic-source card.
  const Dashboard02Sources({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<_Dashboard02Source> sources = <_Dashboard02Source>[
      _Dashboard02Source('Direct', 0.38),
      _Dashboard02Source('Search', 0.31),
      _Dashboard02Source('Referral', 0.19),
      _Dashboard02Source('Social', 0.12),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Traffic sources', style: theme.typography.textLarge),
          Gap(spacing.lg),
          for (final source in sources) ...<Widget>[
            Text(source.label, style: theme.typography.textSmall),
            Gap(spacing.sm),
            Progress(value: source.share, height: spacing.xs),
            Gap(spacing.lg),
          ],
        ],
      ),
    );
  }
}

class _Dashboard02Source {
  const _Dashboard02Source(this.label, this.share);

  final String label;
  final double share;
}

/// Device split as three stacked progress rows.
class Dashboard02Devices extends StatelessWidget {
  /// Creates the device-split card.
  const Dashboard02Devices({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    const List<_Dashboard02Device> devices = <_Dashboard02Device>[
      _Dashboard02Device('Desktop', 0.52, 0),
      _Dashboard02Device('Mobile', 0.41, 1),
      _Dashboard02Device('Tablet', 0.07, 2),
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('By device', style: theme.typography.textLarge),
          Gap(spacing.lg),
          for (final device in devices) ...<Widget>[
            _Dashboard02DeviceRow(device: device),
            if (device != devices.last) Gap(spacing.lg),
          ],
          Gap(spacing.lg),
          const Divider(),
          Gap(spacing.lg),
          const Dashboard02Tabs(),
        ],
      ),
    );
  }
}

class _Dashboard02Device {
  const _Dashboard02Device(this.label, this.share, this.chartIndex);

  final String label;
  final double share;
  final int chartIndex;
}

class _Dashboard02DeviceRow extends StatelessWidget {
  const _Dashboard02DeviceRow({required this.device});

  final _Dashboard02Device device;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final spacing = theme.spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Text(device.label, style: theme.typography.textSmall),
            ),
            const Spacer(),
            Text(
              '${(device.share * 100).round()}%',
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
        Gap(spacing.sm),
        Progress(
          value: device.share,
          height: spacing.xs,
          color: theme.colors.chartColors[device.chartIndex],
        ),
      ],
    );
  }
}

/// A non-interactive tab strip; the block is a static screen.
class Dashboard02Tabs extends StatelessWidget {
  const Dashboard02Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    // `Tabs` measures its strip at natural width; on a phone the three labels
    // do not fit, so the strip scrolls instead of overflowing.
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Tabs(
        index: 0,
        children: <TabItem>[
          TabItem(child: Text('Overview')),
          TabItem(child: Text('Sessions')),
          TabItem(child: Text('Conversions')),
        ],
      ),
    );
  }
}
