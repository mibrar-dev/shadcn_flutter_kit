// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../time_picker.dart';

/// _DurationPickerDialogState stores and manages mutable widget state.
class _DurationPickerDialogState extends State<DurationPickerDialog> {
  /// Controller used to coordinate `_dayController` behavior.
  late TextEditingController _dayController;

  /// Controller used to coordinate `_hourController` behavior.
  late TextEditingController _hourController;

  /// Controller used to coordinate `_minuteController` behavior.
  late TextEditingController _minuteController;

  /// Controller used to coordinate `_secondController` behavior.
  late TextEditingController _secondController;

  /// Performs `_formatDigits` logic for this form component.
  String _formatDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  Widget _buildInput(
    BuildContext context,
    TextEditingController controller,
    String label,
  ) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 72 * theme.scaling,
        minHeight: 72 * theme.scaling,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: TextField(
              textAlign: TextAlign.center,
              controller: controller,
              style: theme.typography.x4Large,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                const _TimeFormatter(),
              ],
            ),
          ),
          Positioned(bottom: (-24) * theme.scaling, child: Text(label).muted()),
        ],
      ),
    );
  }

  /// Performs `_buildSeparator` logic for this form component.
  Widget _buildSeparator(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    return const Text(':').x5Large().withPadding(horizontal: 8 * scaling);
  }

  /// Performs `_onChanged` logic for this form component.
  void _onChanged() {
    int day = int.tryParse(_dayController.text) ?? 0;
    int hour = int.tryParse(_hourController.text) ?? 0;
    int minute = int.tryParse(_minuteController.text) ?? 0;
    int second = int.tryParse(_secondController.text) ?? 0;
    day = day.clamp(0, 999);
    hour = hour.clamp(0, 23);
    minute = minute.clamp(0, 59);
    second = second.clamp(0, 59);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChanged?.call(
        Duration(days: day, hours: hour, minutes: minute, seconds: second),
      );
    });
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _dayController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    int initialDay = widget.initialValue?.inDays ?? 0;
    int initialHour = widget.initialValue?.inHours ?? 0;
    int initialMinute = widget.initialValue?.inMinutes ?? 0;
    int initialSecond = widget.initialValue?.inSeconds ?? 0;
    _dayController = TextEditingController(text: _formatDigits(initialDay));
    _hourController = TextEditingController(
      text: _formatDigits(initialHour % Duration.hoursPerDay),
    );
    _minuteController = TextEditingController(
      text: _formatDigits(initialMinute % Duration.minutesPerHour),
    );
    _secondController = TextEditingController(
      text: _formatDigits(initialSecond % Duration.secondsPerMinute),
    );
    _dayController.addListener(_onChanged);
    _hourController.addListener(_onChanged);
    _minuteController.addListener(_onChanged);
    _secondController.addListener(_onChanged);
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final localizations = ShadcnLocalizations.of(context);
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(
            bottom:
                ((theme.density.baseContentPadding) +
                    (theme.density.baseGap * 1.5)) *
                scaling,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildInput(
                  context,
                  _dayController,
                  localizations.durationDay,
                ),
              ),
              _buildSeparator(context),
              Expanded(
                child: _buildInput(
                  context,
                  _hourController,
                  localizations.durationHour,
                ),
              ),
              _buildSeparator(context),
              Expanded(
                child: _buildInput(
                  context,
                  _minuteController,
                  localizations.durationMinute,
                ),
              ),
              _buildSeparator(context),
              Expanded(
                child: _buildInput(
                  context,
                  _secondController,
                  localizations.durationSecond,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
