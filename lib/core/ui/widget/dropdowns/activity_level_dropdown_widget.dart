import 'package:flutter/material.dart';

import '../../../../features/activity_level/data/datasources/local/activity_level_config.dart';
import '../../../../features/activity_level/domain/entities/activity_level_entity.dart';
import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../images/network_image_widget.dart';
import 'dropdown_widget.dart';

class ActivityLevelDropdownWidget extends DropdownWidget<ActivityLevelEntity> {
  final BuildContext context;

  ActivityLevelDropdownWidget({
    super.key,
    required this.context,
    super.hintText,
    super.title,
    Function(ActivityLevelEntity? option)? onChanged,
    String? Function(dynamic value)? validator,
    super.selectedValue,
    super.borderRadius,
    super.contentPadding,
    super.isDisabled,
    super.isLoading,
    super.backgroundColor,
    super.isRequired,
  }) : super(
          onChanged: (value) {
            if (onChanged != null) {
              onChanged(value);
            }
          },
          validate: validator,
          itemHeight: 72,
          items: _generateDropdownMenuItem(
            context: context,
          ),
          selectedItemBuilder: _generateItemBuilder(
            context: context,
          ),
          borderRadiusMenu: BorderRadius.circular(20),
        );

  static List<DropdownMenuItem<ActivityLevelEntity>> _generateDropdownMenuItem({
    required BuildContext context,
  }) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return ActivityLevelLocalConfig.allActivityLevels.map(
      (activityLevel) {
        return DropdownMenuItem(
          value: activityLevel,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            height: 72,
            child: Row(
              children: [
                const NetworkImageWidget(
                  size: Size(40, 40),
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        activityLevel.activity ?? '',
                        style: textTheme.labelLarge.copyWith(
                          color: colorScheme.onSurfaceDim,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        activityLevel.description ?? '',
                        style: textTheme.labelMedium.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).toList();
  }

  static List<Widget> _generateItemBuilder({
    required BuildContext context,
  }) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return ActivityLevelLocalConfig.allActivityLevels.map((activityLevel) {
      return Text(
        activityLevel.activity ?? '',
        style: textTheme.bodyLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      );
    }).toList();
  }
}
