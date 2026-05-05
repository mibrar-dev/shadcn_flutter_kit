import 'dart:convert';

enum ClampBehavior {
  clamp('clamp'),
  reject('reject');

  const ClampBehavior(this.value);
  final String value;

  static ClampBehavior fromJson(String? value) {
    return ClampBehavior.values.firstWhere(
      (entry) => entry.value == value,
      orElse: () => ClampBehavior.reject,
    );
  }
}

enum VisibleIfOperator {
  eq('eq'),
  neq('neq'),
  gt('gt'),
  gte('gte'),
  lt('lt'),
  lte('lte'),
  inList('in'),
  notIn('notIn'),
  exists('exists');

  const VisibleIfOperator(this.value);
  final String value;

  static VisibleIfOperator fromJson(String? value) {
    return VisibleIfOperator.values.firstWhere(
      (entry) => entry.value == value,
      orElse: () => VisibleIfOperator.eq,
    );
  }
}

enum UiControl {
  slider('slider'),
  input('input'),
  color('color'),
  segmented('segmented'),
  select('select');

  const UiControl(this.value);
  final String value;

  static UiControl? fromJson(String? value) {
    if (value == null) return null;
    for (final entry in UiControl.values) {
      if (entry.value == value) return entry;
    }
    return null;
  }
}

enum UiUnit {
  px('px'),
  ms('ms');

  const UiUnit(this.value);
  final String value;

  static UiUnit? fromJson(String? value) {
    if (value == null) return null;
    for (final entry in UiUnit.values) {
      if (entry.value == value) return entry;
    }
    return null;
  }
}

enum FieldType {
  boolean('boolean'),
  number('number'),
  integer('integer'),
  string('string'),
  color('color'),
  duration('duration'),
  enumType('enum'),
  list('list'),
  object('object'),
  shadowList('shadowList'),
  gradient('gradient'),
  border('border'),
  textStyle('textStyle'),
  curve('curve');

  const FieldType(this.value);
  final String value;

  static FieldType fromJson(String? value) {
    return FieldType.values.firstWhere(
      (entry) => entry.value == value,
      orElse: () => FieldType.object,
    );
  }
}

class VisibleIf {
  const VisibleIf({required this.field, required this.op, this.value});

  final String field;
  final VisibleIfOperator op;
  final Object? value;

  factory VisibleIf.fromJson(Map<String, dynamic> json) {
    return VisibleIf(
      field: json['field'] as String? ?? '',
      op: VisibleIfOperator.fromJson(json['op'] as String?),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'field': field, 'op': op.value, 'value': value};
  }
}

class TokenBinding {
  const TokenBinding({required this.path, this.allowedFamilies});

  final String path;
  final List<String>? allowedFamilies;

  factory TokenBinding.fromJson(Map<String, dynamic> json) {
    final rawFamilies = json['allowedFamilies'];
    return TokenBinding(
      path: json['path'] as String? ?? '',
      allowedFamilies: rawFamilies is List
          ? rawFamilies.whereType<String>().toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'path': path,
      if (allowedFamilies != null) 'allowedFamilies': allowedFamilies,
    };
  }
}

class FieldValidation {
  const FieldValidation({
    this.clamp = ClampBehavior.reject,
    this.pattern,
    this.minItems,
    this.maxItems,
    this.min,
    this.max,
    this.step,
  });

  final ClampBehavior clamp;
  final String? pattern;
  final int? minItems;
  final int? maxItems;
  final num? min;
  final num? max;
  final num? step;

  factory FieldValidation.fromJson(Map<String, dynamic> json) {
    return FieldValidation(
      clamp: ClampBehavior.fromJson(json['clamp'] as String?),
      pattern: json['pattern'] as String?,
      minItems: json['minItems'] as int?,
      maxItems: json['maxItems'] as int?,
      min: json['min'] as num?,
      max: json['max'] as num?,
      step: json['step'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'clamp': clamp.value};
    if (pattern != null) {
      map['pattern'] = pattern;
    }
    if (minItems != null) {
      map['minItems'] = minItems;
    }
    if (maxItems != null) {
      map['maxItems'] = maxItems;
    }
    if (min != null) {
      map['min'] = min;
    }
    if (max != null) {
      map['max'] = max;
    }
    if (step != null) {
      map['step'] = step;
    }
    return map;
  }

  Object? normalizeValue({
    required FieldType type,
    required String fieldName,
    required Object? value,
  }) {
    if (value == null) return null;

    switch (type) {
      case FieldType.number:
      case FieldType.integer:
        if (value is! num) {
          throw ArgumentError('$fieldName must be numeric.');
        }
        var normalized = value;
        if (min != null && normalized < min!) {
          if (clamp == ClampBehavior.clamp) {
            normalized = min!;
          } else {
            throw RangeError('$fieldName is below min $min.');
          }
        }
        if (max != null && normalized > max!) {
          if (clamp == ClampBehavior.clamp) {
            normalized = max!;
          } else {
            throw RangeError('$fieldName is above max $max.');
          }
        }
        if (type == FieldType.integer) {
          return normalized.round();
        }
        return normalized;
      case FieldType.string:
      case FieldType.color:
      case FieldType.duration:
      case FieldType.enumType:
      case FieldType.curve:
        if (value is! String && type != FieldType.curve) {
          return value;
        }
        if (value is String && pattern != null && pattern!.isNotEmpty) {
          if (!RegExp(pattern!).hasMatch(value)) {
            throw ArgumentError(
              '$fieldName does not match required pattern $pattern.',
            );
          }
        }
        return value;
      case FieldType.list:
      case FieldType.shadowList:
        if (value is! List) {
          throw ArgumentError('$fieldName must be a list.');
        }
        if (minItems != null && value.length < minItems!) {
          throw RangeError('$fieldName list length must be >= $minItems.');
        }
        if (maxItems != null && value.length > maxItems!) {
          throw RangeError('$fieldName list length must be <= $maxItems.');
        }
        return value;
      case FieldType.object:
      case FieldType.gradient:
      case FieldType.border:
      case FieldType.textStyle:
      case FieldType.boolean:
        return value;
    }
  }
}

class EditorHints {
  const EditorHints({this.control, this.unit});

  final UiControl? control;
  final UiUnit? unit;

  factory EditorHints.fromJson(Map<String, dynamic> json) {
    return EditorHints(
      control: UiControl.fromJson(json['control'] as String?),
      unit: UiUnit.fromJson(json['unit'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (control != null) {
      map['control'] = control!.value;
    }
    if (unit != null) {
      map['unit'] = unit!.value;
    }
    return map;
  }
}

class FieldSpec {
  const FieldSpec({
    required this.type,
    required this.name,
    required this.label,
    required this.defaultValue,
    required this.requiredField,
    this.description,
    this.isAdvanced = false,
    this.visibleIf = const <VisibleIf>[],
    this.tokenBinding,
    this.validation = const FieldValidation(),
    this.ui = const EditorHints(),
    this.precision,
    this.helpUrl,
    this.since,
    this.deprecatedSince,
  });

  final FieldType type;
  final String name;
  final String label;
  final String? description;
  final Object? defaultValue;
  final bool requiredField;
  final bool isAdvanced;
  final List<VisibleIf> visibleIf;
  final TokenBinding? tokenBinding;
  final FieldValidation validation;
  final EditorHints ui;
  final int? precision;
  final String? helpUrl;
  final String? since;
  final String? deprecatedSince;

  factory FieldSpec.fromJson(Map<String, dynamic> json) {
    final rawVisibleIf = json['visibleIf'];
    return FieldSpec(
      type: FieldType.fromJson(json['type'] as String?),
      name: json['name'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String?,
      defaultValue: json['defaultValue'],
      requiredField: json['required'] as bool? ?? false,
      isAdvanced: json['isAdvanced'] as bool? ?? false,
      visibleIf: rawVisibleIf is List
          ? rawVisibleIf
                .whereType<Map>()
                .map(
                  (entry) =>
                      VisibleIf.fromJson(Map<String, dynamic>.from(entry)),
                )
                .toList()
          : const <VisibleIf>[],
      tokenBinding: json['tokenBinding'] is Map
          ? TokenBinding.fromJson(
              Map<String, dynamic>.from(json['tokenBinding'] as Map),
            )
          : null,
      validation: json['validation'] is Map
          ? FieldValidation.fromJson(
              Map<String, dynamic>.from(json['validation'] as Map),
            )
          : const FieldValidation(),
      ui: json['ui'] is Map
          ? EditorHints.fromJson(Map<String, dynamic>.from(json['ui'] as Map))
          : const EditorHints(),
      precision: json['precision'] as int?,
      helpUrl: json['helpUrl'] as String?,
      since: json['since'] as String?,
      deprecatedSince: json['deprecatedSince'] as String?,
    );
  }

  Object? normalizeDefaultValue() {
    if (defaultValue == null) {
      if (requiredField) {
        throw ArgumentError('$name is required and cannot default to null.');
      }
      return null;
    }
    return validation.normalizeValue(
      type: type,
      fieldName: name,
      value: defaultValue,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.value,
      'name': name,
      'label': label,
      if (description != null) 'description': description,
      'defaultValue': normalizeDefaultValue(),
      'required': requiredField,
      'isAdvanced': isAdvanced,
      'visibleIf': visibleIf.map((entry) => entry.toJson()).toList(),
      if (tokenBinding != null) 'tokenBinding': tokenBinding!.toJson(),
      'validation': validation.toJson(),
      'ui': ui.toJson(),
      if (precision != null) 'precision': precision,
      if (helpUrl != null) 'helpUrl': helpUrl,
      if (since != null) 'since': since,
      if (deprecatedSince != null) 'deprecatedSince': deprecatedSince,
    };
  }
}

class SchemaGroup {
  const SchemaGroup({
    required this.title,
    required this.fields,
    this.description,
  });

  final String title;
  final String? description;
  final List<FieldSpec> fields;

  factory SchemaGroup.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return SchemaGroup(
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      fields: rawFields is List
          ? rawFields
                .whereType<Map>()
                .map(
                  (entry) =>
                      FieldSpec.fromJson(Map<String, dynamic>.from(entry)),
                )
                .toList()
          : const <FieldSpec>[],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      if (description != null) 'description': description,
      'fields': fields.map((entry) => entry.toJson()).toList(),
    };
  }
}

class ComponentSchema {
  const ComponentSchema({
    required this.id,
    required this.title,
    required this.schemaVersion,
    required this.groups,
    this.description,
    this.since,
    this.deprecatedSince,
    this.migrations = const <String, String>{},
  });

  final String id;
  final String title;
  final String? description;
  final int schemaVersion;
  final String? since;
  final String? deprecatedSince;
  final Map<String, String> migrations;
  final List<SchemaGroup> groups;

  factory ComponentSchema.fromJson(Map<String, dynamic> json) {
    final rawGroups = json['groups'];
    final rawMigrations = json['migrations'];
    return ComponentSchema(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      since: json['since'] as String?,
      deprecatedSince: json['deprecatedSince'] as String?,
      migrations: rawMigrations is Map
          ? rawMigrations.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : const <String, String>{},
      groups: rawGroups is List
          ? rawGroups
                .whereType<Map>()
                .map(
                  (entry) =>
                      SchemaGroup.fromJson(Map<String, dynamic>.from(entry)),
                )
                .toList()
          : const <SchemaGroup>[],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'schemaVersion': schemaVersion,
      if (since != null) 'since': since,
      if (deprecatedSince != null) 'deprecatedSince': deprecatedSince,
      'migrations': migrations,
      'groups': groups.map((entry) => entry.toJson()).toList(),
    };
  }

  String toPrettyJson() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class ShadowLayerValue {
  const ShadowLayerValue({
    required this.color,
    required this.blurRadius,
    required this.offsetX,
    required this.offsetY,
    this.spreadRadius = 0,
  });

  final String color;
  final double blurRadius;
  final double spreadRadius;
  final double offsetX;
  final double offsetY;

  factory ShadowLayerValue.fromJson(Map<String, dynamic> json) {
    return ShadowLayerValue(
      color: json['color'] as String? ?? '#00000000',
      blurRadius: (json['blurRadius'] as num?)?.toDouble() ?? 0,
      spreadRadius: (json['spreadRadius'] as num?)?.toDouble() ?? 0,
      offsetX: (json['offsetX'] as num?)?.toDouble() ?? 0,
      offsetY: (json['offsetY'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'color': color,
      'blurRadius': blurRadius,
      'spreadRadius': spreadRadius,
      'offsetX': offsetX,
      'offsetY': offsetY,
    };
  }
}

class GradientValue {
  const GradientValue({
    required this.kind,
    required this.colors,
    this.stops,
    this.begin,
    this.end,
    this.center,
    this.radius,
    this.startAngle,
    this.endAngle,
  });

  final String kind;
  final List<String> colors;
  final List<double>? stops;
  final String? begin;
  final String? end;
  final String? center;
  final double? radius;
  final double? startAngle;
  final double? endAngle;

  factory GradientValue.fromJson(Map<String, dynamic> json) {
    return GradientValue(
      kind: json['kind'] as String? ?? 'linear',
      colors: (json['colors'] as List? ?? const <dynamic>[])
          .whereType<String>()
          .toList(),
      stops: (json['stops'] as List?)
          ?.whereType<num>()
          .map((entry) => entry.toDouble())
          .toList(),
      begin: json['begin'] as String?,
      end: json['end'] as String?,
      center: json['center'] as String?,
      radius: (json['radius'] as num?)?.toDouble(),
      startAngle: (json['startAngle'] as num?)?.toDouble(),
      endAngle: (json['endAngle'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kind': kind,
      'colors': colors,
      if (stops != null) 'stops': stops,
      if (begin != null) 'begin': begin,
      if (end != null) 'end': end,
      if (center != null) 'center': center,
      if (radius != null) 'radius': radius,
      if (startAngle != null) 'startAngle': startAngle,
      if (endAngle != null) 'endAngle': endAngle,
    };
  }
}

class BorderSideValue {
  const BorderSideValue({
    required this.color,
    required this.width,
    this.style = 'solid',
  });

  final String color;
  final double width;
  final String style;

  factory BorderSideValue.fromJson(Map<String, dynamic> json) {
    return BorderSideValue(
      color: json['color'] as String? ?? '#00000000',
      width: (json['width'] as num?)?.toDouble() ?? 0,
      style: json['style'] as String? ?? 'solid',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'color': color, 'width': width, 'style': style};
  }
}

class BorderValue {
  const BorderValue({this.all, this.top, this.right, this.bottom, this.left});

  final BorderSideValue? all;
  final BorderSideValue? top;
  final BorderSideValue? right;
  final BorderSideValue? bottom;
  final BorderSideValue? left;

  factory BorderValue.fromJson(Map<String, dynamic> json) {
    BorderSideValue? parseSide(String key) {
      final value = json[key];
      if (value is! Map) return null;
      return BorderSideValue.fromJson(Map<String, dynamic>.from(value));
    }

    return BorderValue(
      all: parseSide('all'),
      top: parseSide('top'),
      right: parseSide('right'),
      bottom: parseSide('bottom'),
      left: parseSide('left'),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (all != null) 'all': all!.toJson(),
      if (top != null) 'top': top!.toJson(),
      if (right != null) 'right': right!.toJson(),
      if (bottom != null) 'bottom': bottom!.toJson(),
      if (left != null) 'left': left!.toJson(),
    };
  }
}

class TextStyleValue {
  const TextStyleValue({
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.height,
    this.color,
    this.decoration,
  });

  final String? fontFamily;
  final double? fontSize;
  final int? fontWeight;
  final String? fontStyle;
  final double? letterSpacing;
  final double? height;
  final String? color;
  final String? decoration;

  factory TextStyleValue.fromJson(Map<String, dynamic> json) {
    return TextStyleValue(
      fontFamily: json['fontFamily'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: json['fontWeight'] as int?,
      fontStyle: json['fontStyle'] as String?,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      color: json['color'] as String?,
      decoration: json['decoration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (fontFamily != null) 'fontFamily': fontFamily,
      if (fontSize != null) 'fontSize': fontSize,
      if (fontWeight != null) 'fontWeight': fontWeight,
      if (fontStyle != null) 'fontStyle': fontStyle,
      if (letterSpacing != null) 'letterSpacing': letterSpacing,
      if (height != null) 'height': height,
      if (color != null) 'color': color,
      if (decoration != null) 'decoration': decoration,
    };
  }
}

class CurveValue {
  const CurveValue({required this.kind, this.x1, this.y1, this.x2, this.y2});

  final String kind;
  final double? x1;
  final double? y1;
  final double? x2;
  final double? y2;

  factory CurveValue.fromJson(Map<String, dynamic> json) {
    return CurveValue(
      kind: json['kind'] as String? ?? 'linear',
      x1: (json['x1'] as num?)?.toDouble(),
      y1: (json['y1'] as num?)?.toDouble(),
      x2: (json['x2'] as num?)?.toDouble(),
      y2: (json['y2'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kind': kind,
      if (x1 != null) 'x1': x1,
      if (y1 != null) 'y1': y1,
      if (x2 != null) 'x2': x2,
      if (y2 != null) 'y2': y2,
    };
  }
}
