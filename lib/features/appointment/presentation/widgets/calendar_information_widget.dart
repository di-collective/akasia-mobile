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
                child: DateInformationItemWidget(
                  title: context.locale.available,
                  dotBackgroundColor: colorScheme.white,
                  dotBorderColor: colorScheme.outline,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: DateInformationItemWidget(
                  title: context.locale.notAvailable,
                  dotBackgroundColor: colorScheme.surface,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
