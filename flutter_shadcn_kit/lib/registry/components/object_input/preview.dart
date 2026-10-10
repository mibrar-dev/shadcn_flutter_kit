// Gallery preview for `object_input`: date, time and duration fields plus
// the dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/time_of_day.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'object_input.dart';

/// Renders the object-input gallery.
class ObjectInputPreview extends StatefulWidget {
  /// Creates the preview.
  const ObjectInputPreview({super.key});

  @override
  State<ObjectInputPreview> createState() => _ObjectInputPreviewState();
}

class _ObjectInputPreviewState extends State<ObjectInputPreview> {
  DateTime? _date;
  TimeOfDay? _time;
  Duration? _duration;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 14),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  context,
                  'Date',
                  DateInput(
                    value: _date,
                    // Dialog: the gallery may not provide an OverlayManager.
                    mode: PromptMode.dialog,
                    onChanged: (DateTime? next) => setState(() => _date = next),
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(
                  context,
                  'Time',
                  TimeInput(
                    value: _time,
                    onChanged: (TimeOfDay? next) =>
                        setState(() => _time = next),
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(
                  context,
                  'Duration',
                  DurationInput(
                    value: _duration,
                    onChanged: (Duration? next) =>
                        setState(() => _duration = next),
                  ),
                ),
                Gap(theme.spacing.xl),
                _section(
                  context,
                  'Dark',
                  ShadcnTheme(
                    data: const ShadcnThemeData(
                      colors: ShadcnColors.darkFallback,
                    ),
                    child: DateInput(
                      value: _date,
                      mode: PromptMode.dialog,
                      onChanged: (DateTime? next) =>
                          setState(() => _date = next),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
