import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/border_radius_config.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';

const _maxDataLength = 7;

class ActivityWidget extends StatelessWidget {
  final String iconPath;
  final String activity;
  final Widget? valueWidget;
  final String? value;
  final String? unitIconPath;
  final String? unit;
  final String time;
  final List<double>? data;
  final bool isLoading;
  final bool isError;
  final bool isInitial;

  const ActivityWidget({
    super.key,
    required this.iconPath,
    required this.activity,
    this.valueWidget,
    this.value,
    this.unitIconPath,
    this.unit,
    required this.time,
    required this.data,
    required this.isLoading,
    required this.isError,
    required this.isInitial,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    if (isInitial) {
      // TODO: handle initial
      return const _ContainerWidget(
        child: SizedBox(
          height: 100,
        ),
      );
    } else if (isLoading) {
      return const _ContainerWidget(
        child: _LoadingWidget(),
      );
    } else if (isError) {
      // TODO: handle error
      return const _ContainerWidget(
        child: _LoadingWidget(),
      );
    }

    return _ContainerWidget(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      iconPath,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      activity.toCapitalize(),
                      style: textTheme.labelMedium.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Row(
                children: [
                  Text(
                    time,
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceBright,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset(
                    AssetIconsPath.icChevronRight,
                    colorFilter: ColorFilter.mode(
                      colorScheme.onSurfaceBright,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.width * 0.5,
                ),
                child: valueWidget ??
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value ?? '0',
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
                          child: Column(
                            children: [
                              if (unitIconPath != null) ...[
                                SvgPicture.asset(
                                  unitIconPath!,
                                  colorFilter: ColorFilter.mode(
                                    colorScheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                              Text(
                                unit ?? '',
                                style: textTheme.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceBright,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              ),
              const SizedBox(
                width: 16,
              ),
              if (data == null) ...[
                const _EmptyChartWidget(),
              ] else ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: SizedBox(
                      height: 58,
                      child: BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(
                            enabled: false,
                          ),
                          titlesData: const FlTitlesData(
                            show: false,
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: const FlGridData(
                            show: false,
                          ),
                          barGroups: List.generate(
                            data!.length > _maxDataLength
                                ? _maxDataLength
                                : data!.length,
                            (index) {
                              final x = index;
                              final y = data![index];
                              final isLast = index == _maxDataLength - 1;

                              // TODO: Handle data if y is 0, show little bar height

                              return BarChartGroupData(
                                x: x,
                                barRods: [
                                  BarChartRodData(
                                    toY: y,
                                    color: isLast
                                        ? colorScheme.primary
                                        : colorScheme.outlineBright,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(3),
                                    ),
                                    width: 12,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ContainerWidget extends StatelessWidget {
  final Widget child;

  const _ContainerWidget({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusConfig.l,
        border: Border.all(
          color: colorScheme.outlineBright,
        ),
      ),
      child: child,
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ShimmerLoading.rectangular(
                  width: 16,
                  height: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                ShimmerLoading.rectangular(
                  width: 58,
                  height: 16,
                ),
              ],
            ),
            ShimmerLoading.rectangular(
              width: 58,
              height: 16,
            ),
          ],
        ),
        const SizedBox(
          height: 55,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                ShimmerLoading.rectangular(
                  width: 44,
                  height: 44,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    ShimmerLoading.rectangular(
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ShimmerLoading.rectangular(
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            const _EmptyChartWidget(),
          ],
        ),
      ],
    );
  }
}

class _EmptyChartWidget extends StatelessWidget {
  const _EmptyChartWidget();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Row(
      children: List.generate(
        _maxDataLength,
        (index) {
          final isLast = index == 6;

          return Container(
            width: 12,
            height: 2,
            margin: EdgeInsets.only(
              right: isLast ? 0 : 2,
            ),
            decoration: BoxDecoration(
              color: isLast ? colorScheme.primary : colorScheme.outlineBright,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          );
        },
      ),
    );
  }
}
