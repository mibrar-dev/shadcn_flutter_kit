// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of 'preview.dart';

/// _CalendarPreviewState holds mutable state for the calendar implementation.
class _CalendarPreviewState extends State<CalendarPreview> {
  /// Data consumed by `_CalendarPreviewState` to render calendar content.
  CalendarValue? _value;

  /// Input parameter used by `_CalendarPreviewState` during rendering and behavior handling.
  CalendarView _view = CalendarView.now();

  /// Builds the widget tree for calendar.
  @override
  Widget build(BuildContext context) {
    final localizations = ShadcnLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: shadcn.Card(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    OutlineButton(
                      density: ButtonDensity.icon,
                      onPressed: () {
                        /// Implements `setState` behavior for calendar.
                        setState(() {
                          _view = _view.previous;
                        });
                      },
                      child: const Icon(Icons.arrow_back).iconXSmall(),
                    ),

                    Expanded(
                      child: Center(
                        child: Text(
                          '${localizations.getMonth(_view.month)} ${_view.year}',
                        ).small().medium(),
                      ),
                    ),

                    OutlineButton(
                      density: ButtonDensity.icon,
                      onPressed: () {
                        /// Implements `setState` behavior for calendar.
                        setState(() {
                          _view = _view.next;
                        });
                      },
                      child: const Icon(Icons.arrow_forward).iconXSmall(),
                    ),
                  ],
                ),

                const DensityGap(gapLg),

                Calendar(
                  value: _value,
                  view: _view,
                  selectionMode: CalendarSelectionMode.range,
                  onChanged: (value) {
                    /// Implements `setState` behavior for calendar.
                    setState(() {
                      _value = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
