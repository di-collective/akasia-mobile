import 'dart:math' as math;

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/color_swatch_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../domain/entities/eat_calendar_entity.dart';

const double _dayPickerRowHeight = 60;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// One extra row for the day-of-week header.

const double _monthPickerHorizontalPadding = 8.0;

/// Displays a grid of days for a given month and allows the user to select a
/// date.
///
/// Days are arranged in a rectangular grid with one column for each day of the
/// week. Controls are provided to change the year and month that the grid is
/// showing.
///
/// The calendar picker widget is rarely used directly. Instead, consider using
/// [showDatePicker], which will create a dialog that uses this as well as
/// provides a text entry option.
///
/// See also:
///
///  * [showDatePicker], which creates a Dialog that contains a
///    [CalendarDietDatePickerWidget] and provides an optional compact view where the
///    user can enter a date as a line of text.
///  * [showTimePicker], which shows a dialog that contains a Material Design
///    time picker.
///
class CalendarDietDatePickerWidget extends StatefulWidget {
  /// Creates a calendar date picker.
  ///
  /// It will display a grid of days for the [initialDate]'s month, or, if that
  /// is null, the [currentDate]'s month. The day indicated by [initialDate] will
  /// be selected if it is not null.
  ///
  /// The optional [onDisplayedMonthChanged] callback can be used to track
  /// the currently displayed month.
  ///
  /// The user interface provides a way to change the year of the month being
  /// displayed. By default it will show the day grid, but this can be changed
  /// to start in the year selection interface with [initialCalendarMode] set
  /// to [DatePickerMode.year].
  ///
  /// The [lastDate] must be after or equal to [firstDate].
  ///
  /// The [initialDate], if provided, must be between [firstDate] and [lastDate]
  /// or equal to one of them.
  ///
  /// The [currentDate] represents the current day (i.e. today). This
  /// date will be highlighted in the day grid. If null, the date of
  /// `DateTime.now()` will be used.
  ///
  /// If [selectableDayPredicate] and [initialDate] are both non-null,
  /// [selectableDayPredicate] must return `true` for the [initialDate].
  CalendarDietDatePickerWidget({
    super.key,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    required this.onDateChanged,
    this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
    this.notOpenedDays,
    this.fullBookedDays,
    this.availableDays,
    this.onMonthChanged,
    required this.isLoading,
    this.loadedDays,
  })  : firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
  }

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime> onDateChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  final List<DateTime?>? notOpenedDays;

  final List<DateTime?>? fullBookedDays;

  final List<DateTime?>? availableDays;

  final Function(DateTime month)? onMonthChanged;

  final bool isLoading;

  final List<EatCalendarEntity>? loadedDays;

  @override
  State<CalendarDietDatePickerWidget> createState() =>
      _CalendarDietDatePickerWidgetState();
}

class _CalendarDietDatePickerWidgetState
    extends State<CalendarDietDatePickerWidget> {
  late DateTime _currentDisplayedMonthDate;
  final GlobalKey _monthPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final DateTime currentDisplayedDate = widget.currentDate;
    _currentDisplayedMonthDate = DateTime(
      currentDisplayedDate.year,
      currentDisplayedDate.month,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
  }

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleDayChanged(DateTime value) {
    setState(() {
      widget.onDateChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));

    return _MonthPicker(
      key: _monthPickerKey,
      initialMonth: _currentDisplayedMonthDate,
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onChanged: _handleDayChanged,
      onDisplayedMonthChanged: _handleMonthChanged,
      selectableDayPredicate: widget.selectableDayPredicate,
      notOpenedDays: widget.notOpenedDays,
      fullBookedDays: widget.fullBookedDays,
      availableDays: widget.availableDays,
      onMonthChanged: widget.onMonthChanged,
      isLoading: widget.isLoading,
      loadedDays: widget.loadedDays,
    );
  }
}

class _MonthPicker extends StatefulWidget {
  /// Creates a month picker.
  _MonthPicker({
    super.key,
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
    this.notOpenedDays,
    this.fullBookedDays,
    this.availableDays,
    this.onMonthChanged,
    required this.isLoading,
    this.loadedDays,
  }) : assert(!firstDate.isAfter(lastDate));

  /// The initial month to display.
  ///
  /// Subsequently changing this has no effect. To change the selected month,
  /// change the [key] to create a new instance of the [_MonthPicker], and
  /// provide that widget the new [initialMonth]. This will reset the widget's
  /// interactive state.
  final DateTime initialMonth;

  /// The current date.
  ///
  /// This date is subtly highlighted in the picker.
  final DateTime currentDate;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedMonthChanged;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  final List<DateTime?>? notOpenedDays;

  final List<DateTime?>? fullBookedDays;

  final List<DateTime?>? availableDays;

  final Function(DateTime month)? onMonthChanged;

  final bool isLoading;
  final List<EatCalendarEntity>? loadedDays;

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<_MonthPicker> {
  final GlobalKey _pageViewKey = GlobalKey();
  late DateTime _currentMonth;
  late PageController _pageController;
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;
  late FocusNode _dayGridFocus;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialMonth;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(
        widget.firstDate,
        _currentMonth,
      ),
      viewportFraction: 0.75,
    );
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime selectedDate) {
    if (widget.isLoading) {
      return;
    }

    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    if (widget.isLoading) {
      return;
    }

    setState(() {
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);
      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          // We have navigated to a new month with the grid focused, but the
          // focused day is not in this month. Choose a new one trying to keep
          // the same day of the month.
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
        SemanticsService.announce(
          _localizations.formatMonthYear(_currentMonth),
          _textDirection,
        );
      }
    });

    // callback changed month
    if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(_currentMonth);
    }
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  DateTime? _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    // Can we use the preferred day in this month?
    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  bool _isSelectable(DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  /// Builds widgets showing abbreviated days of week. The first widget in the
  /// returned list corresponds to the first day of week for the current locale.
  ///
  /// Examples:
  ///
  ///     ┌ Sunday is the first day of week in the US (en_US)
  ///     |
  ///     S M T W T F S  ← the returned list contains these widgets
  ///     _ _ _ _ _ 1 2
  ///     3 4 5 6 7 8 9
  ///
  ///     ┌ But it's Monday in the UK (en_GB)
  ///     |
  ///     M T W T F S S  ← the returned list contains these widgets
  ///     _ _ _ _ 1 2 3
  ///     4 5 6 7 8 9 10
  ///
  List<Widget> _dayHeaders() {
    final localizations = MaterialLocalizations.of(context);
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    const List<String> shortWeekdays = <String>[
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Week',
    ];

    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex;
        result.length < shortWeekdays.length;
        i = (i + 1) % shortWeekdays.length) {
      final String weekday = shortWeekdays[i];

      result.add(
        ExcludeSemantics(
          child: Center(
            child: Text(
              weekday,
              style: textTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceDim,
              ),
            ),
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _monthPickerHorizontalPadding,
          ),
          child: GridView.custom(
            physics: const ClampingScrollPhysics(),
            gridDelegate: _dayNameGridDelegate,
            shrinkWrap: true,
            childrenDelegate: SliverChildListDelegate(
              _dayHeaders(),
              addRepaintBoundaries: false,
            ),
          ),
        ),
        Expanded(
          child: _FocusedDate(
            date: _dayGridFocus.hasFocus ? _focusedDay : null,
            child: PageView.builder(
              key: _pageViewKey,
              controller: _pageController,
              scrollDirection: Axis.vertical,
              padEnds: false,
              itemCount: DateUtils.monthDelta(
                    widget.firstDate,
                    widget.lastDate,
                  ) +
                  1,
              onPageChanged: _handleMonthPageChanged,
              itemBuilder: (BuildContext context, int index) {
                final month = DateUtils.addMonthsToMonthDate(
                  widget.firstDate,
                  index,
                );
                final isActiveMonth = DateUtils.isSameMonth(
                  month,
                  _currentMonth,
                );

                return Material(
                  color: isActiveMonth ? null : colorScheme.surfaceBright,
                  child: _DayPicker(
                    key: ValueKey<DateTime>(month),
                    selectedDate: widget.currentDate,
                    currentDate: widget.currentDate,
                    onChanged: _handleDateSelected,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    displayedMonth: month,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    notOpenedDays: widget.notOpenedDays,
                    fullBookedDays: widget.fullBookedDays,
                    availableDays: widget.availableDays,
                    isLoading: widget.isLoading,
                    loadedDays: widget.loadedDays,
                    isActiveMonth: isActiveMonth,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// InheritedWidget indicating what the current focused date is for its children.
///
/// This is used by the [_MonthPicker] to let its children [_DayPicker]s know
/// what the currently focused date (if any) should be.
class _FocusedDate extends InheritedWidget {
  const _FocusedDate({
    required super.child,
    this.date,
  });

  final DateTime? date;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) {
    return !DateUtils.isSameDay(date, oldWidget.date);
  }

  static DateTime? maybeOf(BuildContext context) {
    final _FocusedDate? focusedDate =
        context.dependOnInheritedWidgetOfExactType<_FocusedDate>();
    return focusedDate?.date;
  }
}

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _DayPicker extends StatefulWidget {
  /// Creates a day picker.
  _DayPicker({
    super.key,
    required this.currentDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.selectableDayPredicate,
    this.notOpenedDays,
    this.fullBookedDays,
    this.availableDays,
    required this.isLoading,
    this.loadedDays,
    required this.isActiveMonth,
  })  : assert(!firstDate.isAfter(lastDate)),
        assert(selectedDate == null || !selectedDate.isBefore(firstDate)),
        assert(selectedDate == null || !selectedDate.isAfter(lastDate));

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [firstDate].
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  /// Optional user supplied predicate function to customize selectable days.
  final SelectableDayPredicate? selectableDayPredicate;

  final List<DateTime?>? notOpenedDays;

  final List<DateTime?>? fullBookedDays;

  final List<DateTime?>? availableDays;

  final bool isLoading;
  final List<EatCalendarEntity>? loadedDays;
  final bool isActiveMonth;

  @override
  _DayPickerState createState() => _DayPickerState();
}

class _DayPickerState extends State<_DayPicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(
        widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (int index) =>
          FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _FocusedDate.maybeOf(context);
    if (focusedDate != null &&
        DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    final year = widget.displayedMonth.year;
    final month = widget.displayedMonth.month;

    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    final List<Widget> dayItems = [];
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox.shrink());
      } else {
        final dayToBuild = DateTime(year, month, day);
        // final isDisabled = dayToBuild.isAfter(widget.lastDate) ||
        //     dayToBuild.isBefore(widget.firstDate) ||
        //     (widget.selectableDayPredicate != null &&
        //         !widget.selectableDayPredicate!(dayToBuild)) ||
        //     widget.notOpenedDays?.firstOrNullWhere((element) {
        //           return DateUtils.isSameDay(element, dayToBuild);
        //         }) !=
        //         null;
        final isDisabled = !widget.isActiveMonth;
        final isSelectedDay = DateUtils.isSameDay(
          widget.selectedDate,
          dayToBuild,
        );
        final isFullDay = widget.fullBookedDays?.firstOrNullWhere((element) {
              return DateUtils.isSameDay(
                element,
                dayToBuild,
              );
            }) !=
            null;
        final isAvailableDay = widget.availableDays?.firstOrNullWhere(
              (element) {
                return DateUtils.isSameDay(
                  element,
                  dayToBuild,
                );
              },
            ) !=
            null;

        final isFirstDay = day == 1;

        dayItems.add(
          _Day(
            dayToBuild,
            key: ValueKey<DateTime>(dayToBuild),
            isDisabled: isDisabled,
            isSelectedDay: isSelectedDay,
            onChanged: widget.onChanged,
            focusNode: _dayFocusNodes[day - 1],
            isFullDay: isFullDay,
            isAvailableDay: isAvailableDay,
            isLoading: widget.isLoading,
            isFirstDay: isFirstDay,
          ),
        );

        // calculate for the week
        final currentDayWeekday = (day + dayOffset) % 7;
        final isWeek = currentDayWeekday == 0;
        final weekColor = isDisabled ? colorScheme.success : colorScheme.error;
        final weekValue = isDisabled ? 0 : 20; // TODO: calculate week value
        if (isWeek) {
          dayItems.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isDisabled ? context.locale.under : context.locale.over,
                  style: textTheme.labelSmall.copyWith(
                    color: weekColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: weekColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Text(
                    weekValue.toString(),
                    style: textTheme.labelSmall.copyWith(
                      color: colorScheme.onError,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    }

    return GridView.custom(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: _dayPickerGridDelegate,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      childrenDelegate: SliverChildListDelegate(
        dayItems,
        addRepaintBoundaries: false,
      ),
    );
  }
}

class _Day extends StatefulWidget {
  const _Day(
    this.day, {
    super.key,
    required this.isDisabled,
    required this.isSelectedDay,
    required this.isFullDay,
    required this.isAvailableDay,
    required this.onChanged,
    required this.focusNode,
    required this.isLoading,
    required this.isFirstDay,
  });

  final DateTime day;
  final bool isDisabled;
  final bool isSelectedDay;
  final bool isFullDay;
  final bool isAvailableDay;
  final ValueChanged<DateTime> onChanged;
  final FocusNode? focusNode;
  final bool isLoading;
  final bool isFirstDay;

  @override
  State<_Day> createState() => _DayState();
}

class _DayState extends State<_Day> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;
    final localizations = MaterialLocalizations.of(context);
    Color? dayBackgroundColor;
    Color? dayBorderColor;
    Color? iconColor;
    if (widget.isDisabled) {
    } else if (widget.isSelectedDay) {
      dayBackgroundColor = colorScheme.vividTangelo.tint30;
      dayBorderColor = colorScheme.primary;
    } else if (widget.isAvailableDay) {
      dayBackgroundColor = colorScheme.success;
    } else if (widget.isFullDay) {
      dayBackgroundColor = colorScheme.error;
    }

    // TODO: icon color
    iconColor ??= colorScheme.success;

    Widget dayWidget = Container(
      decoration: BoxDecoration(
        color: dayBackgroundColor,
        border: Border.all(
          color: dayBorderColor ?? Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.isFirstDay) ...[
            Text(
              widget.day
                      .formatDate(
                        format: "MMM",
                      )
                      ?.toUpperCase() ??
                  '',
              style: textTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurfaceDim,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
          ],
          Text(
            localizations.formatDecimal(widget.day.day),
            style: textTheme.labelSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          if (widget.isLoading) ...[
            const ShimmerLoading.circular(
              width: 35,
              height: 35,
            ),
          ] else ...[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(
                    value: 0.99,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.outline,
                    ),
                    strokeWidth: 4,
                  ),
                ),
                if (!widget.isDisabled) ...[
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      value: 0.6,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.success,
                      ),
                      strokeWidth: 4,
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: iconColor,
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(
            height: 6,
          ),
        ],
      ),
    );

    if (widget.isDisabled || widget.isFullDay) {
      return ExcludeSemantics(
        child: dayWidget,
      );
    } else {
      return InkWell(
        focusNode: widget.focusNode,
        onTap: () => widget.onChanged(widget.day),
        borderRadius: BorderRadius.circular(6),
        child: Semantics(
          label:
              '${localizations.formatDecimal(widget.day.day)}, ${localizations.formatFullDate(widget.day)}',
          button: true,
          selected: widget.isSelectedDay,
          excludeSemantics: true,
          child: dayWidget,
        ),
      );
    }
  }
}

const _DayNameGridDelegate _dayNameGridDelegate = _DayNameGridDelegate();

class _DayNameGridDelegate extends SliverGridDelegate {
  const _DayNameGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const columnCount = DateTime.daysPerWeek + 1;
    final tileWidth = constraints.crossAxisExtent / columnCount;

    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: 30,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: 30,
      reverseCrossAxis: axisDirectionIsReversed(
        constraints.crossAxisDirection,
      ),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}

const _DayPickerGridDelegate _dayPickerGridDelegate = _DayPickerGridDelegate();

class _DayPickerGridDelegate extends SliverGridDelegate {
  const _DayPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const columnCount = DateTime.daysPerWeek + 1;
    final tileWidth = constraints.crossAxisExtent / columnCount;
    final tileHeight = math.min(
      _dayPickerRowHeight,
      constraints.viewportMainAxisExtent / (_maxDayPickerRowCount + 1),
    );

    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: tileHeight * 1.4,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: tileHeight * 1.4,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}
