import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';

class EditActivityLevelBodyWidget extends StatefulWidget {
  final WeightGoalActivityLevel? currentActivityLevel;
  final Function(WeightGoalActivityLevel value) onSave;

  const EditActivityLevelBodyWidget({
    super.key,
    required this.currentActivityLevel,
    required this.onSave,
  });

  @override
  State<EditActivityLevelBodyWidget> createState() =>
      _EditActivityLevelBodyWidgetState();
}

class _EditActivityLevelBodyWidgetState
    extends State<EditActivityLevelBodyWidget> {
  WeightGoalActivityLevel? _selectedActivityLevel;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _selectedActivityLevel = widget.currentActivityLevel;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 24,
        horizontal: context.paddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.locale.activityLevel,
            style: textTheme.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ListView.builder(
            itemCount: WeightGoalActivityLevel.values.length,
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final activityLevel = WeightGoalActivityLevel.values[index];
              final isSelected = activityLevel == _selectedActivityLevel;

              return _ItemWidget(
                activityLevel: activityLevel,
                isSelected: isSelected,
                onTap: _onTap,
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonWidget(
            text: context.locale.save,
            isDisabled: _selectedActivityLevel == null ||
                _selectedActivityLevel == widget.currentActivityLevel,
            width: context.width,
            onTap: _onSave,
          ),
        ],
      ),
    );
  }

  void _onTap(WeightGoalActivityLevel value) {
    if (value == _selectedActivityLevel) {
      return;
    }

    setState(() {
      _selectedActivityLevel = value;
    });
  }

  void _onSave() {
    if (_selectedActivityLevel == null) {
      return;
    }

    widget.onSave(_selectedActivityLevel!);
  }
}

class _ItemWidget extends StatelessWidget {
  final WeightGoalActivityLevel activityLevel;
  final bool isSelected;
  final Function(WeightGoalActivityLevel value) onTap;

  const _ItemWidget({
    required this.activityLevel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return InkWell(
      onTap: () {
        onTap(activityLevel);
      },
      borderRadius: BorderRadius.circular(
        AppRadius.medium,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.surfaceContainerDim : null,
          borderRadius: BorderRadius.circular(
            AppRadius.medium,
          ),
        ),
        child: Row(
          children: [
            NetworkImageWidget(
              size: const Size(40, 40),
              fit: BoxFit.cover,
              imageUrl: activityLevel.iconPath,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityLevel.title,
                    style: textTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceDim,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    activityLevel.description,
                    maxLines: 3,
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
