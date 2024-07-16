import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'activity_item_widget.dart';

class ActivitiesWidget extends StatefulWidget {
  const ActivitiesWidget({super.key});

  @override
  State<ActivitiesWidget> createState() => _ActivitiesWidgetState();
}

class _ActivitiesWidgetState extends State<ActivitiesWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.summary,
          style: textTheme.titleMedium.copyWith(
            color: colorScheme.onSurfaceDim,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ActivityWidget(
          iconPath: AssetIconsPath.icSteps,
          activity: context.locale.steps,
          value: "1.900",
          unit: "steps",
          time: "12:00",
          data: List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ActivityWidget(
          iconPath: AssetIconsPath.icHeartRate,
          activity: context.locale.heartRate,
          value: "68",
          unit: "bpm",
          unitIconPath: AssetIconsPath.icLove,
          time: "12:00",
          data: List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ActivityWidget(
          iconPath: AssetIconsPath.icFish,
          activity: context.locale.nutritions,
          value: "800",
          unit: "kcal",
          time: "12:00",
          data: List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ActivityWidget(
          iconPath: AssetIconsPath.icWorkout,
          activity: context.locale.workouts,
          value: "30",
          unit: "min",
          time: "12:00",
          data: List.generate(
            7,
            (index) => Random().nextInt(100).toDouble(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ActivityWidget(
          iconPath: AssetIconsPath.icBed,
          activity: context.locale.sleep,
          time: "12:00",
          valueWidget: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "5",
                style: textTheme.headlineLarge.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                ),
                child: Text(
                  "h",
                  style: textTheme.bodySmall.copyWith(
                    color: colorScheme.onSurfaceBright,
                  ),
                ),
              ),
              Text(
                "30",
                style: textTheme.headlineLarge.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                ),
                child: Text(
                  "min",
                  style: textTheme.bodySmall.copyWith(
                    color: colorScheme.onSurfaceBright,
                  ),
                ),
              ),
            ],
          ),
          data: List.generate(
            7,
            (index) => Random().nextInt(10).toDouble() + 5,
          ),
        ),
      ],
    );
  }
}
