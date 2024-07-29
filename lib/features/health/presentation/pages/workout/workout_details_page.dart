import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/config/asset_path.dart';
import '../../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../../core/ui/extensions/duration_extension.dart';
import '../../../../../core/ui/extensions/string_extension.dart';
import '../../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../domain/entities/workout_activity_entity.dart';
import '../../widgets/activity_detail_item_widget.dart';

class WorkoutDetailsPageParams {
  final List<WorkoutActivityEntity> items;
  final String formattedDate;
  final Duration totalDuration;

  WorkoutDetailsPageParams({
    required this.items,
    required this.formattedDate,
    required this.totalDuration,
  });
}

class WorkoutDetailsPage extends StatefulWidget {
  final WorkoutDetailsPageParams? params;

  const WorkoutDetailsPage({
    super.key,
    required this.params,
  });

  @override
  State<WorkoutDetailsPage> createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage> {
  WorkoutDetailsPageParams? params;

  @override
  void initState() {
    super.initState();

    params = widget.params;
  }

  @override
  Widget build(BuildContext context) {
    if (params == null) {
      return const SizedBox.shrink();
    }

    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    final minutes = params!.totalDuration.inMinutes;
    final remainingSeconds = params!.totalDuration.remainingSeconds;
    final items = params!.items;
    final formattedDate = params!.formattedDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.allData,
        ),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingHorizontal,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AssetIconsPath.icBed,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${context.locale.workouts}: $formattedDate",
                      maxLines: 2,
                      style: textTheme.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceBright,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        minutes.toString(),
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
                      Text(
                        remainingSeconds.toString(),
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
                          "sec",
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurfaceBright,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            ListView.separated(
              itemCount: items.length,
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final workout = items[index];

                int durationInMinutes = 0;
                String? durationRemainingInSeconds = "0";
                String? formattedStartHour;
                String? formattedEndHour;

                final fromDate = workout.fromDate;
                final toDate = workout.toDate;
                if (fromDate != null && toDate != null) {
                  final duration = toDate.difference(fromDate);

                  durationInMinutes = duration.inMinutes;
                  durationRemainingInSeconds = duration.remainingSeconds;

                  formattedStartHour = fromDate.formatDate(
                    format: 'HH.mm',
                  );
                  formattedEndHour = toDate.formatDate(
                    format: 'HH.mm',
                  );
                }

                return ActivityDetailItemWidget(
                  isFirst: index == 0,
                  isLast: index == items.length - 1,
                  description: "$formattedStartHour - $formattedEndHour",
                  titleWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.type?.toCapitalize() ?? "",
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurfaceBright,
                        ),
                      ),
                      Text(
                        "${durationInMinutes}min $durationRemainingInSeconds sec",
                        style: textTheme.titleSmall.copyWith(
                          color: colorScheme.onSurfaceDim,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
