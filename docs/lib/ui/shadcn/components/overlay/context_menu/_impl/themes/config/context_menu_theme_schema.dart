// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: convention-based schema generator

import 'dart:convert';

import '../../../../../../shared/theme/schema/component_schema.dart';

class ContextMenuThemeSchema {
  static const String id = 'context_menu';

  static final ComponentSchema schema = ComponentSchema.fromJson(
    jsonDecode(_rawSchema) as Map<String, dynamic>,
  );

  static const String _rawSchema = r'''{
  "id": "context_menu",
  "title": "Context Menu Theme",
  "description": "Desktop-style context menu overlay for editable text and custom actions. Theme tokens and editor schema.",
  "schemaVersion": 1,
  "since": "1.0.0",
  "migrations": {},
  "groups": [
    {
      "title": "Dimensions",
      "fields": [
        {
          "type": "number",
          "name": "maxWidth",
          "label": "Max Width",
          "description": "Max Width in pixels (affected by theme.scaling).",
          "defaultValue": 192.0,
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
        }
      ]
    },
    {
      "title": "Appearance",
      "fields": [
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
      "title": "Animation",
      "fields": [
        {
          "type": "duration",
          "name": "popupAnimationDuration",
          "label": "Popup Animation Duration",
          "description": "Popup Animation Duration in milliseconds.",
          "defaultValue": 100,
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
          "name": "direction",
          "label": "Direction",
          "description": "Direction in pixels (affected by theme.scaling).",
          "defaultValue": "vertical",
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
