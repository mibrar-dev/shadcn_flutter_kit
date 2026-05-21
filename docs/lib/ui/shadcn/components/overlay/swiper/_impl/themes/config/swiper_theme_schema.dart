// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: convention-based schema generator

import 'dart:convert';

import '../../../../../../shared/theme/schema/component_schema.dart';

class SwiperThemeSchema {
  static const String id = 'swiper';

  static final ComponentSchema schema = ComponentSchema.fromJson(
    jsonDecode(_rawSchema) as Map<String, dynamic>,
  );

  static const String _rawSchema = r'''{
  "id": "swiper",
  "title": "Swiper Theme",
  "description": "Swipe-triggered overlays for drawers and sheets. Theme tokens and editor schema.",
  "schemaVersion": 1,
  "since": "1.0.0",
  "migrations": {},
  "groups": [
    {
      "title": "Appearance",
      "fields": [
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
          "name": "barrierColor",
          "label": "Barrier Color",
          "description": "Barrier Color in hex format (#RRGGBB or #AARRGGBB).",
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
      "title": "Options",
      "fields": [
        {
          "type": "boolean",
          "name": "showDragHandle",
          "label": "Show Drag Handle",
          "description": "Show or hide Show Drag Handle.",
          "defaultValue": null,
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
          "type": "boolean",
          "name": "barrierDismissible",
          "label": "Barrier Dismissible",
          "description": "Toggle Barrier Dismissible.",
          "defaultValue": null,
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
          "type": "enum",
          "name": "behavior",
          "label": "Behavior",
          "description": "Behavior in pixels (affected by theme.scaling).",
          "defaultValue": "translucent",
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
          "name": "draggable",
          "label": "Draggable",
          "description": "Toggle Draggable.",
          "defaultValue": null,
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
          "name": "expands",
          "label": "Expands",
          "description": "Toggle Expands.",
          "defaultValue": null,
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
        },
        {
          "type": "boolean",
          "name": "transformBackdrop",
          "label": "Transform Backdrop",
          "description": "Toggle Transform Backdrop.",
          "defaultValue": null,
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
          "name": "useSafeArea",
          "label": "Use Safe Area",
          "description": "Toggle Use Safe Area.",
          "defaultValue": null,
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
