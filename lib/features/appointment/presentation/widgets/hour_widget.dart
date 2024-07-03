import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class HourWidget extends StatefulWidget {
  final TimeOfDay? selectedHour;
  final Function(TimeOfDay) onHourSelected;

  const HourWidget({
    super.key,
    this.selectedHour,
    required this.onHourSelected,
  });

  @override
  State<HourWidget> createState() => _HourWidgetState();
}

class _HourWidgetState extends State<HourWidget> {
  final List<TimeOfDay> _hours = [
    const TimeOfDay(hour: 8, minute: 0),
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 13, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.paddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.arrivalTime.toCapitalizes(),
            style: textTheme.titleSmall.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: context.width,
            child: Wrap(
              spacing: 8,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              children: _hours.map((hour) {
                final isSelected = widget.selectedHour == hour;

                return InkWell(
                  onTap: () => widget.onHourSelected(
                    hour,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? colorScheme.primaryTonal : null,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.surfaceDim,
                      ),
                    ),
                    child: Text(
                      hour.format(context),
                      style: textTheme.bodyMedium.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
