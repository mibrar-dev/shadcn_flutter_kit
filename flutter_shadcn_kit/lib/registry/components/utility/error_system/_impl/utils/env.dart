// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Env: compile-time flags for error system behavior.
// Controls whether technicalDetails are attached/visible (SHADCN_SHOW_TECHNICAL_ERRORS).

/// Env defines a reusable type for this registry module.
class Env {
  static bool showTechnicalDetails = const bool.fromEnvironment(
    'SHADCN_SHOW_TECHNICAL_ERRORS',
    defaultValue: false,
  );
}
