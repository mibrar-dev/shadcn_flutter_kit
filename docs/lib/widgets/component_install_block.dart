// The install block for component pages (spec §2.4): a code figure with
// Command|Manual line tabs, package-manager pill tabs, and a copy button.
// The Manual tab lists the exact generated file list from the manifest.

import 'package:flutter/widgets.dart';

import '../generated/docs_snippets.dart';
import '../ui/shadcn/components/badge/badge.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/primitives/syntax_highlight/syntax_highlight.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_tokens.dart';
import 'heading_anchor.dart';

/// The install block: line tabs + pill tabs + code figure.
class ComponentInstallBlock extends StatefulWidget {
  /// Creates the install block for [componentId].
  const ComponentInstallBlock({super.key, required this.componentId});

  /// The registry component id.
  final String componentId;

  @override
  State<ComponentInstallBlock> createState() => _ComponentInstallBlockState();
}

class _ComponentInstallBlockState extends State<ComponentInstallBlock> {
  int _lineTab = 0;
  int _pillTab = 0;

  static const List<String> _packageManagers = <String>[
    'flutter_shadcn',
    'dart',
    'flutter',
  ];

  String get _command {
    final String pm = _packageManagers[_pillTab];
    return pm == 'flutter_shadcn'
        ? 'flutter_shadcn add ${widget.componentId}'
        : '$pm pub add shadcn_flutter_kit';
  }

  @override
  Widget build(BuildContext context) {
    final DocsFileList files = kComponentFileLists[widget.componentId]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const HeadingAnchor(id: 'installation', title: 'Installation'),
        const Gap(16),
        // Spec §2.4: the Command|Manual line tabs sit ABOVE the figure
        // (`TabsList` is transparent), not inside its header row.
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _LineTab(
              label: 'Command',
              selected: _lineTab == 0,
              onTap: () => setState(() => _lineTab = 0),
            ),
            _LineTab(
              label: 'Manual',
              selected: _lineTab == 1,
              onTap: () => setState(() => _lineTab = 1),
            ),
          ],
        ),
        const Gap(12),
        _InstallFigure(
          lineTab: _lineTab,
          pillTab: _pillTab,
          command: _command,
          files: files,
          onPillTab: (int i) => setState(() => _pillTab = i),
        ),
      ],
    );
  }
}

class _InstallFigure extends StatelessWidget {
  const _InstallFigure({
    required this.lineTab,
    required this.pillTab,
    required this.command,
    required this.files,
    required this.onPillTab,
  });

  final int lineTab;
  final int pillTab;
  final String command;
  final DocsFileList files;
  final ValueChanged<int> onPillTab;

  @override
  Widget build(BuildContext context) {
    final DocsSiteColors site = DocsSiteColors.of(context);
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: site.codeSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: <Widget>[
          // Header row: terminal glyph + pill tabs (left) + copy (right).
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colors.border.withValues(alpha: 0.3),
                ),
              ),
            ),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (int i = 0; i < _packageManagers.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: _PillTab(
                              label: _packageManagers[i],
                              selected: pillTab == i,
                              onTap: () => onPillTab(i),
                            ),
                          ),
                      ],
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
          ),
          // Body.
          _InstallBody(lineTab: lineTab, command: command, files: files),
        ],
      ),
    );
  }

  static const List<String> _packageManagers = <String>[
    'flutter_shadcn',
    'dart',
    'flutter',
  ];
}

/// The figure body: the command text (Command tab) or the generated file
/// list (Manual tab).
class _InstallBody extends StatelessWidget {
  const _InstallBody({
    required this.lineTab,
    required this.command,
    required this.files,
  });

  final int lineTab;
  final String command;
  final DocsFileList files;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    if (lineTab == 0) {
      // The command is a shell snippet: highlight it with the theme's
      // `syntax` token group. Selection/copy still yields the plain text.
      final TextStyle style = theme.typography.mono.copyWith(
        fontSize: 14,
        height: 24.5 / 14,
      );
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Text.rich(
          syntaxTextSpan(
            code: command,
            language: SyntaxLanguage.bash,
            base: style,
            colors: theme.syntaxColors,
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final String file in files.files)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                file,
                style: theme.typography.mono.copyWith(fontSize: 13),
              ),
            ),
          for (final String file in files.userOwned)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      file,
                      style: theme.typography.mono.copyWith(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(8),
                  Badge(
                    variant: BadgeVariant.outline,
                    child: const Text('user-owned'),
                  ),
                ],
              ),
            ),
          const Gap(8),
          Text(
            kUserOwnedNote,
            style: docsText(
              context,
              size: 12,
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

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

class _PillTab extends StatelessWidget {
  const _PillTab({
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
          color: selected ? theme.colors.background : const Color(0x00000000),
          border: Border.all(
            color: selected ? theme.colors.input : const Color(0x00000000),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: docsText(context, size: 12.8, weight: FontWeight.w500),
        ),
      ),
    );
  }
}
