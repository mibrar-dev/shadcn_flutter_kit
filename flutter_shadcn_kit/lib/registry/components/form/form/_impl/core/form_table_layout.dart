// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A table-based layout for multiple form fields.
///
/// Arranges form fields in a table layout for structured data entry.
class FormTableLayout extends StatelessWidget {
  /// List of form field rows to display in the table.
  final List<FormField> rows;

  /// Vertical spacing between rows.
  final double? spacing;

  /// Creates a [FormTableLayout].
  ///
  /// Parameters:
  /// - [rows] (`List<FormField>`, required): Form fields to arrange in rows.
  /// - [spacing] (`double?`, optional): Custom row spacing.
  const FormTableLayout({super.key, required this.rows, this.spacing});

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    var spacing = this.spacing ?? scaling * 16;
    return DefaultTextStyle.merge(
      style: TextStyle(color: Theme.of(context).colorScheme.foreground),
      child: Table(
        columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
        children: [
          for (int i = 0; i < rows.length; i++)
            TableRow(
              children: [
                rows[i].label
                    .textSmall()
                    .withAlign(AlignmentDirectional.centerEnd)
                    .sized(height: 32 * scaling)
                    .withPadding(
                      top: i == 0 ? 0 : spacing,
                      right: 16 * scaling,
                      left: 16 * scaling,
                    ),
                FormEntry(
                  key: rows[i].key,
                  validator: rows[i].validator,
                  child: FormEntryErrorBuilder(
                    modes: rows[i].showErrors,
                    builder: (context, error, child) {
                      return ComponentTheme(
                        data: FocusOutlineTheme(
                          border: error != null
                              ? Border.all(
                                  color: theme.colorScheme.destructive
                                      .scaleAlpha(0.2),
                                  width: 3.0,
                                )
                              : null,
                        ),
                        child: ComponentTheme(
                          data: TextFieldTheme(
                            border: error != null
                                ? Border.all(
                                    color: theme.colorScheme.destructive,
                                  )
                                : null,
                          ),
                          child: IntrinsicWidth(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                child!,
                                if (rows[i].hint != null) ...[
                                  DensityGap(gapSm),
                                  rows[i].hint!.xSmall().muted(),
                                ],
                                if (error is InvalidResult) ...[
                                  DensityGap(gapSm),
                                  DefaultTextStyle.merge(
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.destructive,
                                    ),
                                    child: Text(
                                      error.message,
                                    ).xSmall().medium(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: rows[i].child,
                  ),
                ).withPadding(top: i == 0 ? 0 : spacing),
              ],
            ),
        ],
      ),
    );
  }
}
