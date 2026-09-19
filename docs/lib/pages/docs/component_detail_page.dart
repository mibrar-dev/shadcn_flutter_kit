import 'package:flutter/material.dart';

import 'component_page.dart';
import 'component_examples.dart';
import 'component_previews.dart';
import 'components_registry.dart';
import '../../ui/shadcn/components/control/button/button.dart'
    as shadcn_buttons;
import '../../ui/shadcn/components/form/slider/slider.dart' as shadcn_slider;
import '../../ui/shadcn/components/form/switch/switch.dart' as shadcn_switch;
import '../../ui/shadcn/components/layout/outlined_container/outlined_container.dart';
import '../../ui/shadcn/shared/primitives/text.dart';
import '../../ui/shadcn/shared/theme/theme.dart' as shadcn_theme;
import 'widget_usage_example.dart';
import 'package:go_router/go_router.dart';

class ComponentDetailPage extends StatefulWidget {
  final String componentId;

  const ComponentDetailPage({super.key, required this.componentId});

  @override
  State<ComponentDetailPage> createState() => _ComponentDetailPageState();
}

class _ComponentDetailPageState extends State<ComponentDetailPage> {
  static const List<int> _maxRenderedOptions = [4, 6, 8, 12, 20];

  bool _performanceMode = false;
  double _lazyThreshold = 0.1;
  int _maxRendered = 6;

  static const Map<String, List<String>> _dependentComponentSets = {
    'toggle': ['button'],
    'avatar_group': ['avatar'],
    'choices': ['multiple_choice'],
    'multiselect': ['select', 'chip', 'button'],
    'number_input': ['text_field', 'formatter'],
    'radio_card': ['radio_group', 'card'],
    'app_bar': ['scaffold', 'button', 'outlined_container'],
    'material': ['app', 'card', 'alert_dialog', 'button'],
    'expandable_sidebar': ['navigation_bar', 'outlined_container'],
    'navigation_rail': ['navigation_bar'],
    'navigation_sidebar': ['navigation_bar', 'outlined_container'],
    'sheet': ['drawer', 'form', 'alert_dialog', 'button'],
  };

  String _singleInstallCommandFor(String id) {
    return 'flutter_shadcn add $id';
  }

  String _exactInstallCommandFor(String id) {
    final deps = _dependentComponentSets[id];
    if (deps == null || deps.isEmpty) {
      return _singleInstallCommandFor(id);
    }
    return 'flutter_shadcn add ${deps.join(' ')}';
  }

  String _toKebabCase(String value) {
    return value.replaceAll('_', '-');
  }

  Widget? _buildDependentSetupPanel(String componentId) {
    final deps = _dependentComponentSets[componentId];
    if (deps == null || deps.isEmpty) {
      return null;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: OutlinedContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Install Options').semiBold(),
              const SizedBox(height: 8),
              const Text(
                'Use the exact command below if you want this docs example to work as-is. '
                'Or install individual widgets and customize composition yourself.',
              ).muted(),
              const SizedBox(height: 12),
              const Text('Exact Example Command').small().semiBold(),
              const SizedBox(height: 6),
              SelectableText(_exactInstallCommandFor(componentId))
                  .small()
                  .mono(),
              const SizedBox(height: 12),
              const Text('Single Widget Commands').small().semiBold(),
              const SizedBox(height: 6),
              for (final dep in deps)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SelectableText(_singleInstallCommandFor(dep))
                      .small()
                      .mono(),
                ),
              const SizedBox(height: 12),
              const Text('Required Components').small().semiBold(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final dep in deps)
                    shadcn_buttons.LinkButton(
                      density: shadcn_buttons.ButtonDensity.compact,
                      onPressed: () => context.goNamed(
                        'component_detail',
                        pathParameters: {'id': _toKebabCase(dep)},
                      ),
                      child: Text(dep),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = shadcn_theme.Theme.of(context);
    final spacing = theme.spacing;
    return FutureBuilder<List<RegistryComponent>>(
      future: loadRegistryComponents(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!originalComponentIds.contains(widget.componentId)) {
          return ComponentPage(
            name: widget.componentId,
            description: 'Component not available in the original docs app.',
            displayName: widget.componentId,
            category: 'Unavailable',
            children: [
              const Text('No examples available for this component.').muted(),
            ],
          );
        }

        final component = snapshot.data!
            .firstWhere((item) => item.id == widget.componentId, orElse: () {
          return RegistryComponent(
            id: widget.componentId,
            name: widget.componentId,
            description: 'Component not found in registry.',
            category: 'Unknown',
            tags: const [],
          );
        });

        final examples = examplesForComponent(component.id);

        if (examples.isNotEmpty) {
          final maxRendered = _performanceMode ? _maxRendered : examples.length;
          final visibleExamples = examples.take(maxRendered).toList();
          final hiddenCount = examples.length - visibleExamples.length;
          return ComponentPage(
            name: component.id,
            description: component.description,
            displayName: component.name,
            category: component.category,
            statusBadge: component.status == 'Stable'
                ? null
                : buildStatusBadge(component.status),
            children: [
              if (component.id == 'error_system')
                OutlinedContainer(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Quick Start Guide').semiBold(),
                              SizedBox(height: spacing.xs),
                              const Text(
                                'Open the full guide with setup, rules, and best practices.',
                              ).muted(),
                            ],
                          ),
                        ),
                        shadcn_buttons.PrimaryButton(
                          onPressed: () => context
                              .go('/components/error-system/quick-start'),
                          child: const Text('Open guide'),
                        ),
                      ],
                    ),
                  ),
                ),
              _buildPerformanceControls(
                totalExamples: examples.length,
                hiddenCount: hiddenCount,
              ),
              if (_buildDependentSetupPanel(component.id) != null)
                _buildDependentSetupPanel(component.id)!,
              for (var index = 0; index < visibleExamples.length; index++)
                WidgetUsageExample(
                  key: ValueKey(
                    'example-${component.id}-$index-${visibleExamples[index].title}-${visibleExamples[index].code.hashCode}',
                  ),
                  title: visibleExamples[index].title,
                  code: visibleExamples[index].code,
                  lazyThreshold: _performanceMode ? _lazyThreshold : 0.1,
                  previewPadding: EdgeInsets.all(spacing.xxl),
                  previewFullBleed: false,
                  previewMinHeight: null,
                  installCommand:
                      index == 0 ? _exactInstallCommandFor(component.id) : null,
                  child: visibleExamples[index].builder(context),
                ),
              if (hiddenCount > 0)
                shadcn_buttons.LinkButton(
                  onPressed: () => setState(() {
                    _performanceMode = false;
                  }),
                  child: Text('Show all ${examples.length} examples'),
                ),
            ],
          );
        }

        return ComponentPage(
          name: component.id,
          description: component.description,
          displayName: component.name,
          category: component.category,
          statusBadge: component.status == 'Stable'
              ? null
              : buildStatusBadge(component.status),
          children: [
            _buildPerformanceControls(
              totalExamples: 0,
              hiddenCount: 0,
            ),
            if (_buildDependentSetupPanel(component.id) != null)
              _buildDependentSetupPanel(component.id)!,
            WidgetUsageExample(
              title: 'Preview',
              code: '// Example coming soon',
              installCommand: _exactInstallCommandFor(component.id),
              child: buildComponentPreview(
                context,
                component.id,
                label: component.name,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPerformanceControls({
    required int totalExamples,
    required int hiddenCount,
  }) {
    final spacing = shadcn_theme.Theme.of(context).spacing;
    final thresholdLabel = (_lazyThreshold * 100).round();
    final selectedMax = _maxRenderedOptions.contains(_maxRendered)
        ? _maxRendered
        : _maxRenderedOptions.first;
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Performance mode').semiBold(),
        SizedBox(height: spacing.sm),
        shadcn_switch.Switch(
          value: _performanceMode,
          onChanged: (value) => setState(() {
            _performanceMode = value;
            if (!_maxRenderedOptions.contains(_maxRendered)) {
              _maxRendered = _maxRenderedOptions.first;
            }
          }),
          trailing: const Text('Enable performance mode'),
        ),
        SizedBox(height: spacing.md),
        Opacity(
          opacity: _performanceMode
              ? 1
              : (Theme.of(context).brightness == Brightness.dark ? 0.72 : 0.55),
          child: IgnorePointer(
            ignoring: !_performanceMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lazy-load threshold: $thresholdLabel%').small(),
                SizedBox(height: spacing.sm),
                shadcn_slider.Slider.single(
                  value: _lazyThreshold,
                  min: 0.05,
                  max: 0.75,
                  onChanged: (value) => setState(() {
                    _lazyThreshold = value;
                  }),
                ),
                SizedBox(height: spacing.md),
                Row(
                  children: [
                    const Text('Max rendered examples:').small(),
                    SizedBox(width: spacing.sm),
                    DropdownButton<int>(
                      value: selectedMax,
                      onChanged: (value) => setState(() {
                        if (value != null) {
                          _maxRendered = value;
                        }
                      }),
                      items: [
                        for (final option in _maxRenderedOptions)
                          DropdownMenuItem(
                            value: option,
                            child: Text('$option'),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (totalExamples > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              hiddenCount > 0
                  ? 'Showing ${totalExamples - hiddenCount} of $totalExamples examples.'
                  : 'Showing all $totalExamples examples.',
            ).small(),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: OutlinedContainer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: controls,
        ),
      ),
    );
  }
}
