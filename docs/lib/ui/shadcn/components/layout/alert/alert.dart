// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/basic.dart';
import '../../../shared/primitives/outlined_container.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/themes/base/alert_theme.dart';

/// Flexible alert box for status, warning, and info messages.
class Alert extends StatelessWidget {
  /// Optional leading widget (icon/avatar).
  final Widget? leading;

  /// Optional title widget.
  final Widget? title;

  /// Optional descriptive content.
  final Widget? content;

  /// Optional trailing widget (actions/dismissal).
  final Widget? trailing;

  /// Applies destructive styling when true.
  final bool destructive;

  /// Creates a styled [Alert].
  const Alert({
    super.key,
    this.leading,
    this.title,
    this.content,
    this.trailing,
    this.destructive = false,
  });

  /// Convenience constructor for destructive alerts.
  const Alert.destructive({
    super.key,
    this.leading,
    this.title,
    this.content,
    this.trailing,
  }) : destructive = true;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (destructive) {
      final destructiveColor = Theme.of(context).colorScheme.destructive;
      return DefaultTextStyle.merge(
        style: TextStyle(color: destructiveColor),
        child: IconTheme.merge(
          data: IconThemeData(color: destructiveColor),
          child: _build(context),
        ),
      );
    }
    return _build(context);
  }

  /// Executes `_build` behavior for this component/composite.
  Widget _build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<AlertTheme>(context);
    final padding = styleValue(
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.symmetric(
        horizontal: 16 * theme.scaling,
        vertical: 12 * theme.scaling,
      ),
    );

    final backgroundColor = styleValue(
      themeValue: compTheme?.backgroundColor,
      defaultValue: theme.colorScheme.card,
    );

    final borderColor = styleValue(
      themeValue: compTheme?.borderColor,
      defaultValue: theme.colorScheme.border,
    );

    return OutlinedContainer(
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      child: Container(
        padding: padding,
        child: Basic(
          leading: leading,
          title: title,
          content: content,
          trailing: trailing,
        ),
      ),
    );
  }
}
