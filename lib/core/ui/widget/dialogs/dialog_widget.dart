import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class DialogWidget extends StatelessWidget {
  final String? title, description;
  final Widget? descriptionWidget, button;

  const DialogWidget({
    super.key,
    this.title,
    this.descriptionWidget,
    this.description,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.paddingHorizontal,
        vertical: 24,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null && title!.isNotEmpty) ...[
              Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium.copyWith(
                  color: colorScheme.onSurfaceDim,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (descriptionWidget != null) ...[
              const SizedBox(
                height: 20,
              ),
              descriptionWidget!,
            ] else if (description != null && description!.isNotEmpty) ...[
              const SizedBox(
                height: 20,
              ),
              Text(
                description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelLarge.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
            if (button != null) ...[
              const SizedBox(
                height: 24,
              ),
              button!,
            ],
          ],
        ),
      ),
    );
  }
}
