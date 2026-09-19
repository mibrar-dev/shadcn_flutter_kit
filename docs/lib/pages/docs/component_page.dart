import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../docs_page.dart';
import 'widget_usage_example.dart';
import '../../ui/shadcn/shared/primitives/text.dart';
import '../../ui/shadcn/components/control/button/button.dart'
    as shadcn_buttons;

class ComponentPage extends StatefulWidget {
  final String name;
  final String displayName;
  final String description;
  final List<Widget> children;
  final bool component;
  final String? category;
  final Map<String, OnThisPage>? onThisPageOverride;

  /// Optional status badge (e.g. New) rendered next to the title.
  final Widget? statusBadge;

  const ComponentPage({
    super.key,
    required this.name,
    required this.description,
    required this.displayName,
    required this.children,
    this.component = true,
    this.category,
    this.onThisPageOverride,
    this.statusBadge,
  });

  @override
  State<ComponentPage> createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  final List<GlobalKey> keys = [];
  final Map<String, OnThisPage> onThisPage = {};

  @override
  void initState() {
    super.initState();
    _syncAnchors();
  }

  @override
  void didUpdateWidget(covariant ComponentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onThisPageOverride != null) {
      return;
    }
    if (!listEquals(oldWidget.children, widget.children)) {
      _syncAnchors();
    }
  }

  void _syncAnchors() {
    if (widget.onThisPageOverride != null) {
      return;
    }
    keys.clear();
    onThisPage.clear();
    for (final child in widget.children) {
      if (child is! WidgetUsageExample) {
        continue;
      }
      final title = child.title;
      if (title == null) {
        continue;
      }
      keys.add(GlobalKey());
      onThisPage[title] = OnThisPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onThisPageOverride != null) {
      return DocsPage(
        name: widget.name,
        onThisPage: widget.onThisPageOverride!,
        navigationItems: [
          if (widget.component)
            shadcn_buttons.LinkButton(
              density: shadcn_buttons.ButtonDensity.compact,
              onPressed: () => context.goNamed('components'),
              child: const Text('Components'),
            ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: SelectableText(widget.displayName).h1()),
                if (widget.statusBadge != null) ...[
                  const SizedBox(width: 12),
                  widget.statusBadge!,
                ],
              ],
            ),
            SelectableText(widget.description).lead(),
            if (widget.category != null) ...[
              const SizedBox(height: 8),
              Text('Category: ${widget.category}').small().muted(),
            ],
            const SizedBox(height: 16),
            ...widget.children,
          ],
        ),
      );
    }

    final remappedChildren = <Widget>[];
    var index = 0;
    for (final child in widget.children) {
      if (child is! WidgetUsageExample) {
        remappedChildren.add(child);
        continue;
      }
      final title = child.title;
      if (title == null) {
        continue;
      }
      remappedChildren.add(
        PageItemWidget(
          onThisPage: onThisPage[title]!,
          key: keys[index],
          child: child,
        ),
      );
      index += 1;
    }

    return DocsPage(
      name: widget.name,
      onThisPage: onThisPage,
      navigationItems: [
        if (widget.component)
          shadcn_buttons.LinkButton(
            density: shadcn_buttons.ButtonDensity.compact,
            onPressed: () => context.goNamed('components'),
            child: const Text('Components'),
          ),
      ],
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: SelectableText(widget.displayName).h1()),
                if (widget.statusBadge != null) ...[
                  const SizedBox(width: 12),
                  widget.statusBadge!,
                ],
              ],
            ),
            SelectableText(widget.description).lead(),
            if (widget.category != null) ...[
              const SizedBox(height: 8),
              Text('Category: ${widget.category}').small().muted(),
            ],
            const SizedBox(height: 16),
            ...remappedChildren,
          ],
      ),
    );
  }
}
