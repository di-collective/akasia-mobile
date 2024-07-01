import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/string_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../buttons/button_widget.dart';

class StateEmptyWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? buttonText;
  final Function()? onTapButton;
  final double? imageWidth;
  final double? imageHeight;

  const StateEmptyWidget({
    super.key,
    this.title,
    this.description,
    this.imageHeight = 120,
    this.imageWidth = 120,
    this.buttonText,
    this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TODO: Add your empty state image here
        SizedBox(
          width: imageWidth,
          height: imageHeight,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "${context.locale.empty(title ?? context.locale.item)}."
              .toCapitalize(),
          style: textTheme.labelMedium.copyWith(
            color: colorScheme.onSurfaceBright,
          ),
          textAlign: TextAlign.center,
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(
            height: 5,
          ),
          Text(
            description!.toCapitalize(),
            style: textTheme.labelMedium.copyWith(
              color: colorScheme.onSurfaceBright,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (buttonText != null && buttonText!.isNotEmpty) ...[
          const SizedBox(
            height: 20,
          ),
          ButtonWidget(
            text: buttonText,
            width: context.width * 0.6,
            onTap: onTapButton,
          ),
        ],
      ],
    );
  }
}
