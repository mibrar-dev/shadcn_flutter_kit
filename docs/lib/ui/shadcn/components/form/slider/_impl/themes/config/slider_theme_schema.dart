// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// GENERATED CODE - DO NOT MODIFY BY HAND
// Generator: convention-based schema generator

import 'dart:convert';

import '../../../../../../shared/theme/schema/component_schema.dart';

class SliderThemeSchema {
  static const String id = 'slider';

  static final ComponentSchema schema = ComponentSchema.fromJson(
    jsonDecode(_rawSchema) as Map<String, dynamic>,
  );

  static const String _rawSchema = r'''{
  "id": "slider",
  "title": "Slider Theme",
  "description": "General-purpose single and range slider engine with snapping and pluggable builders. Theme tokens and editor schema.",
  "schemaVersion": 1,
  "since": "1.1.0",
  "migrations": {},
  "groups": [
    {
      "title": "Dimensions",
      "fields": [
        {
          "type": "number",
          "name": "joinGapPx",
          "label": "Join Gap Px",
          "description": "Join Gap Px in pixels (affected by theme.scaling).",
          "defaultValue": 2.0,
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
            "max": 32.0,
            "step": 2.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "trackHeight",
          "label": "Track Height",
          "description": "Track Height in pixels (affected by theme.scaling).",
          "defaultValue": 28.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveBarGap",
          "label": "Wave Bar Gap",
          "description": "Wave Bar Gap in pixels (affected by theme.scaling).",
          "defaultValue": 2.0,
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
            "max": 32.0,
            "step": 2.0
          },
          "ui": {
            "control": "slider",
            "unit": "px"
          },
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveBarWidth",
          "label": "Wave Bar Width",
          "description": "Wave Bar Width in pixels (affected by theme.scaling).",
          "defaultValue": 4.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveHeight",
          "label": "Wave Height",
          "description": "Wave Height in pixels (affected by theme.scaling).",
          "defaultValue": 44.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveMaxBarHeight",
          "label": "Wave Max Bar Height",
          "description": "Wave Max Bar Height in pixels (affected by theme.scaling).",
          "defaultValue": 40.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveMinBarHeight",
          "label": "Wave Min Bar Height",
          "description": "Wave Min Bar Height in pixels (affected by theme.scaling).",
          "defaultValue": 6.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "wavePadding",
          "label": "Wave Padding",
          "description": "Wave Padding in pixels (affected by theme.scaling).",
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveThumbBorderWidth",
          "label": "Wave Thumb Border Width",
          "description": "Wave Thumb Border Width in pixels (affected by theme.scaling).",
          "defaultValue": 2.0,
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
          "since": "1.1.0"
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "thumbBorderColor",
          "label": "Thumb Border Color",
          "description": "Thumb Border Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#1A0A0A0A",
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "thumbRadius",
          "label": "Thumb Radius",
          "description": "Thumb Radius in pixels (affected by theme.radius).",
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "trackRadius",
          "label": "Track Radius",
          "description": "Track Radius in pixels (affected by theme.radius).",
          "defaultValue": 8.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveCornerRadius",
          "label": "Wave Corner Radius",
          "description": "Wave Corner Radius in pixels (affected by theme.radius).",
          "defaultValue": 8.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveDisabledOpacity",
          "label": "Wave Disabled Opacity",
          "description": "Wave Disabled Opacity (0.0 = transparent, 1.0 = opaque).",
          "defaultValue": 0.45,
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "waveThumbBorderColor",
          "label": "Wave Thumb Border Color",
          "description": "Wave Thumb Border Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#2E0A0A0A",
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveThumbRadius",
          "label": "Wave Thumb Radius",
          "description": "Wave Thumb Radius in pixels (affected by theme.radius).",
          "defaultValue": 10.0,
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
          "since": "1.1.0"
        }
      ]
    },
    {
      "title": "Colors",
      "fields": [
        {
          "type": "color",
          "name": "dotsActiveColor",
          "label": "Dots Active Color",
          "description": "Dots Active Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#2E0A0A0A",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "dotsInactiveColor",
          "label": "Dots Inactive Color",
          "description": "Dots Inactive Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#140A0A0A",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "fillActiveColor",
          "label": "Fill Active Color",
          "description": "Fill Active Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#171717",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "fillInactiveColor",
          "label": "Fill Inactive Color",
          "description": "Fill Inactive Color in hex format (#RRGGBB or #AARRGGBB).",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "guideColor",
          "label": "Guide Color",
          "description": "Guide Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#0F0A0A0A",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "popoverBackgroundColor",
          "label": "Popover Background Color",
          "description": "Popover Background Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#171717",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "popoverForegroundColor",
          "label": "Popover Foreground Color",
          "description": "Popover Foreground Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#FFFFFF",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "thumbFillColor",
          "label": "Thumb Fill Color",
          "description": "Thumb Fill Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#FFFFFF",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "waveActiveColor",
          "label": "Wave Active Color",
          "description": "Wave Active Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#171717",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "waveInactiveColor",
          "label": "Wave Inactive Color",
          "description": "Wave Inactive Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#BFF5F5F5",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "waveThumbColor",
          "label": "Wave Thumb Color",
          "description": "Wave Thumb Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#FFFFFF",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "waveformTicksActiveColor",
          "label": "Waveform Ticks Active Color",
          "description": "Waveform Ticks Active Color in hex format (#RRGGBB or #AARRGGBB).",
          "defaultValue": "#85FFFFFF",
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
          "since": "1.1.0"
        },
        {
          "type": "color",
          "name": "waveformTicksInactiveColor",
          "label": "Waveform Ticks Inactive Color",
          "description": "Waveform Ticks Inactive Color in hex format (#RRGGBB or #AARRGGBB).",
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
          "since": "1.1.0"
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
          "since": "1.1.0"
        }
      ]
    },
    {
      "title": "General",
      "fields": [
        {
          "type": "enum",
          "name": "dragPopoverVisibility",
          "label": "Drag Popover Visibility",
          "description": "Drag Popover Visibility in pixels (affected by theme.scaling).",
          "defaultValue": "whileDragging",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "select"
          },
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "fillEdgeBiasPx",
          "label": "Fill Edge Bias Px",
          "description": "Fill Edge Bias Px in pixels (affected by theme.scaling).",
          "defaultValue": 0.0,
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
          "since": "1.1.0"
        },
        {
          "type": "boolean",
          "name": "fillStopsAtThumbCenter",
          "label": "Fill Stops At Thumb Center",
          "description": "Toggle Fill Stops At Thumb Center.",
          "defaultValue": true,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input"
          },
          "since": "1.1.0"
        },
        {
          "type": "enum",
          "name": "popoverShape",
          "label": "Popover Shape",
          "description": "Popover Shape in pixels (affected by theme.scaling).",
          "defaultValue": "rounded",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "select"
          },
          "since": "1.1.0"
        },
        {
          "type": "string",
          "name": "preset",
          "label": "Preset",
          "description": "Preset in pixels (affected by theme.scaling).",
          "defaultValue": "brightness",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input"
          },
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "thumbEdgeOffsetPx",
          "label": "Thumb Edge Offset Px",
          "description": "Thumb Edge Offset Px in pixels (affected by theme.scaling).",
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "thumbInset",
          "label": "Thumb Inset",
          "description": "Thumb Inset in pixels (affected by theme.scaling).",
          "defaultValue": 10.0,
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
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "thumbVerticalOffsetPx",
          "label": "Thumb Vertical Offset Px",
          "description": "Thumb Vertical Offset Px in pixels (affected by theme.scaling).",
          "defaultValue": 0.0,
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
          "since": "1.1.0"
        },
        {
          "type": "boolean",
          "name": "waveEnabled",
          "label": "Wave Enabled",
          "description": "Toggle Wave Enabled.",
          "defaultValue": true,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input"
          },
          "since": "1.1.0"
        },
        {
          "type": "number",
          "name": "waveHitSlop",
          "label": "Wave Hit Slop",
          "description": "Wave Hit Slop in pixels (affected by theme.scaling).",
          "defaultValue": 8.0,
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
          "since": "1.1.0"
        },
        {
          "type": "enum",
          "name": "wavePopoverVisibility",
          "label": "Wave Popover Visibility",
          "description": "Wave Popover Visibility in pixels (affected by theme.scaling).",
          "defaultValue": "whileDragging",
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "select"
          },
          "since": "1.1.0"
        },
        {
          "type": "boolean",
          "name": "waveShowThumb",
          "label": "Wave Show Thumb",
          "description": "Toggle Wave Show Thumb.",
          "defaultValue": true,
          "required": false,
          "isAdvanced": false,
          "visibleIf": [],
          "validation": {
            "clamp": "reject"
          },
          "ui": {
            "control": "input"
          },
          "since": "1.1.0"
        }
      ]
    }
  ],
  "$schema": "../../../../manifests/component_theme.schema.json"
}''';
}
