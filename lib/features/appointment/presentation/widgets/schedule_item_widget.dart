import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/color_swatch_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';

class ScheduleItemWidget extends StatelessWidget {
  final int index;
  final bool isDisabled;
  final Function() onTap;

  const ScheduleItemWidget({
    super.key,
    required this.index,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 68,
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? colorScheme.primary
                      : colorScheme.vividTangelo.tint90,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outlineBright,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description (ex: After Care, LAMS, Consultation)",
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
                        "dr. Kuswan Ambar Pamungkas, Sp.B.P.R.E, Subsp.K.M.(K)",
                        style: textTheme.bodyMedium.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "7-Feb-2024",
                            style: textTheme.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceBright,
                            ),
                          ),
                          Text(
                            "09:41",
                            style: textTheme.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceBright,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isDisabled)
            Positioned.fill(
              child: Container(
                color: colorScheme.white.withOpacity(0.4),
              ),
            ),
        ],
      ),
    );
  }
}
