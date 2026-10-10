// The framed, resizable block viewport (P6-B3): the reference `/blocks` card
// renders each block inside an iframe sized to the device it targets, with
// desktop / tablet / mobile toggles beside the Preview | Code tabs.
//
// Ours is the same idea without an iframe: the block widget itself is laid out
// inside a bordered frame of the selected width (full width, 768 or 375) and a
// fixed height, centred in the card. Every block is responsive (they lay out
// from `LayoutBuilder` breakpoints), so the mobile width shows the phone
// layout of the same source.

import 'package:flutter/widgets.dart';

import '../previews/block_previews.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/spinner/spinner.dart';
import '../ui/shadcn/components/tooltip/tooltip.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';

/// The three viewport presets of a block card, in reference order.
enum BlockViewport {
  /// Full card width (a desktop layout).
  desktop('Desktop', LucideIcons.monitor, null),

  /// 768 px (a tablet layout).
  tablet('Tablet', LucideIcons.tablet, 768),

  /// 375 px (a phone layout).
  mobile('Mobile', LucideIcons.smartphone, 375);

  const BlockViewport(this.label, this.icon, this.width);

  /// Visible label (tooltip).
  final String label;

  /// Toolbar icon.
  final IconData icon;

  /// Fixed frame width, or null for the full card width.
  final double? width;
}

/// Preview height of a block card: tall blocks (dashboards, sidebars,
/// pricing) scroll inside this cap, like the reference's iframes.
const double kBlockPreviewHeight = 640;

/// Shortest frame a block ever gets: short forms (login, otp) fit instead of
/// floating in a 640 px box.
const double kBlockPreviewMinHeight = 360;

/// Natural frame heights of the single-card blocks, measured from the block
/// widgets (card + inner scroll padding + 32 px frame padding, +40 px wrap
/// margin so a 375 px phone never overflows; taller content scrolls inside
/// the bounded frame). Every other block uses [kBlockPreviewHeight].
const Map<String, double> kCompactBlockHeights = <String, double>{
  'otp-01': 520,
  'calendar-01': 520,
  'login-01': 560,
  'login-03': 600,
  'signup-01': 620,
};

/// The device toggle group: three icon buttons, the active one filled.
class BlockViewportToggle extends StatelessWidget {
  /// Creates the toggle group.
  const BlockViewportToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// The selected viewport.
  final BlockViewport value;

  /// Called with the new viewport.
  final ValueChanged<BlockViewport> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final BlockViewport viewport in BlockViewport.values) ...<Widget>[
          if (viewport != BlockViewport.values.first) const Gap(4),
          Tooltip(
            tooltip: (BuildContext context) => Text(viewport.label),
            child: SizedBox(
              width: 28,
              height: 28,
              child: Button(
                variant: value == viewport
                    ? ButtonVariant.secondary
                    : ButtonVariant.ghost,
                size: ButtonSize.xs,
                theme: const ButtonVariantStyle(padding: EdgeInsets.zero),
                onPressed: () => onChanged(viewport),
                child: Icon(viewport.icon, size: 14),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// The framed viewport that hosts the block preview at [viewport]'s width.
///
/// The frame sits *inside* the card's continuous border (the card clips it to
/// the bottom radius): background-token fill, a full border + radius of its
/// own, and the selected width centred — desktop fills the card, tablet and
/// mobile render narrower. The height fits the block between
/// [kBlockPreviewMinHeight] and [kBlockPreviewHeight]; taller content scrolls
/// inside the bounded frame, so short forms never float in empty space.
class BlockPreviewFrame extends StatelessWidget {
  /// Creates the frame.
  const BlockPreviewFrame({
    super.key,
    required this.blockId,
    required this.viewport,
  });

  /// The block id (`dashboard-01`).
  final String blockId;

  /// The selected viewport width.
  final BlockViewport viewport;

  /// Frame height for [blockId]: the compact fit, or the full cap.
  static double heightFor(String blockId) =>
      kCompactBlockHeights[blockId] ?? kBlockPreviewHeight;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double height = heightFor(blockId);
    return Container(
      width: double.infinity,
      color: theme.colors.background,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double available = constraints.maxWidth;
          final double width = viewport.width == null
              ? available
              : (viewport.width! < available ? viewport.width! : available);
          return DecoratedBox(
            key: ValueKey<String>('block-frame-$blockId'),
            decoration: BoxDecoration(
              color: theme.colors.background,
              border: Border.all(color: theme.colors.border),
              borderRadius: theme.borderRadiusLg,
            ),
            child: ClipRRect(
              borderRadius: theme.borderRadiusLg,
              child: SizedBox(
                width: width,
                height: height,
                child: BlockPreviewLoader(blockId: blockId),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Loads one deferred block widget and rebuilds when it arrives.
///
/// The future is cached per block id, so a viewport switch (which rebuilds
/// through the card's state) re-uses the loaded widget instead of refetching
/// its chunk.
class BlockPreviewLoader extends StatefulWidget {
  /// Creates the loader for [blockId].
  const BlockPreviewLoader({super.key, required this.blockId});

  /// The block id.
  final String blockId;

  @override
  State<BlockPreviewLoader> createState() => BlockPreviewLoaderState();
}

/// State of [BlockPreviewLoader] (public for the ~400-line rule).
class BlockPreviewLoaderState extends State<BlockPreviewLoader> {
  Future<Widget>? _future;
  String? _key;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeLoad();
  }

  @override
  void didUpdateWidget(covariant BlockPreviewLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeLoad();
  }

  void _maybeLoad() {
    if (_key != widget.blockId) {
      _key = widget.blockId;
      _future = loadBlockPreview(widget.blockId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return KeyedSubtree(
            key: ValueKey<String>(widget.blockId),
            child: snapshot.data!,
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Preview failed to load',
                style: TextStyle(
                  fontSize: 13,
                  color: ShadcnTheme.of(context).colors.mutedForeground,
                ),
              ),
            ),
          );
        }
        return const Center(child: Spinner());
      },
    );
  }
}
