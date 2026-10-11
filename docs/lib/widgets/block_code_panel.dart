// The block card's Code view (P6-B3): the CLI install command with a copy
// button, the block's file tree, and the selected file's highlighted,
// selectable source — the same three things the reference `/blocks` code tab
// shows for `npx shadcn add <id>`.
//
// Sources come from the generated `kBlockFileSources` (verbatim registry
// source + 4-class highlight map), never from a re-typed copy.

import 'package:flutter/widgets.dart';

import '../blocks/block_sources.dart';
import '../generated/docs_blocks.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/divider/divider.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/theme.dart';
import 'code_spans.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';
import 'selectable_code.dart';

/// Height of the code pane (the reference's expanded pane is ~289 px; a block
/// file is longer, so the blocks pane scrolls at 360 px).
const double kBlockCodeHeight = 360;

/// Install command + file tree + highlighted source for one block.
class BlockCodePanel extends StatefulWidget {
  /// Creates the panel for [block].
  const BlockCodePanel({super.key, required this.block});

  /// The block whose files are shown.
  final DocsBlock block;

  @override
  State<BlockCodePanel> createState() => _BlockCodePanelState();
}

class _BlockCodePanelState extends State<BlockCodePanel> {
  int _selected = 0;

  List<DocsBlockFile> get _files =>
      kBlockFileSources[widget.block.id] ?? const <DocsBlockFile>[];

  @override
  Widget build(BuildContext context) {
    final List<DocsBlockFile> files = _files;
    if (files.isEmpty) {
      return _empty(context, 'No files listed for this block.');
    }
    final int index = _selected.clamp(0, files.length - 1);
    final DocsBlockFile file = files[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _InstallRow(command: widget.block.install),
        const Divider(thickness: 1),
        SizedBox(
          height: kBlockCodeHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _FileTree(
                files: files,
                selected: index,
                onSelect: (int i) => setState(() => _selected = i),
              ),
              const _VerticalRule(),
              Expanded(child: _SourcePane(file: file)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _empty(BuildContext context, String message) {
    return Container(
      height: kBlockCodeHeight,
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(
          fontSize: 13,
          color: ShadcnTheme.of(context).colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The `flutter_shadcn add <id>` row with a copy button.
class _InstallRow extends StatelessWidget {
  const _InstallRow({required this.command});

  final String command;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: <Widget>[
          Icon(
            LucideIcons.terminal,
            size: 16,
            color: theme.colors.foreground.withValues(alpha: 0.7),
          ),
          const Gap(8),
          Expanded(
            child: SelectableCode(
              child: Text(
                command,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.typography.mono.copyWith(fontSize: 13),
              ),
            ),
          ),
          const Gap(8),
          CopyButton(
            text: command,
            variant: ButtonVariant.ghost,
            size: ButtonSize.sm,
          ),
        ],
      ),
    );
  }
}

/// The highlighted, scrollable, selectable source of the selected file.
class _SourcePane extends StatelessWidget {
  const _SourcePane({required this.file});

  final DocsBlockFile file;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final DocsSiteColors site = DocsSiteColors.of(context);
    final bool dark = site.codeSurface == const Color(0xFF161616);
    final TextStyle base = theme.typography.mono.copyWith(
      fontSize: 13,
      height: 20 / 13,
    );
    return ColoredBox(
      color: site.codeSurface,
      child: ScrollConfiguration(
        behavior: const DocsScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SelectableCode(
            child: Text.rich(
              TextSpan(
                children: codeSpans(
                  code: file.code,
                  tokenClasses: file.tokenClasses,
                  plain: base.copyWith(
                    color: dark
                        ? const Color(0xFFE5E5E5)
                        : const Color(0xFF262626),
                  ),
                  comment: base.copyWith(color: site.codeNumber),
                  keyword: base.copyWith(color: const Color(0xFF79C0FF)),
                  string: base.copyWith(color: const Color(0xFFA5D6FF)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The block's files as a selectable tree (one level: file names).
class _FileTree extends StatelessWidget {
  const _FileTree({
    required this.files,
    required this.selected,
    required this.onSelect,
  });

  final List<DocsBlockFile> files;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: ScrollConfiguration(
        behavior: const DocsScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < files.length; i++)
                _FileRow(
                  name: files[i].name,
                  selected: i == selected,
                  onPressed: () => onSelect(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({
    required this.name,
    required this.selected,
    required this.onPressed,
  });

  final String name;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Clickable(
      onPressed: onPressed,
      decoration: WidgetStateProperty.resolveWith<Decoration?>((
        Set<WidgetState> states,
      ) {
        if (selected) {
          return BoxDecoration(
            color: theme.colors.muted,
            borderRadius: theme.borderRadiusSm,
          );
        }
        if (states.contains(WidgetState.hovered)) {
          return BoxDecoration(
            color: theme.colors.muted.withValues(alpha: 0.5),
            borderRadius: theme.borderRadiusSm,
          );
        }
        return const BoxDecoration();
      }),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle?>(
        theme.typography.mono.copyWith(fontSize: 12.5),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            LucideIcons.fileCode,
            size: 14,
            color: theme.colors.mutedForeground,
          ),
          const Gap(8),
          Expanded(
            child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// A 1 px vertical rule between the file tree and the source pane.
class _VerticalRule extends StatelessWidget {
  const _VerticalRule();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      child: ColoredBox(
        color: ShadcnTheme.of(context).colors.border.withValues(alpha: 0.3),
      ),
    );
  }
}
