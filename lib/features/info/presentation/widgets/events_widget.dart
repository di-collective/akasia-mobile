import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'event_item_widget.dart';

class EventsWidget extends StatefulWidget {
  const EventsWidget({super.key});

  @override
  State<EventsWidget> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: context.paddingHorizontal,
          ),
          child: Text(
            context.locale.findVariousEventsAtAkasia365mc,
            style: textTheme.titleMedium.copyWith(
              color: colorScheme.onSurfaceDim,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? context.paddingHorizontal : 12,
                  right: index == 4 ? context.paddingHorizontal : 0,
                ),
                child: GestureDetector(
                  onTap: _onEvent,
                  child: const EventItemWidget(),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: _onSeeAllEvents,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.locale.seeAll.toCapitalizes(),
                style: textTheme.bodyMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              SvgPicture.asset(
                AssetIconsPath.icArrowRight,
                colorFilter: ColorFilter.mode(
                  colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onEvent() {
    // TODO: Implement this method
  }

  void _onSeeAllEvents() {
    // TODO: Implement this method
  }
}
