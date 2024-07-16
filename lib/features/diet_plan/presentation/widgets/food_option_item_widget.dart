import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../domain/entities/food_entity.dart';

class FoodOptionItemWidget extends StatelessWidget {
  final FoodEntity food;
  final Function() onFood;

  const FoodOptionItemWidget({
    super.key,
    required this.food,
    required this.onFood,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return InkWell(
      onTap: onFood,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        color: colorScheme.white,
        child: Row(
          children: [
            Container(
              color: Colors.amber,
              height: 32,
              width: 32,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name?.toCapitalizes() ?? '',
                    maxLines: 3,
                    style: textTheme.labelLarge.copyWith(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    food.description?.toCapitalize() ?? '',
                    maxLines: 5,
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
  }
}
