// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: convention-based schema generator

import 'dart:convert';

import '../../../../../../shared/theme/schema/component_schema.dart';

class CardThemeSchema {
  static const String id = 'card';

  static final ComponentSchema schema = ComponentSchema.fromJson(
    jsonDecode(_rawSchema) as Map<String, dynamic>,
  );

  static const String _rawSchema = r'''{
  "id": "card",
  "title": "Card Theme",
  "description": "Card container with optional surface blur variant. Theme tokens and editor schema.",
  "schemaVersion": 1,
  "since": "1.0.0",
  "migrations": {},
  "groups": [
    {
      "title": "Dimensions",
      "fields": [
        {
          "type": "number",
          "name": "borderWidth",
          "label": "Border Width",
          "description": "Border Width in pixels (affected by theme.scaling).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 200.0,
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
          "type": "color",
          "name": "borderColor",
          "label": "Border Color",
          "description": "Border Color in hex format (#RRGGBB or #AARRGGBB).",
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
        },
        {
          "type": "number",
          "name": "borderRadius",
          "label": "Border Radius",
          "description": "Border Radius in pixels (affected by theme.radius).",
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
          "type": "number",
          "name": "boxShadow",
          "label": "Box Shadow",
          "description": "Box Shadow in pixels (affected by theme.scaling).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 24.0,
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
        },
        {
          "type": "number",
          "name": "surfaceOpacity",
          "label": "Surface Opacity",
          "description": "Surface Opacity (0.0 = transparent, 1.0 = opaque).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 1.0,
            "step": 0.05
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
          "name": "fillColor",
          "label": "Fill Color",
          "description": "Fill Color in hex format (#RRGGBB or #AARRGGBB).",
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
        }
      ]
    },
    {
      "title": "Animation",
      "fields": [
        {
          "type": "duration",
          "name": "duration",
          "label": "Duration",
          "description": "Duration in milliseconds.",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input",
            "unit": "ms"
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
    },
    {
      "title": "General",
      "fields": [
        {
          "type": "enum",
          "name": "clipBehavior",
          "label": "Clip Behavior",
          "description": "Clip Behavior in pixels (affected by theme.scaling).",
          "defaultValue": "none",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "select"
          },
          "since": "1.0.0"
        },
        {
          "type": "boolean",
          "name": "filled",
          "label": "Filled",
          "description": "Toggle Filled.",
          "defaultValue": false,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input"
          },
          "since": "1.0.0"
        },
        {
          "type": "number",
          "name": "surfaceBlur",
          "label": "Surface Blur",
          "description": "Surface Blur in pixels (affected by theme.scaling).",
          "defaultValue": null,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 100.0,
            "step": 1.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.0.0"
        }
      ]
    }
  ],
  "$schema": "../../../../manifests/component_theme.schema.json"
}''';
}
