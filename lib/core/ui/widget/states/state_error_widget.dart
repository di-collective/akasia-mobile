import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class StateErrorWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final double? paddingTop, width;

  const StateErrorWidget({
    super.key,
    this.title,
    this.description,
    this.paddingTop,
    this.width,
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
        ],
      ),
    );
  }
}
