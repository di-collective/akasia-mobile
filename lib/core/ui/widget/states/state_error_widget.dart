import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../buttons/button_widget.dart';

class StateErrorWidget extends StatelessWidget {
  final String? title, description, buttonText;
  final Function()? onTapButton;
  final double? paddingTop, width;

  const StateErrorWidget({
    super.key,
    this.title,
    this.description,
    this.paddingTop,
    this.width,
    this.buttonText,
    this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (paddingTop != null) ...[
            SizedBox(
              height: paddingTop,
            ),
          ],
          Text(
            "?",
            style: textTheme.headlineLarge.copyWith(
              fontSize: 50,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${title ?? context.locale.somethingWentWrong}!',
            style: textTheme.titleMedium.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '${description ?? context.locale.pleaseTryAgainLater}!',
            style: textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurfaceDim,
            ),
            textAlign: TextAlign.center,
          ),
          if (buttonText != null && buttonText!.isNotEmpty) ...[
            const SizedBox(
              height: 20,
            ),
            ButtonWidget(
              text: buttonText,
              width: context.width * 0.6,
              onTap: onTapButton,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
