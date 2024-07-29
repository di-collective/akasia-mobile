import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/dimens.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';

class WorkoutDayItemWidget extends StatefulWidget {
  final int dayNumber;
  final Function(int workoutIndex) onWorkoutSelected;

  const WorkoutDayItemWidget({
    super.key,
    required this.dayNumber,
    required this.onWorkoutSelected,
  });

  @override
  State<WorkoutDayItemWidget> createState() => _WorkoutDayItemWidgetState();
}

class _WorkoutDayItemWidgetState extends State<WorkoutDayItemWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return ExpansionTile(
      title: Text(
        "${context.locale.day} ${widget.dayNumber}".toUpperCase(),
        style: textTheme.bodySmall.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      tilePadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ),
        side: BorderSide(
          color: colorScheme.outline,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.large,
        ),
        side: BorderSide(
          color: colorScheme.outline,
        ),
      ),
      childrenPadding: EdgeInsets.zero,
      onExpansionChanged: (value) {
        setState(() {
          isExpanded = value;
        });
      },
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Full Body",
            maxLines: 2,
            style: textTheme.labelLarge.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "6 ${context.locale.exercises} • 55-65 Mins",
            style: textTheme.bodySmall.copyWith(
              color: colorScheme.onSurfaceDim,
            ),
          ),
        ],
      ),
      trailing: Container(
        height: 36,
        width: 36,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.primaryTonal,
          borderRadius: BorderRadius.circular(
            AppRadius.extraSmall,
          ),
        ),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 300),
          turns: isExpanded ? 0.5 : 0,
          child: SvgPicture.asset(
            AssetIconsPath.icChevronDown,
            colorFilter: ColorFilter.mode(
              context.theme.appColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      children: [
        Divider(
          color: colorScheme.outline,
          height: 1,
          thickness: 2,
        ),
        const SizedBox(
          height: 8,
        ),
        ListView.builder(
          itemCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          itemBuilder: (context, index) {
            return _ItemWidget(
              index: index,
              onTap: _onWorkoutSelected,
            );
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void _onWorkoutSelected(int index) {
    widget.onWorkoutSelected(index);
  }
}

class _ItemWidget extends StatelessWidget {
  final int index;
  final Function(int index) onTap;

  const _ItemWidget({
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return InkWell(
      onTap: () {
        onTap(index);
      },
      borderRadius: BorderRadius.circular(
        AppRadius.large,
      ),
      splashColor: colorScheme.primary.withOpacity(0.1),
      highlightColor: colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          children: [
            const NetworkImageWidget(
              size: Size(96, 64),
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wall Squat, Single Leg",
                    maxLines: 3,
                    style: textTheme.titleSmall.copyWith(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "3 sets • 12 reps",
                    style: textTheme.bodySmall.copyWith(
                      color: colorScheme.onSurface,
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
