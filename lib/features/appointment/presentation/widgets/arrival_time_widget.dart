import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/time_of_day_extension.dart';
import '../../../../core/ui/theme/color_scheme.dart';
import '../../domain/entities/clinic_location_entity.dart';

class ArrivalTimeWidget extends StatefulWidget {
  final bool isToday;
  final ClinicLocationEntity? clinicLocation;
  final TimeOfDay? selectedHour;
  final Function(TimeOfDay) onHourSelected;

  const ArrivalTimeWidget({
    super.key,
    required this.isToday,
    required this.clinicLocation,
    required this.selectedHour,
    required this.onHourSelected,
  });

  @override
  State<ArrivalTimeWidget> createState() => _ArrivalTimeWidgetState();
}

class _ArrivalTimeWidgetState extends State<ArrivalTimeWidget> {
  final Map<TimeOfDay, bool> _hours = {};

  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    final clinicLocation = widget.clinicLocation;
    if (clinicLocation == null) {
      return;
    }

    openingTime = clinicLocation.openingTime;
    closingTime = clinicLocation.closingTime;
    if (openingTime == null && closingTime == null) {
      return;
    }

    for (var hour = openingTime!.hour; hour < closingTime!.hour; hour++) {
      // if hour is 12 AM, skip it
      if (hour == 0) {
        continue;
      }

      final newHour = TimeOfDay(
        hour: hour,
        minute: 0,
      );

      _hours[newHour] = true; // all hours are available by default
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    if (widget.isToday) {
      // update the available hours based on the current time
      final now = TimeOfDay.now();
      for (final entry in _hours.keys.toList()) {
        final newHour = TimeOfDay(
          hour: entry.hour,
          minute: 0,
        );

        bool isAvailable = true;
        if (newHour.isBefore(
          otherValue: now,
          intervalMinutes: 60,
        )) {
          isAvailable = false;
        }

        _hours[newHour] = isAvailable;
      }
    } else {
      // if the selected date is not today, all hours are available
      for (final entry in _hours.keys.toList()) {
        _hours[entry] = true;
      }
    }

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
              children: _hours.entries.map(
                (entry) {
                  final hour = entry.key;
                  final isSelected = widget.selectedHour == hour;
                  final isDisabled = !entry.value;

                  return InkWell(
                    onTap: () {
                      _onTap(
                        hour: hour,
                        isDisabled: isDisabled,
                        isSelected: isSelected,
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: backgroundColor(
                          colorScheme: colorScheme,
                          isSelected: isSelected,
                          isDisabled: isDisabled,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: borderColor(
                            colorScheme: colorScheme,
                            isSelected: isSelected,
                            isDisabled: isDisabled,
                          ),
                        ),
                      ),
                      child: Text(
                        hour.formatTime(),
                        style: textTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textColor(
                            colorScheme: colorScheme,
                            isSelected: isSelected,
                            isDisabled: isDisabled,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color backgroundColor({
    required AppColorScheme colorScheme,
    required bool isSelected,
    required bool isDisabled,
  }) {
    if (isSelected) {
      return colorScheme.primaryTonal;
    }

    if (isDisabled) {
      return colorScheme.surface;
    }

    return colorScheme.white;
  }

  Color borderColor({
    required AppColorScheme colorScheme,
    required bool isSelected,
    required bool isDisabled,
  }) {
    if (isSelected) {
      return colorScheme.primary;
    }

    if (isDisabled) {
      return colorScheme.surface;
    }

    return colorScheme.surfaceDim;
  }

  Color textColor({
    required AppColorScheme colorScheme,
    required bool isSelected,
    required bool isDisabled,
  }) {
    if (isSelected) {
      return colorScheme.primary;
    }

    if (isDisabled) {
      return colorScheme.onSurfaceBright;
    }

    return colorScheme.onSurface;
  }

  void _onTap({
    required TimeOfDay hour,
    required bool isDisabled,
    required bool isSelected,
  }) {
    if (isDisabled) {
      return;
    }

    if (isSelected) {
      return;
    }

    widget.onHourSelected(hour);
  }
}
