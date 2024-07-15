import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/localization/app_supported_locales.dart';
import '../widgets/eat_widget.dart';
import '../widgets/nutrition_information_widget.dart';
import 'diet_plan_calendar_page.dart';

class DietPlanPage extends StatefulWidget {
  const DietPlanPage({super.key});

  @override
  State<DietPlanPage> createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.dietPlan.toCapitalizes(),
        ),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _onPreviousCalendar,
                  child: SvgPicture.asset(
                    AssetIconsPath.icChevronLeft,
                    height: 12,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: _onCalendar,
                  child: Text(
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
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: _onNextCalendar,
                  child: SvgPicture.asset(
                    AssetIconsPath.icChevronRight,
                    height: 12,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            GestureDetector(
              onTap: _onMealPlan,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.white,
                  border: Border.all(
                    color: colorScheme.outline,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AssetImagesPath.mealPlan,
                      height: 60,
                      width: 60,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.locale.mealPlanRecomendation,
                            maxLines: 2,
                            style: textTheme.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceDim,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            context.locale.mealPlanRecomendationDescription,
                            maxLines: 10,
                            style: textTheme.bodyMedium.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    SvgPicture.asset(
                      AssetIconsPath.icChevronRight,
                      height: 12,
                      colorFilter: ColorFilter.mode(
                        colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const NutritionInformationWidget(),
            const SizedBox(
              height: 32,
            ),
            EatWidget(
              date: _selectedDate,
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }

  void _onPreviousCalendar() {
    // change selected date to previous day
    setState(() {
      _selectedDate = _selectedDate.addDays(-1);
    });
  }

  Future<void> _onCalendar() async {
    // push to diet plan calendar page
    final selectedCalendar = await context.pushNamed<DateTime?>(
      AppRoute.dietPlanCalendar.name,
      extra: DietPlanCalendarPageParams(
        date: _selectedDate,
      ),
    );
    if (selectedCalendar == null || selectedCalendar == _selectedDate) {
      return;
    }

    // change selected date
    setState(() {
      _selectedDate = selectedCalendar;
    });
  }

  void _onNextCalendar() {
    // change selected date to next day
    setState(() {
      _selectedDate = _selectedDate.addDays(1);
    });
  }

  void _onMealPlan() {
    // TODO: Implement this method
  }
}
