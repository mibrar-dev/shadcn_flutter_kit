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

/// Preview height of a block card (the reference's iframes are ~930 px; the
/// blocks scroll internally, so 640 keeps the index page navigable).
const double kBlockPreviewHeight = 640;

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

/// The bordered frame that hosts the block preview at [viewport]'s width.
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

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ClipRect(
      child: Container(
        height: kBlockPreviewHeight,
        width: double.infinity,
        color: theme.colors.muted.withValues(alpha: 0.4),
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double available = constraints.maxWidth;
            final double width = viewport.width == null
                ? available
                : (viewport.width! < available ? viewport.width! : available);
            return DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colors.background,
                border: Border.symmetric(
                  vertical: BorderSide(color: theme.colors.border),
                ),
              ),
              child: SizedBox(
                width: width,
                height: kBlockPreviewHeight,
                child: BlockPreviewLoader(blockId: blockId),
              ),
            );
          },
        ),
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
