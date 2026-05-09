// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart';

/// Metadata for a single preview variant demonstration
class PreviewVariant {
  /// Unique identifier for this variant
  final String id;

  /// Human-readable title for this variant
  final String title;

  /// Builder function that creates the widget preview for this variant
  final Widget Function(BuildContext context) builder;

  const PreviewVariant({
    required this.id,
    required this.title,
    required this.builder,
  });
}

/// Metadata for a complete component preview entry
class PreviewEntry {
  /// Unique component identifier (e.g., 'button', 'card')
  final String id;

  /// Display name of the component
  final String title;

  /// Short description of what this component does
  final String description;

  /// Category grouping (e.g., 'Control', 'Layout', 'Form')
  final String category;

  /// Tags for searching/filtering
  final List<String> tags;

  /// Example usage code snippet
  final String usageCode;

  /// List of preview variants demonstrating different states/configurations
  final List<PreviewVariant> variants;

  const PreviewEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.usageCode,
    required this.variants,
  });
}
