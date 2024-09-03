import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';

class RadioWidget<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final String? title;
  final TextStyle? titleStyle;
  final int? maxLines;

  const RadioWidget({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.title,
    this.titleStyle,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          activeColor: colorScheme.primary,
          fillColor: MaterialStateProperty.resolveWith((states) {
            // active
            if (states.contains(MaterialState.selected)) {
              return colorScheme.primary;
            }

            // inactive
            return colorScheme.outlineDim;
          }),
          onChanged: onChanged,
        ),
        if (title != null && title!.isNotEmpty) ...[
          Text(
            title!,
            maxLines: maxLines,
            style: titleStyle ??
                textTheme.bodyLarge.copyWith(
                  color: colorScheme.onSurfaceDim,
                ),
          ),
        ],
      ],
    );
  }
}
