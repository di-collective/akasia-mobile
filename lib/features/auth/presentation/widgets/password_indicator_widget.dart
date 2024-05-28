import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/password_indicator_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class PasswordIndicatorWidget extends StatelessWidget {
  final PasswordIndicator? indicator;

  const PasswordIndicatorWidget({
    super.key,
    this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            PasswordIndicator.values.length,
            (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  width: context.width,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: (indicator != null && index <= indicator!.index)
                        ? indicator!.color(
                            context: context,
                          )
                        : colorScheme.outlineBright,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        if (indicator != null) ...[
          Center(
            child: Text(
              indicator!.title(
                context: context,
              ),
              style: textTheme.bodySmall.copyWith(
                color: indicator!.color(
                  context: context,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
