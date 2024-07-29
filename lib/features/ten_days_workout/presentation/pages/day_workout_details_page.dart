import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/color_scheme.dart';
import '../../../../core/ui/widget/buttons/bottom_sheet_button_widget.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/buttons/outline_button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';

class DayWorkoutDetailsPageParams {
  final int selectedIndex;

  const DayWorkoutDetailsPageParams({
    required this.selectedIndex,
  });
}

class DayWorkoutDetailsPage extends StatefulWidget {
  final DayWorkoutDetailsPageParams? params;

  const DayWorkoutDetailsPage({
    super.key,
    this.params,
  });

  @override
  State<DayWorkoutDetailsPage> createState() => _DayWorkoutDetailsPageState();
}

class _DayWorkoutDetailsPageState extends State<DayWorkoutDetailsPage> {
  int selectedExercise = 0;
  int totalExercises = 3;

  @override
  void initState() {
    super.initState();

    selectedExercise = widget.params?.selectedIndex ?? 0;
  }

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                          "Wall Squat, Single Leg",
                          style: textTheme.headlineSmall.copyWith(
                            color: colorScheme.onSurfaceDim,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${context.locale.exercise} ${selectedExercise + 1}/$totalExercises",
                          style: textTheme.bodyMedium.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetIconsPath.icSchedule,
                              width: 17,
                              colorFilter: ColorFilter.mode(
                                colorScheme.onSurface,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                "4 min, 3 Set",
                                maxLines: 3,
                                style: textTheme.bodyMedium.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetIconsPath.icDirectionRun,
                              width: 17,
                              colorFilter: ColorFilter.mode(
                                colorScheme.onSurface,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Text(
                                "Upper body strength, shoulders",
                                maxLines: 3,
                                style: textTheme.bodyMedium.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                          context.locale.instructions,
                          style: textTheme.titleMedium.copyWith(
                            color: colorScheme.onSurfaceDim,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Lean your back flat against the wall with your feet in front of you. Slide down until your thighs are parallel to the floor. Lift one leg an rest it on the opposite thigh. Hold this position for as long as possible. Switch sides.",
                          maxLines: 10,
                          style: textTheme.bodyMedium.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomSheetButtonWidget(
            child: Row(
              children: [
                Expanded(
                  child: _previousButton(
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: _nextButton(
                    colorScheme: colorScheme,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _previousButton({
    required AppColorScheme colorScheme,
  }) {
    if (selectedExercise != 0) {
      return OutlineButtonWidget(
        text: context.locale.previous,
        colorScheme: colorScheme,
        onTap: _onPrevious,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _nextButton({
    required AppColorScheme colorScheme,
  }) {
    if (selectedExercise != totalExercises - 1) {
      return OutlineButtonWidget(
        text: context.locale.next,
        colorScheme: colorScheme,
        onTap: _onNext,
      );
    }

    return ButtonWidget(
      text: context.locale.finish,
      onTap: _onFinish,
    );
  }

  void _onNext() {
    if (selectedExercise == totalExercises - 1) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      selectedExercise++;
    });
  }

  void _onPrevious() {
    if (selectedExercise == 0) {
      return;
    }

    setState(() {
      selectedExercise--;
    });
  }

  void _onFinish() {
    context.pop();
  }
}
