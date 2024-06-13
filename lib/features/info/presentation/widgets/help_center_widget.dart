import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import 'help_center_item_widget.dart';

class HelpCenterWidget extends StatefulWidget {
  const HelpCenterWidget({super.key});

  @override
  State<HelpCenterWidget> createState() => _HelpCenterWidgetState();
}

class _HelpCenterWidgetState extends State<HelpCenterWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.locale.helpCenter,
                style: textTheme.titleMedium.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: _onViewAllHelpCenter,
                child: Text(
                  context.locale.seeAll,
                  style: textTheme.labelLarge.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 147,
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? context.paddingHorizontal : 12,
                  right: index == 4 ? context.paddingHorizontal : 0,
                ),
                child: GestureDetector(
                  onTap: _onHelpCenter,
                  child: const HelpCenterItemWidget(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onViewAllHelpCenter() {
    // TODO: Implement this method
  }

  void _onHelpCenter() {
    // TODO: Implement this method
  }
}
