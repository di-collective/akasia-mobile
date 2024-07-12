import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/localization/app_supported_locales.dart';
import '../widgets/diet_date_picker_widget.dart';

class DietPlanCalendarPageParams {
  final DateTime date;

  DietPlanCalendarPageParams({
    required this.date,
  });
}

class DietPlanCalendarPage extends StatefulWidget {
  final DietPlanCalendarPageParams? params;

  const DietPlanCalendarPage({
    super.key,
    required this.params,
  });

  @override
  State<DietPlanCalendarPage> createState() => _DietPlanCalendarPageState();
}

class _DietPlanCalendarPageState extends State<DietPlanCalendarPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _selectedDate = widget.params?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.white,
        surfaceTintColor: colorScheme.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _onToday,
              child: Text(
                context.locale.today,
                style: textTheme.labelLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _onPreviousCalendar,
                  child: SvgPicture.asset(
                    AssetIconsPath.icChevronLeft,
                    height: 14,
                    width: 14,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  _selectedDate.formatDate(
                        locale: AppSupportedLocales.en.languageCode,
                        isShortDay: true,
                        isShortMonth: true,
                        isHideDayYear: true,
                      ) ??
                      '',
                  style: textTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: _onNextCalendar,
                  child: SvgPicture.asset(
                    AssetIconsPath.icChevronRight,
                    height: 14,
                    width: 14,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: _onClose,
              child: Text(
                context.locale.close,
                style: textTheme.labelLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        child: DietDatePickerWidget(
          firstDate: DateTime.now().addDays(-365),
          lastDate: DateTime.now().addDays(365),
          isLoading: false,
          initialDate: _selectedDate,
          onMonthChanged: _onMonthChanged,
          onDateSelected: _onDateSelected,
        ),
      ),
    );
  }

  void _onToday() {
    // TODO: Implement this method
  }

  void _onPreviousCalendar() {
    // TODO: Implement this method
  }

  void _onNextCalendar() {
    // TODO: Implement this method
  }

  void _onClose() {
    // TODO: Implement this method
    context.pop();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onMonthChanged(DateTime date) {
    // TODO: Implement this method
  }
}
