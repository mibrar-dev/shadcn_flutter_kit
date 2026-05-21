// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: convention-based schema generator

import 'dart:convert';

import '../../../../../../shared/theme/schema/component_schema.dart';

class InputOtpThemeSchema {
  static const String id = 'input_otp';

  static final ComponentSchema schema = ComponentSchema.fromJson(
    jsonDecode(_rawSchema) as Map<String, dynamic>,
  );

  static const String _rawSchema = r'''{
  "id": "input_otp",
  "title": "Input OTP Theme",
  "description": "Fixed-length OTP input field with clipboard integration, paste handling, and focus management. Theme tokens and editor schema.",
  "schemaVersion": 1,
  "since": "1.0.0",
  "migrations": {},
  "groups": [
    {
      "title": "Dimensions",
      "fields": [
        {
          "type": "number",
          "name": "height",
          "label": "Height",
          "description": "Height in pixels (affected by theme.scaling).",
          "defaultValue": 36.0,
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
          "name": "spacing",
          "label": "Spacing",
          "description": "Spacing in pixels (affected by theme.scaling).",
          "defaultValue": 8.0,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject",
            "min": 0.0,
            "max": 32.0,
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
