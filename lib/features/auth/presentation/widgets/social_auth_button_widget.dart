import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';

class AuthTypeButtonWidget extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isLoading;
  final Function() onTap;

  const AuthTypeButtonWidget({
    super.key,
    required this.label,
    required this.iconPath,
    required this.isLoading,
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
      isLoading: isLoading,
      textColor: colorScheme.onSurface,
      padding: const EdgeInsets.symmetric(
        vertical: 11,
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
