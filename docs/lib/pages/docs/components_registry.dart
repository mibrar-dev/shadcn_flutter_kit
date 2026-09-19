import 'dart:convert';

import 'package:flutter/services.dart';

/// Component ids added in the upstream-parity wave, badged as New in docs.
const Set<String> kNewComponentIds = {
  'fade_scroll_display',
  'pinned_sheet',
  'page_route',
  'color_field',
  'form_sortable',
  'anchor',
  'backdrop_transform',
  'drawer_container',
  'overlay_configuration',
  'spell_check_suggestions_toolbar',
};

class RegistryComponent {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> tags;
  final String status;

  const RegistryComponent({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tags,
    this.status = 'Stable',
  });

  factory RegistryComponent.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return RegistryComponent(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Misc',
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((tag) => tag.toString())
          .toList(),
      status: kNewComponentIds.contains(id) ? 'New' : 'Stable',
    );
  }
}

const Map<String, RegistryComponent> _docsOnlyDependentEntries = {
  'toggle': RegistryComponent(
    id: 'toggle',
    name: 'Toggle',
    description: 'Docs-only composition example built from button primitives.',
    category: 'control',
    tags: ['docs-only', 'composed', 'button'],
  ),
  'avatar_group': RegistryComponent(
    id: 'avatar_group',
    name: 'Avatar Group',
    description: 'Docs-only composition example built from avatar widgets.',
    category: 'display',
    tags: ['docs-only', 'composed', 'avatar'],
  ),
  'choices': RegistryComponent(
    id: 'choices',
    name: 'Choices',
    description:
        'Docs-only composition example built from multiple_choice widgets.',
    category: 'form',
    tags: ['docs-only', 'composed', 'multiple_choice'],
  ),
  'multiselect': RegistryComponent(
    id: 'multiselect',
    name: 'Multiselect',
    description: 'Docs-only composition example built from select widgets.',
    category: 'form',
    tags: ['docs-only', 'composed', 'select'],
  ),
  'number_input': RegistryComponent(
    id: 'number_input',
    name: 'Number Input',
    description:
        'Docs-only composition example built from text_field + formatter.',
    category: 'form',
    tags: ['docs-only', 'composed', 'text_field'],
  ),
  'radio_card': RegistryComponent(
    id: 'radio_card',
    name: 'Radio Card',
    description:
        'Docs-only composition example built from radio_group widgets.',
    category: 'form',
    tags: ['docs-only', 'composed', 'radio_group'],
  ),
  'app_bar': RegistryComponent(
    id: 'app_bar',
    name: 'App Bar',
    description: 'Docs-only composition example built from scaffold app bar.',
    category: 'layout',
    tags: ['docs-only', 'composed', 'scaffold'],
  ),
  'go_router_app_example': RegistryComponent(
    id: 'go_router_app_example',
    name: 'GoRouter Example (Composed)',
    description:
        'Docs-only composition example showing route-aware app structure.',
    category: 'application',
    tags: ['docs-only', 'composed', 'app', 'router'],
  ),
  'audio_control': RegistryComponent(
    id: 'audio_control',
    name: 'Audio Control (WIP)',
    description: 'Work-in-progress docs entry for media audio controls.',
    category: 'control',
    tags: ['docs-only', 'wip', 'control'],
  ),
  'video_control': RegistryComponent(
    id: 'video_control',
    name: 'Video Control (WIP)',
    description: 'Work-in-progress docs entry for media video controls.',
    category: 'control',
    tags: ['docs-only', 'wip', 'control'],
  ),
  'material': RegistryComponent(
    id: 'material',
    name: 'Material',
    description:
        'Docs-only composition example built from app/card/dialog/button.',
    category: 'layout',
    tags: ['docs-only', 'composed', 'layout'],
  ),
  'expandable_sidebar': RegistryComponent(
    id: 'expandable_sidebar',
    name: 'Expandable Sidebar',
    description:
        'Docs-only composition example built from navigation_bar + outlined_container.',
    category: 'navigation',
    tags: ['docs-only', 'composed', 'navigation_bar'],
  ),
  'navigation_rail': RegistryComponent(
    id: 'navigation_rail',
    name: 'Navigation Rail',
    description:
        'Docs-only composition example built from navigation_bar widgets.',
    category: 'navigation',
    tags: ['docs-only', 'composed', 'navigation_bar'],
  ),
  'navigation_sidebar': RegistryComponent(
    id: 'navigation_sidebar',
    name: 'Navigation Sidebar',
    description:
        'Docs-only composition example built from navigation_bar + outlined_container.',
    category: 'navigation',
    tags: ['docs-only', 'composed', 'navigation_bar'],
  ),
  'sheet': RegistryComponent(
    id: 'sheet',
    name: 'Sheet',
    description: 'Docs-only composition example built from drawer/form/button.',
    category: 'overlay',
    tags: ['docs-only', 'composed', 'drawer'],
  ),
  'linear_gradient_picker': RegistryComponent(
    id: 'linear_gradient_picker',
    name: 'Linear Gradient Picker (WIP)',
    description:
        'Work-in-progress docs entry for gradient picker functionality.',
    category: 'form',
    tags: ['docs-only', 'wip', 'gradient'],
  ),
  'radial_gradient_picker': RegistryComponent(
    id: 'radial_gradient_picker',
    name: 'Radial Gradient Picker (WIP)',
    description:
        'Work-in-progress docs entry for gradient picker functionality.',
    category: 'form',
    tags: ['docs-only', 'wip', 'gradient'],
  ),
  'sweep_gradient_picker': RegistryComponent(
    id: 'sweep_gradient_picker',
    name: 'Sweep Gradient Picker (WIP)',
    description:
        'Work-in-progress docs entry for gradient picker functionality.',
    category: 'form',
    tags: ['docs-only', 'wip', 'gradient'],
  ),
};

Future<List<RegistryComponent>> loadRegistryComponents() async {
  final raw = await rootBundle.loadString('assets/registry/components.json');
  final data = jsonDecode(raw) as Map<String, dynamic>;
  final components = (data['components'] as List<dynamic>? ?? const [])
      .cast<Map<String, dynamic>>()
      .map(RegistryComponent.fromJson)
      .toList();
  final existingIds = components.map((component) => component.id).toSet();
  for (final entry in _docsOnlyDependentEntries.entries) {
    if (!existingIds.contains(entry.key)) {
      components.add(entry.value);
    }
  }
  components.sort((a, b) => a.name.compareTo(b.name));
  return components;
}
