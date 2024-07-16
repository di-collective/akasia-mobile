import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/eat_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/widget/buttons/icon_button_widget.dart';
import '../../../../core/ui/widget/dialogs/toast_info.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../pages/add_eaten_food_page.dart';

class EatWidget extends StatefulWidget {
  final DateTime date;

  const EatWidget({
    super.key,
    required this.date,
  });

  @override
  State<EatWidget> createState() => _EatWidgetState();
}

class _EatWidgetState extends State<EatWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.locale.whatDidYouEatToday,
          style: textTheme.titleMedium.copyWith(
            color: colorScheme.onSurfaceDim,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        ListView.separated(
          itemCount: EatTime.values.length,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 12,
            );
          },
          itemBuilder: (context, index) {
            final eatTime = EatTime.values[index];

            return _EatItemWidget(
              eatTime: eatTime,
              onAddFood: () {
                _onAddFood(
                  eatTime: eatTime,
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _onAddFood({
    required EatTime eatTime,
  }) {
    context.goNamed(
      AppRoute.addEat.name,
      extra: AddEatenFoodPageParams(
        eatTime: eatTime,
        date: widget.date,
      ),
    );
  }
}

class _EatItemWidget extends StatefulWidget {
  final EatTime eatTime;
  final Function() onAddFood;

  const _EatItemWidget({
    required this.eatTime,
    required this.onAddFood,
  });

  @override
  State<_EatItemWidget> createState() => __EatItemWidgetState();
}

class __EatItemWidgetState extends State<_EatItemWidget> {
  final List _foods = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.paddingHorizontal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.eatTime.title(context: context).toUpperCase(),
                  style: textTheme.bodyLarge.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "235",
                  style: textTheme.bodyLarge.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (_foods.isEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Text(
                context.locale.noData,
                style: textTheme.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceBright,
                ),
              ),
            ),
          ] else ...[
            ListView.builder(
              itemCount: _foods.length,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                final food = _foods[index];

                return Dismissible(
                  key: Key(food.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _onDeleteFood(
                      index: index,
                    );
                  },
                  onDismissed: (direction) {
                    // TODO: Implement delete food
                    setState(() {
                      _foods.removeAt(index);
                    });
                  },
                  background: Container(
                    color: colorScheme.error,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                      ),
                      child: Text(
                        context.locale.delete,
                        style: textTheme.bodyLarge.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    child: Row(
                      children: [
                        const NetworkImageWidget(
                          size: Size(32, 32),
                          fit: BoxFit.cover,
                          shapeBorder: CircleBorder(),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nasi Putih".toCapitalizes(),
                                style: textTheme.labelLarge.copyWith(
                                  color: colorScheme.onSurfaceDim,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "235",
                                style: textTheme.bodyMedium.copyWith(
                                  color: colorScheme.onSurfaceBright,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButtonWidget(
                icon: SvgPicture.asset(
                  AssetIconsPath.icAdd,
                  height: 20,
                  width: 20,
                ),
                backgroundColor: colorScheme.primaryTonal,
                onPressed: widget.onAddFood,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onDeleteFood({
    required int index,
  }) async {
    try {
      // show loading
      context.showFullScreenLoading();

      // TODO: Implement delete food
      await Future.delayed(const Duration(seconds: 2));

      sl<ToastInfo>().show(
        context: context,
        type: ToastType.success,
        message: "Food deleted successfully",
      );

      return true;
    } catch (error) {
      sl<ToastInfo>().show(
        context: context,
        type: ToastType.error,
        message: error.message(context),
      );

      return false;
    } finally {
      // hide loading
      context.hideFullScreenLoading;
    }
  }
}
