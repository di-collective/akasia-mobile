import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/string_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../buttons/button_widget.dart';

class StateEmptyWidget extends StatelessWidget {
  final String? title, description, buttonText;
  final Function()? onTapButton;
  final double? imageWidth, imageHeight, paddingTop, width;

  const StateEmptyWidget({
    super.key,
    this.title,
    this.description,
    this.imageHeight = 120,
    this.imageWidth = 120,
    this.buttonText,
    this.onTapButton,
    this.paddingTop,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    String? title;
    if (this.title != null && this.title!.isNotEmpty) {
      title = this.title;
    }

    String? description;
    if (this.description != null && this.description!.isNotEmpty) {
      description = this.description;
    }
    description ??= context.locale.empty(
      context.locale.item,
    );

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
          // TODO: Add your empty state image here
          SizedBox(
            width: imageWidth,
            height: imageHeight,
          ),
          const SizedBox(
            height: 8,
          ),
          if (title != null && title.isNotEmpty) ...[
            Text(
              title.toCapitalizes(),
              style: textTheme.titleMedium.copyWith(
                color: colorScheme.onSurfaceDim,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 5,
            ),
            const SizedBox(
              height: 4,
            ),
          ],

          Text(
            description.toCapitalize(),
            style: textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 10,
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
