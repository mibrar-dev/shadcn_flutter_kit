// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme, TextField;

import '../../../../overlay/dialog/dialog.dart' as shadcn_dialog;
import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/border_utils.dart';
import 'command_widget.dart';

/// Async builder that provides command palette rows.
typedef CommandBuilder =
    Stream<List<Widget>> Function(BuildContext context, String? query);

/// Builder for error states inside a command palette.
typedef ErrorWidgetBuilder =
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace);

/// Shows a modal dialog with a [Command] palette.
Future<T?> showCommandDialog<T>({
  required BuildContext context,
  required CommandBuilder builder,
  BoxConstraints? constraints,
  bool autofocus = true,
  Duration debounceDuration = const Duration(milliseconds: 500),
  WidgetBuilder? emptyBuilder,
  ErrorWidgetBuilder? errorBuilder,
  WidgetBuilder? loadingBuilder,
  double? surfaceOpacity,
  double? surfaceBlur,
}) {
  return shadcn_dialog.showDialog<T>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      /// Stores `scaling` state/configuration for this implementation.
      final scaling = theme.scaling;
      surfaceOpacity ??= theme.surfaceOpacity;
      surfaceBlur ??= theme.surfaceBlur;
      return ConstrainedBox(
        constraints:
            constraints ??
            /// Creates a `BoxConstraints.tightFor` instance.
            const BoxConstraints.tightFor(width: 510, height: 349) * scaling,
        child: shadcn_dialog.ModalBackdrop(
          borderRadius: subtractByBorder(theme.borderRadiusXxl, 1 * scaling),
          surfaceClip: shadcn_dialog.ModalBackdrop.shouldClipSurface(
            surfaceOpacity,
          ),
          child: Command(
            autofocus: autofocus,
            builder: builder,
            debounceDuration: debounceDuration,
            emptyBuilder: emptyBuilder,
            errorBuilder: errorBuilder,
            loadingBuilder: loadingBuilder,
            surfaceOpacity: surfaceOpacity,
            surfaceBlur: surfaceBlur,
          ),
        ),
      );
    },
  );
}
