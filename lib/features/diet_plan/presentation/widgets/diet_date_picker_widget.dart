import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/eat_calendar_entity.dart';
import 'calendar_diet_date_picker_widget.dart';

class DietDatePickerWidget extends StatefulWidget {
  /// A Material-style date picker dialog.
  DietDatePickerWidget({
    super.key,
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.selectableDayPredicate,
    this.initialCalendarMode = DatePickerMode.day,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.restorationId,
    this.switchToInputEntryModeIcon,
    this.switchToCalendarEntryModeIcon,
    this.onDateSelected,
    this.notOpenedDays,
    this.fullBookedDays,
    this.availableDays,
    this.onMonthChanged,
    this.currentMonth,
    required this.isLoading,
    this.loadedDays,
  })  : initialDate =
            initialDate == null ? null : DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      initialDate == null || !this.initialDate!.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null ||
          initialDate == null ||
          selectableDayPredicate!(this.initialDate!),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate',
    );
  }

  /// The initially selected [DateTime] that the picker should display.
  ///
  /// If this is null, there is no selected date. A date must be selected to
  /// submit the dialog.
  final DateTime? initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// The initial mode of date entry method for the date picker dialog.
  ///
  /// See [DatePickerEntryMode] for more details on the different data entry
  /// modes available.
  final DatePickerEntryMode initialEntryMode;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  /// The error text displayed if the entered date is not in the correct format.
  final String? errorFormatText;

  /// The error text displayed if the date is not valid.
  ///
  /// A date is not valid if it is earlier than [firstDate], later than
  /// [lastDate], or doesn't pass the [selectableDayPredicate].
  final String? errorInvalidText;

  /// The hint text displayed in the [TextField].
  ///
  /// If this is null, it will default to the date format string. For example,
  /// 'mm/dd/yyyy' for en_US.
  final String? fieldHintText;

  /// The label text displayed in the [TextField].
  ///
  /// If this is null, it will default to the words representing the date format
  /// string. For example, 'Month, Day, Year' for en_US.
  final String? fieldLabelText;

  /// {@template flutter.material.datePickerDialog}
  /// The keyboard type of the [TextField].
  ///
  /// If this is null, it will default to [TextInputType.datetime]
  /// {@endtemplate}
  final TextInputType? keyboardType;

  /// Restoration ID to save and restore the state of the [DietDatePickerWidget].
  ///
  /// If it is non-null, the date picker will persist and restore the
  /// date selected on the dialog.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;

  /// {@macro flutter.material.date_picker.switchToInputEntryModeIcon}
  final Icon? switchToInputEntryModeIcon;

  /// {@macro flutter.material.date_picker.switchToCalendarEntryModeIcon}
  final Icon? switchToCalendarEntryModeIcon;

  final Function(DateTime)? onDateSelected;

  final List<DateTime?>? notOpenedDays;

  final List<DateTime?>? fullBookedDays;

  final List<DateTime?>? availableDays;

  final Function(DateTime)? onMonthChanged;

  final DateTime? currentMonth;

  final bool isLoading;
  final List<EatCalendarEntity>? loadedDays;

  @override
  State<DietDatePickerWidget> createState() => _DietDatePickerWidgetState();
}

class _DietDatePickerWidgetState extends State<DietDatePickerWidget> {
  final GlobalKey _calendarPickerKey = GlobalKey();

  void _handleDateChanged(DateTime date) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarDietDatePickerWidget(
      key: _calendarPickerKey,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      selectableDayPredicate: widget.selectableDayPredicate,
      onDateChanged: _handleDateChanged,
      notOpenedDays: widget.notOpenedDays,
      fullBookedDays: widget.fullBookedDays,
      availableDays: widget.availableDays,
      onMonthChanged: widget.onMonthChanged,
      isLoading: widget.isLoading,
      loadedDays: widget.loadedDays,
      currentDate: widget.currentDate,
    );
  }
}
