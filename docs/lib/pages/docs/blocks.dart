import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../docs_page.dart';
import '../../code_highlighter.dart';
import '../../ui/shadcn/components/control/button/button.dart';
import '../../ui/shadcn/components/layout/outlined_container/outlined_container.dart';
import '../../ui/shadcn/shared/primitives/text.dart';

class DocsSectionTitle extends StatelessWidget {
  final String title;
  final OnThisPage? anchor;

  const DocsSectionTitle({super.key, required this.title, this.anchor});

  @override
  Widget build(BuildContext context) {
    final heading = Text(title).h2();
    if (anchor == null) {
      return heading;
    }
    return PageItemWidget(onThisPage: anchor!, child: heading);
  }
}

class DocsParagraph extends StatelessWidget {
  final String text;
  final bool muted;
  final TextAlign textAlign;

  const DocsParagraph({
    super.key,
    required this.text,
    this.muted = false,
    this.textAlign = TextAlign.justify,
  });

  @override
  Widget build(BuildContext context) {
    final content = Text(text, textAlign: textAlign).base();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: muted ? content.muted() : content,
    );
  }
}

class DocsBulletList extends StatelessWidget {
  final List<String> items;

  const DocsBulletList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•').base(),
                const SizedBox(width: 8),
                Expanded(child: Text(item).base()),
              ],
            ),
          ),
      ],
    );
  }
}

class DocsCodeBlock extends StatelessWidget {
  final String code;
  final String mode;

  const DocsCodeBlock({
    super.key,
    required this.code,
    this.mode = 'dart',
  });

  @override
  Widget build(BuildContext context) {
    return CodeBlock(code: code, mode: mode);
  }
}

class DocsOptionRow {
  final String name;
  final String value;
  final String description;

  const DocsOptionRow({
    required this.name,
    required this.value,
    required this.description,
  });
}

class DocsOptionsTable extends StatelessWidget {
  final List<DocsOptionRow> rows;

  const DocsOptionsTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }
    return OutlinedContainer(
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(1.4),
          1: FlexColumnWidth(1.1),
          2: FlexColumnWidth(3.2),
        },
        border: TableBorder.symmetric(
          inside: BorderSide(color: Theme.of(context).dividerColor),
        ),
        children: [
          TableRow(
            children: [
              _DocsTableCell(
                isHeader: true,
                child: const Text('Flag').semiBold(),
              ),
              _DocsTableCell(
                isHeader: true,
                child: const Text('Value').semiBold(),
              ),
              _DocsTableCell(
                isHeader: true,
                child: const Text('Description').semiBold(),
              ),
            ],
          ),
          for (final row in rows)
            TableRow(
              children: [
                _DocsTableCell(
                  child: Text(row.name).mono().small(),
                ),
                _DocsTableCell(
                  child: Text(row.value).small().muted(),
                ),
                _DocsTableCell(
                  child: Text(row.description).small(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DocsTableCell extends StatelessWidget {
  final Widget child;
  final bool isHeader;

  const _DocsTableCell({
    required this.child,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final headerBackground = colorScheme.brightness == Brightness.dark
        ? colorScheme.onSurface.withValues(alpha: 0.08)
        : colorScheme.surface;
    final headerForeground = colorScheme.onSurface;
    final content = isHeader
        ? DefaultTextStyle.merge(
            style: TextStyle(color: headerForeground),
            child: child,
          )
        : child;
    return Container(
      color: isHeader ? headerBackground : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: content,
    );
  }
}

class DocsLinkRow extends StatelessWidget {
  final String label;
  final String url;

  const DocsLinkRow({super.key, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label).base(),
        const SizedBox(width: 8),
        LinkButton(
          onPressed: () => launchUrlString(url),
          child: Text(url),
        ),
      ],
    );
  }
}

class DocsLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String url;

  const DocsLinkCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      child: InkWell(
        onTap: () => launchUrlString(url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title).base().semiBold(),
                    const SizedBox(height: 4),
                    Text(description).xSmall().muted(),
                    const SizedBox(height: 6),
                    Text(url).xSmall(),
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
