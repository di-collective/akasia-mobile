import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../widgets/category_item_widget.dart';
import '../widgets/workout_day_item_widget.dart';

class TenDaysWorkoutPage extends StatefulWidget {
  const TenDaysWorkoutPage({super.key});

  @override
  State<TenDaysWorkoutPage> createState() => _TenDaysWorkoutPageState();
}

class _TenDaysWorkoutPageState extends State<TenDaysWorkoutPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImageWidget(
              size: Size(context.width, 375),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "10 ${context.locale.daysWorkout}",
                    style: textTheme.headlineSmall.copyWith(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CategoryItemWidget(
                        iconPath: AssetIconsPath.icSchedule,
                        title: "10 ${context.locale.days}",
                      ),
                      CategoryItemWidget(
                        iconPath: AssetIconsPath.icFitness,
                        title: context.locale.strenght,
                      ),
                      CategoryItemWidget(
                        iconPath: AssetIconsPath.icBarChart,
                        title: context.locale.advanced,
                      ),
                      CategoryItemWidget(
                        iconPath: AssetIconsPath.icModelTraining,
                        title: context.locale.bulking,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ListView.separated(
                    itemCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.only(
                      bottom: context.paddingBottom,
                    ),
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      return WorkoutDayItemWidget(
                        dayNumber: index + 1,
                        onWorkoutSelected: _workoutItem,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _workoutItem(int index) {
    // go to day workout details page
    context.goNamed(AppRoute.dayWorkoutDetails.name);
  }
}
