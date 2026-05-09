// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../calendar.dart';

/// _DatePickerDialogState holds mutable state for the calendar implementation.
class _DatePickerDialogState extends State<DatePickerDialog> {
  /// Input parameter used by `_DatePickerDialogState` during rendering and behavior handling.
  late CalendarView _view;

  /// Input parameter used by `_DatePickerDialogState` during rendering and behavior handling.
  late CalendarView _alternateView;

  /// Data consumed by `_DatePickerDialogState` to render calendar content.
  late CalendarValue? _value;

  /// Input parameter used by `_DatePickerDialogState` during rendering and behavior handling.
  late CalendarViewType _viewType;

  /// Input parameter used by `_DatePickerDialogState` during rendering and behavior handling.
  late int _yearSelectStart;

  /// Input parameter used by `_DatePickerDialogState` during rendering and behavior handling.
  bool _alternate = false;

  /// Initializes controllers and listeners required by calendar.
  @override
  void initState() {
    super.initState();
    _view =
        widget.initialView ?? widget.initialValue?.view ?? CalendarView.now();
    _alternateView = _view.next;
    _value = widget.initialValue;
    _viewType = widget.initialViewType;
    // _yearSelectStart = round year every 16 years so that it can fit 4x4 grid
    _yearSelectStart = (_view.year ~/ 16) * 16;
  }

  /// Updates internal state when calendar configuration changes.
  @override
  void didUpdateWidget(covariant DatePickerDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialView != oldWidget.initialView ||
        widget.initialValue != oldWidget.initialValue) {
      _view =
          widget.initialView ?? widget.initialValue?.view ?? CalendarView.now();
      _alternateView = _view.next;
      _yearSelectStart = (_view.year ~/ 16) * 16;
    }
    if (widget.initialValue != oldWidget.initialValue) {
      _value = widget.initialValue;
    }
    if (widget.initialViewType != oldWidget.initialViewType) {
      _viewType = widget.initialViewType;
    }
  }

  String getHeaderText(
    ShadcnLocalizations localizations,
    CalendarView view,
    CalendarViewType viewType,
  ) {
    if (viewType == CalendarViewType.date) {
      return '${localizations.getMonth(view.month)} ${view.year}';
    }
    if (viewType == CalendarViewType.month) {
      return '${view.year}';
    }
    return localizations.datePickerSelectYear;
  }

  /// Builds the widget tree for calendar.
  @override
  Widget build(BuildContext context) {
    ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<CalendarTheme>(context);
    final arrowColor = styleValue(
      themeValue: compTheme?.arrowIconColor,
      defaultValue: null,
    );

    final viewMode = widget.viewMode ?? widget.selectionMode;
    if (widget.selectionMode == CalendarSelectionMode.range) {
      return IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlineButton(
                        density: ButtonDensity.icon,
                        onPressed: () {
                          /// Implements `setState` behavior for calendar.
                          setState(() {
                            switch (_viewType) {
                              case CalendarViewType.date:
                                _view = _view.previous;
                                _alternateView = _alternateView.previous;
                                break;
                              case CalendarViewType.month:
                                _view = _view.previousYear;
                                break;
                              case CalendarViewType.year:
                                _yearSelectStart -= 16;
                                break;
                            }
                          });
                        },
                        child: Icon(
                          LucideIcons.arrowLeft,
                          color: arrowColor,
                        ).iconXSmall(),
                      ),

                      SizedBox(width: theme.scaling * 16),

                      Expanded(
                        child: SizedBox(
                          height: theme.scaling * 32,
                          child: GhostButton(
                            enabled: _viewType != CalendarViewType.year,
                            onPressed: () {
                              _alternate = false;
                              switch (_viewType) {
                                case CalendarViewType.date:

                                  /// Implements `setState` behavior for calendar.
                                  setState(() {
                                    _viewType = CalendarViewType.month;
                                  });
                                  break;
                                case CalendarViewType.month:

                                  /// Implements `setState` behavior for calendar.
                                  setState(() {
                                    _viewType = CalendarViewType.year;
                                  });
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: Center(
                              child: Text(
                                getHeaderText(localizations, _view, _viewType),
                              ).foreground().small().medium(),
                            ),
                          ),
                        ),
                      ),
                      if (_viewType == CalendarViewType.date &&
                          viewMode == CalendarSelectionMode.range)
                        SizedBox(width: theme.scaling * 32),

                      SizedBox(width: theme.scaling * 16),
                      if (_viewType != CalendarViewType.date ||
                          viewMode != CalendarSelectionMode.range)
                        OutlineButton(
                          density: ButtonDensity.icon,
                          onPressed: () {
                            /// Implements `setState` behavior for calendar.
                            setState(() {
                              switch (_viewType) {
                                case CalendarViewType.date:
                                  _view = _view.next;
                                  break;
                                case CalendarViewType.month:
                                  _view = _view.nextYear;
                                  break;
                                case CalendarViewType.year:
                                  _yearSelectStart += 16;
                                  break;
                              }
                            });
                          },
                          child: Icon(
                            LucideIcons.arrowRight,
                            color: arrowColor,
                          ).iconXSmall(),
                        ),
                    ],
                  ),
                ),
                if (_viewType == CalendarViewType.date &&
                    viewMode == CalendarSelectionMode.range)
                  SizedBox(
                    width: theme.density.baseGap * theme.scaling * gapLg,
                  ),
                if (_viewType == CalendarViewType.date &&
                    viewMode == CalendarSelectionMode.range)
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: theme.scaling * (32 + 16)),

                        Expanded(
                          child: SizedBox(
                            height: theme.scaling * 32,
                            child: GhostButton(
                              onPressed: () {
                                _alternate = true;
                                switch (_viewType) {
                                  case CalendarViewType.date:

                                    /// Implements `setState` behavior for calendar.
                                    setState(() {
                                      _viewType = CalendarViewType.month;
                                    });
                                    break;
                                  case CalendarViewType.month:

                                    /// Implements `setState` behavior for calendar.
                                    setState(() {
                                      _viewType = CalendarViewType.year;
                                    });
                                    break;
                                  default:
                                    break;
                                }
                              },
                              child: Center(
                                child: Text(
                                  getHeaderText(
                                    localizations,
                                    _alternateView,
                                    _viewType,
                                  ),
                                ).foreground().small().medium(),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: theme.scaling * 16),

                        OutlineButton(
                          density: ButtonDensity.icon,
                          onPressed: () {
                            /// Implements `setState` behavior for calendar.
                            setState(() {
                              switch (_viewType) {
                                case CalendarViewType.date:
                                  _view = _view.next;
                                  _alternateView = _alternateView.next;
                                  break;
                                case CalendarViewType.month:
                                  _view = _view.nextYear;
                                  break;
                                case CalendarViewType.year:
                                  _yearSelectStart += 16;
                                  break;
                              }
                            });
                          },
                          child: Icon(
                            LucideIcons.arrowRight,
                            color: arrowColor,
                          ).iconXSmall(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: theme.density.baseGap * theme.scaling * gapLg),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: viewMode == CalendarSelectionMode.range
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                buildView(
                  context,
                  _yearSelectStart,
                  _view,
                  _viewType,
                  widget.selectionMode,
                  (value) {
                    /// Implements `setState` behavior for calendar.
                    setState(() {
                      if (!_alternate) {
                        _view = value;
                        _alternateView = value.next;
                      } else {
                        _view = value.previous;
                        _alternateView = value;
                      }
                      switch (_viewType) {
                        case CalendarViewType.date:
                          break;
                        case CalendarViewType.month:
                          _viewType = CalendarViewType.date;
                          break;
                        case CalendarViewType.year:
                          _viewType = CalendarViewType.month;
                          break;
                      }
                    });
                  },
                ),
                if (_viewType == CalendarViewType.date &&
                    viewMode == CalendarSelectionMode.range)
                  SizedBox(
                    width: theme.density.baseGap * theme.scaling * gapLg,
                  ),
                if (_viewType == CalendarViewType.date &&
                    viewMode == CalendarSelectionMode.range)
                  buildView(
                    context,
                    _yearSelectStart,
                    _alternateView,
                    _viewType,
                    widget.selectionMode,
                    (value) {},
                  ),
              ],
            ),
          ],
        ),
      );
    }
    return IntrinsicWidth(
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
                    switch (_viewType) {
                      case CalendarViewType.date:
                        _view = _view.previous;
                        break;
                      case CalendarViewType.month:
                        _view = _view.previousYear;
                        break;
                      case CalendarViewType.year:
                        _yearSelectStart -= 16;
                        break;
                    }
                  });
                },
                child: Icon(
                  LucideIcons.arrowLeft,
                  color: arrowColor,
                ).iconXSmall(),
              ),

              SizedBox(width: theme.scaling * 16),

              Expanded(
                child: SizedBox(
                  height: theme.scaling * 32,
                  child: GhostButton(
                    enabled: _viewType != CalendarViewType.year,
                    onPressed: () {
                      switch (_viewType) {
                        case CalendarViewType.date:

                          /// Implements `setState` behavior for calendar.
                          setState(() {
                            _viewType = CalendarViewType.month;
                          });
                          break;
                        case CalendarViewType.month:

                          /// Implements `setState` behavior for calendar.
                          setState(() {
                            _viewType = CalendarViewType.year;
                          });
                          break;
                        default:
                          break;
                      }
                    },
                    child: Center(
                      child: Text(
                        getHeaderText(localizations, _view, _viewType),
                      ).foreground().small().medium(),
                    ),
                  ),
                ),
              ),

              SizedBox(width: theme.scaling * 16),

              OutlineButton(
                density: ButtonDensity.icon,
                onPressed: () {
                  /// Implements `setState` behavior for calendar.
                  setState(() {
                    switch (_viewType) {
                      case CalendarViewType.date:
                        _view = _view.next;
                        break;
                      case CalendarViewType.month:
                        _view = _view.nextYear;
                        break;
                      case CalendarViewType.year:
                        _yearSelectStart += 16;
                        break;
                    }
                  });
                },
                child: Icon(
                  LucideIcons.arrowRight,
                  color: arrowColor,
                ).iconXSmall(),
              ),
            ],
          ),

          SizedBox(height: theme.density.baseGap * theme.scaling * gapLg),

          buildView(
            context,
            _yearSelectStart,
            _view,
            _viewType,
            widget.selectionMode,
            (value) {
              /// Implements `setState` behavior for calendar.
              setState(() {
                _view = value;
                switch (_viewType) {
                  case CalendarViewType.date:
                    break;
                  case CalendarViewType.month:
                    _viewType = CalendarViewType.date;
                    break;
                  case CalendarViewType.year:
                    _viewType = CalendarViewType.month;
                    break;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildView(
    BuildContext context,
    int yearSelectStart,
    CalendarView view,
    CalendarViewType viewType,
    CalendarSelectionMode selectionMode,
    ValueChanged<CalendarView> onViewChanged,
  ) {
    if (viewType == CalendarViewType.year) {
      return YearCalendar(
        value: view.year,
        yearSelectStart: yearSelectStart,
        calendarValue: _value,
        stateBuilder: widget.stateBuilder,
        onChanged: (value) {
          /// Implements `setState` behavior for calendar.
          setState(() {
            /// Implements `onViewChanged` behavior for calendar.
            onViewChanged(view.copyWith(year: () => value));
          });
        },
      );
    }
    if (viewType == CalendarViewType.month) {
      return MonthCalendar(
        value: view,
        onChanged: onViewChanged,
        stateBuilder: widget.stateBuilder,
        calendarValue: _value,
      );
    }
    return Calendar(
      value: _value,
      view: view,
      stateBuilder: widget.stateBuilder,
      onChanged: (value) {
        /// Implements `setState` behavior for calendar.
        setState(() {
          _value = value;
          widget.onChanged?.call(value);
        });
      },
      selectionMode: selectionMode,
    );
  }
}
