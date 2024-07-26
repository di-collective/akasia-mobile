import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/duration_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../domain/entities/sleep_activity_entity.dart';
import '../widgets/activity_detail_item_widget.dart';

class SleepDetailsPageParams {
  final List<SleepActivityEntity> sleeps;
  final String formattedDateRange;
  final Duration totalDuration;

  SleepDetailsPageParams({
    required this.sleeps,
    required this.formattedDateRange,
    required this.totalDuration,
  });
}

class SleepDetailsPage extends StatefulWidget {
  final SleepDetailsPageParams? params;

  const SleepDetailsPage({
    super.key,
    required this.params,
  });

  @override
  State<SleepDetailsPage> createState() => _SleepDetailsPageState();
}

class _SleepDetailsPageState extends State<SleepDetailsPage> {
  SleepDetailsPageParams? params;

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

    final hours = params!.totalDuration.inHours;
    final remainingMinutes = params!.totalDuration.remainingMinutes;
    final sleeps = params!.sleeps;
    final formattedDateRange = params!.formattedDateRange;

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
                      "${context.locale.inBedIntervals} $formattedDateRange",
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
                        hours.toString(),
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
                          "hrs",
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurfaceBright,
                          ),
                        ),
                      ),
                      Text(
                        remainingMinutes.toString(),
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
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            ListView.separated(
              itemCount: sleeps.length,
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final sleep = sleeps[index];

                String? durationInHours = "0";
                String? durationRemainingInMinutes = "0";
                String? formattedStartHour;
                String? formattedEndHour;

                final fromDate = sleep.fromDate;
                final toDate = sleep.toDate;
                if (fromDate != null && toDate != null) {
                  final duration = toDate.difference(fromDate);

                  durationInHours = duration.inHours.toString();
                  durationRemainingInMinutes = duration.remainingMinutes;

                  formattedStartHour = fromDate.formatDate(
                    format: 'HH.mm',
                  );
                  formattedEndHour = toDate.formatDate(
                    format: 'HH.mm',
                  );
                }

                final title =
                    "$durationInHours hrs $durationRemainingInMinutes min";
                final description = "$formattedStartHour - $formattedEndHour";
                return ActivityDetailItemWidget(
                  isFirst: index == 0,
                  isLast: index == sleeps.length - 1,
                  title: title,
                  description: description,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
