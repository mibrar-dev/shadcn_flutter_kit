// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: convention-based schema generator

import 'dart:convert';

import '../../../../../../shared/theme/schema/component_schema.dart';

class EmptyStateThemeSchema {
  static const String id = 'empty_state';

  static final ComponentSchema schema = ComponentSchema.fromJson(
    jsonDecode(_rawSchema) as Map<String, dynamic>,
  );

  static const String _rawSchema = r'''{
  "id": "empty_state",
  "title": "Empty State Theme",
  "description": "Standardized empty state block for empty, no-results, or error. Theme tokens and editor schema.",
  "schemaVersion": 1,
  "since": "1.0.0",
  "migrations": {},
  "groups": [
    {
      "title": "Dimensions",
      "fields": [
        {
          "type": "number",
          "name": "iconContainerPadding",
          "label": "Icon Container Padding",
          "description": "Icon Container Padding in pixels (affected by theme.scaling).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "spacing.md",
            "allowedFamilies": [
              "spacing"
            ]
          },
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 48.0,
            "step": 4.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.0.0"
        },
        {
          "type": "number",
          "name": "maxWidth",
          "label": "Max Width",
          "description": "Max Width in pixels (affected by theme.scaling).",
          "defaultValue": 520.0,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 520.0,
            "step": 4.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.0.0"
        },
        {
          "type": "number",
          "name": "padding",
          "label": "Padding",
          "description": "Padding in pixels (affected by theme.scaling).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "spacing.md",
            "allowedFamilies": [
              "spacing"
            ]
          },
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 48.0,
            "step": 4.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.0.0"
        }
      ]
    },
    {
      "title": "Appearance",
      "fields": [
        {
          "type": "number",
          "name": "cardBorderRadius",
          "label": "Card Border Radius",
          "description": "Card Border Radius in pixels (affected by theme.radius).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "radius.md",
            "allowedFamilies": [
              "radius"
            ]
          },
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 32.0,
            "step": 1.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.0.0"
        },
        {
          "type": "color",
          "name": "iconContainerBorderColor",
          "label": "Icon Container Border Color",
          "description": "Icon Container Border Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#E5E5E5",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "palette.primary",
            "allowedFamilies": [
              "palette"
            ]
          },
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "color"
          },
          "since": "1.0.0"
        },
        {
          "type": "number",
          "name": "iconContainerBorderRadius",
          "label": "Icon Container Border Radius",
          "description": "Icon Container Border Radius in pixels (affected by theme.radius).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "radius.md",
            "allowedFamilies": [
              "radius"
            ]
          },
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 32.0,
            "step": 1.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.0.0"
        },
        {
          "type": "boolean",
          "name": "ignoreGlobalRadius",
          "label": "Ignore Global Radius",
          "description": "Override global theme setting.",
          "defaultValue": false,
          "required": false,
          "isAdvanced": true,
          "visibleIf": [],
          "tokenBinding": {
            "path": "radius.md",
            "allowedFamilies": [
              "radius"
            ]
          },
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input"
          },
          "since": "1.0.0"
        }
      ]
    },
    {
      "title": "Typography",
      "fields": [
        {
          "type": "color",
          "name": "iconColor",
          "label": "Icon Color",
          "description": "Icon Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#737373",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "palette.primary",
            "allowedFamilies": [
              "palette"
            ]
          },
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "color"
          },
          "since": "1.0.0"
        },
        {
          "type": "color",
          "name": "iconContainerColor",
          "label": "Icon Container Color",
          "description": "Icon Container Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#F5F5F5",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "palette.primary",
            "allowedFamilies": [
              "palette"
            ]
          },
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "color"
          },
          "since": "1.0.0"
        },
        {
          "type": "number",
          "name": "iconSize",
          "label": "Icon Size",
          "description": "Icon Size in pixels (affected by theme.scaling).",
          "defaultValue": 36.0,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject",
            "min": 12.0,
            "max": 48.0,
            "step": 2.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.0.0"
        }
      ]
    },
    {
      "title": "Colors",
      "fields": [
        {
          "type": "color",
          "name": "cardFillColor",
          "label": "Card Fill Color",
          "description": "Card Fill Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "tokenBinding": {
            "path": "palette.primary",
            "allowedFamilies": [
              "palette"
            ]
          },
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "color"
          },
          "since": "1.0.0"
        }
      ]
    },
    {
      "title": "Advanced",
      "fields": [
        {
          "type": "boolean",
          "name": "ignoreGlobalScaling",
          "label": "Ignore Global Scaling",
          "description": "Override global theme setting.",
          "defaultValue": false,
          "required": false,
          "isAdvanced": true,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input"
          },
          "since": "1.0.0"
        }
      ]
    }
  ],
  "$schema": "../../../../manifests/component_theme.schema.json"
}''';
}
