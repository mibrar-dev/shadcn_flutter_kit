// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: convention-based schema generator

import 'dart:convert';

import '../../../../../../shared/theme/schema/component_schema.dart';

class HiddenThemeSchema {
  static const String id = 'hidden';

  static final ComponentSchema schema = ComponentSchema.fromJson(
    jsonDecode(_rawSchema) as Map<String, dynamic>,
  );

  static const String _rawSchema = r'''{
  "id": "hidden",
  "title": "Hidden Theme",
  "description": "Animated visibility helper with axis-aware size control. Theme tokens and editor schema.",
  "schemaVersion": 1,
  "since": "1.0.0",
  "migrations": {},
  "groups": [
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
          "defaultValue": 150,
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
          "name": "curve",
          "label": "Curve",
          "description": "Curve in pixels (affected by theme.scaling).",
          "defaultValue": "easeInOut",
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
          "type": "enum",
          "name": "direction",
          "label": "Direction",
          "description": "Direction in pixels (affected by theme.scaling).",
          "defaultValue": "horizontal",
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
          "name": "keepCrossAxisSize",
          "label": "Keep Cross Axis Size",
          "description": "Toggle Keep Cross Axis Size.",
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
          "type": "boolean",
          "name": "keepMainAxisSize",
          "label": "Keep Main Axis Size",
          "description": "Toggle Keep Main Axis Size.",
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
          "type": "boolean",
          "name": "reverse",
          "label": "Reverse",
          "description": "Toggle Reverse.",
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
        }
      ]
    }
  ],
  "$schema": "../../../../manifests/component_theme.schema.json"
}''';
}
