import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/common/directory_info.dart';
import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/localization/app_supported_locales.dart';
import '../../../../core/ui/widget/dialogs/toast_info.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/permission_info.dart';
import '../../../../core/utils/service_locator.dart';
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

  Future<void> _onMealPlan() async {
    try {
      // check permission for notification
      final isGranted = await sl<PermissionInfo>().requestPermission(
        permission: Permission.notification,
      );
      if (!isGranted) {
        throw "Permission not granted";
      }

      // get documents directory
      final directory = await sl<DirectoryInfo>().documentsDirectory;
      if (directory == null) {
        throw "Failed to get documents directory";
      }

      // download tasks
      // TODO: Change the pdfUrl to the actual URL
      const pdfUrl =
          "https://drive.google.com/uc?export=download&id=11DOhVWM0EbNnlPVfRF6eBZnZbMeMmWt1";
      final fileName = "meal_plan-${DateTime.now().millisecondsSinceEpoch}.pdf";
      final taskId = await FlutterDownloader.enqueue(
        url: pdfUrl,
        savedDir: directory.path,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
        fileName: fileName,
      );
      if (taskId == null) {
        throw "Download task not found";
      }

      // show loading
      context.showFullScreenLoading(
        message: context.locale.downloadingProgress("0"),
      );

      while (true) {
        final tasks = await FlutterDownloader.loadTasksWithRawQuery(
          query: "SELECT * FROM task WHERE task_id = '$taskId'",
        );
        Logger.success("Download tasks: $tasks");
        if (tasks == null || tasks.isEmpty) {
          break;
        }

        final task = tasks.first;
        final status = task.status;
        Logger.success("Download status: $status");
        if (status == DownloadTaskStatus.complete) {
          break;
        }

        // update progress
        final progress = task.progress;
        context.updateFullScreenLoading(
          message: context.locale.downloadingProgress(
            progress.toString(),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
      }
      Logger.success("Download taskId: $taskId");

      // open file
      // FIXME: Error: java.lang.IllegalArgumentException: Failed to find configured root that contains /data/data/com.akasia365mc/app_flutter/meal_plan-1721037534156.pdf
      // await FlutterDownloader.open(
      //   taskId: taskId,
      // );
    } catch (error) {
      sl<ToastInfo>().show(
        type: ToastType.error,
        message: error.message(context),
        context: context,
      );
    } finally {
      // hide loading
      context.hideFullScreenLoading;
    }
  }
}
