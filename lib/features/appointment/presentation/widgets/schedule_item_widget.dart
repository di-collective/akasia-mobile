import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/color_swatch_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/event_status_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../domain/entities/appointment_entity.dart';

class ScheduleItemWidget extends StatefulWidget {
  final AppointmentEntity appointment;

  const ScheduleItemWidget({
    super.key,
    required this.appointment,
  });

  @override
  State<ScheduleItemWidget> createState() => _ScheduleItemWidgetState();
}

class _ScheduleItemWidgetState extends State<ScheduleItemWidget> {
  bool? isDisabled;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    isDisabled = widget.appointment.status != EventStatus.scheduled;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    final clinic = widget.appointment.clinic;
    final location = widget.appointment.location;
    final startTime = widget.appointment.startTime;
    String? formattedStartHour;
    String? formattedStartDate;
    if (startTime != null) {
      final startDate = startTime.toDateTime();

      formattedStartHour = startDate?.hourMinute;
      formattedStartDate = startDate?.formatDate(
        format: 'dd MMM yyyy',
      );
    }

    return Stack(
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 74,
              decoration: BoxDecoration(
                color: isDisabled == true
                    ? colorScheme.vividTangelo.tint90
                    : colorScheme.primary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale.consultation.toCapitalize(),
                    style: textTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurfaceDim,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    clinic?.toCapitalize() ?? '',
                    maxLines: 3,
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    location?.toCapitalize() ?? '',
                    maxLines: 3,
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        "${formattedStartHour ?? ''} • ",
                        maxLines: 2,
                        style: textTheme.bodyMedium.copyWith(
                          color: colorScheme.onSurfaceBright,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          formattedStartDate ?? '',
                          maxLines: 2,
                          style: textTheme.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceBright,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isDisabled == true)
          Positioned.fill(
            child: Container(
              color: colorScheme.white.withOpacity(0.4),
            ),
          ),
      ],
    );
  }
}
