// One block card on the Blocks index and the block page (P6-B3): the title
// row (name, description, viewport toggles and "Open in new tab"), the
// Preview | Code line tabs and the matching body.
//
// The reference tabs sit above the frame and the code tab swaps the iframe for
// the file tree + source; ours keeps that shape with the registry block widget
// and the generated sources.

import 'package:flutter/widgets.dart';

import '../generated/docs_blocks.dart';
import '../routing/docs_router.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/theme.dart';
import 'block_code_panel.dart';
import 'block_viewport.dart';
import 'docs_tokens.dart';

/// The two body views of a block card.
enum BlockCardTab {
  /// The framed, resizable block render.
  preview,

  /// Install command + file tree + highlighted source.
  code,
}

/// The bordered block card: header row, tabs, preview or code body.
class BlockCard extends StatefulWidget {
  /// Creates the card for [block].
  const BlockCard({
    super.key,
    required this.block,
    this.showOpenInNewTab = true,
  });

  /// The block to render.
  final DocsBlock block;

  /// Whether the header offers the `/blocks/<id>` link (the index only: on
  /// the block page it would link to itself).
  final bool showOpenInNewTab;

  @override
  State<BlockCard> createState() => _BlockCardState();
}

class _BlockCardState extends State<BlockCard> {
  BlockCardTab _tab = BlockCardTab.preview;
  BlockViewport _viewport = BlockViewport.desktop;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.background,
        borderRadius: theme.borderRadiusXl,
        border: Border.all(color: theme.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _HeaderRow(
            block: widget.block,
            viewport: _viewport,
            showOpenInNewTab: widget.showOpenInNewTab,
            onViewport: (BlockViewport value) =>
                setState(() => _viewport = value),
          ),
          _TabRow(
            tab: _tab,
            onTab: (BlockCardTab value) => setState(() => _tab = value),
          ),
          if (_tab == BlockCardTab.preview)
            BlockPreviewFrame(blockId: widget.block.id, viewport: _viewport)
          else
            BlockCodePanel(block: widget.block),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.block,
    required this.viewport,
    required this.showOpenInNewTab,
    required this.onViewport,
  });

  final DocsBlock block;
  final BlockViewport viewport;
  final bool showOpenInNewTab;
  final ValueChanged<BlockViewport> onViewport;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Widget info = ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  block.name,
                  style: docsText(
                    context,
                    size: 16,
                    weight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const Gap(4),
                Text(
                  block.description,
                  style: docsText(
                    context,
                    size: 13,
                    height: 1.4,
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          );
          // A Wrap (not a Row): at 375 px the toggle group plus the labelled
          // button do not fit on one line, and a Row would overflow the card.
          final Widget controls = Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              BlockViewportToggle(value: viewport, onChanged: onViewport),
              if (showOpenInNewTab)
                Button(
                  key: const ValueKey<String>('block-open-in-new-tab'),
                  variant: ButtonVariant.outline,
                  size: ButtonSize.sm,
                  leading: const Icon(LucideIcons.externalLink, size: 14),
                  onPressed: () => DocsRouterScope.of(
                    context,
                  ).go(context, '/blocks/${block.id}'),
                  child: const Text('Open in new tab'),
                ),
            ],
          );
          if (constraints.maxWidth < 720) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[info, const Gap(12), controls],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: info),
              const Gap(16),
              controls,
            ],
          );
        },
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({required this.tab, required this.onTab});

  final BlockCardTab tab;
  final ValueChanged<BlockCardTab> onTab;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: <Widget>[
          for (final BlockCardTab value in BlockCardTab.values)
            _LineTab(
              label: switch (value) {
                BlockCardTab.preview => 'Preview',
                BlockCardTab.code => 'Code',
              },
              selected: tab == value,
              onTap: () => onTab(value),
            ),
          const Spacer(),
          // The command hint is decoration: it ellipsises (and hides below
          // 640 px) instead of pushing the line tabs out of the card.
          if (MediaQuery.sizeOf(context).width >= 640)
            Flexible(
              child: Text(
                'flutter_shadcn add',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: docsText(
                  context,
                  size: 11,
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The reference's line tab: text with a 2 px bottom rule when selected.
///
/// Built on `Clickable` (the registry `Button` has no per-state border
/// decoration), exactly like the install block's line tabs.
class _LineTab extends StatelessWidget {
  const _LineTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Clickable(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? theme.colors.primary : const Color(0x00000000),
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: docsText(
            context,
            size: 14,
            weight: FontWeight.w500,
            color: selected
                ? theme.colors.foreground
                : theme.colors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
