import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'date_information_item_widget.dart';

class CalendarInformationWidget extends StatefulWidget {
  const CalendarInformationWidget({super.key});

  @override
  State<CalendarInformationWidget> createState() =>
      _CalendarInformationWidgetState();
}

class _CalendarInformationWidgetState extends State<CalendarInformationWidget> {
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
            context.locale.information,
            style: textTheme.titleSmall.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateInformationItemWidget(
                      title: context.locale.quotasAvailable,
                      dotBackgroundColor: colorScheme.success,
                    ),
                    DateInformationItemWidget(
                      title: context.locale.selectedDate,
                      dotBackgroundColor: colorScheme.surfaceContainer,
                      dotBorderColor: colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DateInformationItemWidget(
                      title: context.locale.fullQuota,
                      dotBackgroundColor: colorScheme.error,
                    ),
                    DateInformationItemWidget(
                      title: context.locale.quotasNotOpened,
                      dotBorderColor: colorScheme.onSurfaceBright,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
