import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../domain/entities/nutrition_activity_entity.dart';
import '../widgets/activity_detail_item_widget.dart';

class NutritionDetailsPageParams {
  final DateTime date;
  final List<NutritionActivityEntity> items;
  final double nutritionsInDay;

  NutritionDetailsPageParams({
    required this.date,
    required this.items,
    required this.nutritionsInDay,
  });
}

class NutritionDetailsPage extends StatefulWidget {
  final NutritionDetailsPageParams? params;

  const NutritionDetailsPage({
    super.key,
    required this.params,
  });

  @override
  State<NutritionDetailsPage> createState() => NutritionDetailsPageState();
}

class NutritionDetailsPageState extends State<NutritionDetailsPage> {
  NutritionDetailsPageParams? params;

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

    final items = params!.items.reversed.toList();
    final nutritionsInDay = params!.nutritionsInDay;
    final date = params!.date;
    final formattedDate = date.formatDate(
      format: "dd MMMM yyyy",
    );

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
                      AssetIconsPath.icFish,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${context.locale.nutritions}: $formattedDate",
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
                        nutritionsInDay.toString(),
                        style: textTheme.headlineLarge.copyWith(
                          color: colorScheme.onSurfaceDim,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          "cal",
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurface,
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
                final item = items[index];

                final value = item.value;
                final fromDate = item.fromDate?.formatDate(
                  format: "HH:mm",
                );

                return ActivityDetailItemWidget(
                  isFirst: index == 0,
                  isLast: index == items.length - 1,
                  title: "$value cal",
                  description: fromDate ?? '',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
