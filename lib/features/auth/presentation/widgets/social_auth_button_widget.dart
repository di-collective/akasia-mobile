import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';

class SocialAuthButtonWidget extends StatelessWidget {
  final String label;
  final String iconPath;
  final Function() onTap;

  const SocialAuthButtonWidget({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return ButtonWidget(
      width: context.width,
      backgroundColor: Colors.transparent,
      borderColor: colorScheme.surfaceDim,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 18,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            label,
            style: textTheme.bodyLarge.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
