import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import 'package:flutter/material.dart';

import '../../extensions/sex_extension.dart';
import 'radio_widget.dart';

class GenderRadioWidget extends StatelessWidget {
  final String? title;
  final bool? isRequired;
  final SexType? groupValue;
  final void Function(SexType?)? onChanged;

  const GenderRadioWidget({
    super.key,
    this.title,
    this.isRequired,
    this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text.rich(
            TextSpan(
              text: title,
              children: [
                if (isRequired == true)
                  TextSpan(
                    text: ' *',
                    style: textTheme.labelMedium.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
              ],
              style: textTheme.labelMedium,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
        Row(
          children: SexType.values.map(
            (sexType) {
              return RadioWidget<SexType>(
                title: sexType.title(context: context),
                value: sexType,
                groupValue: groupValue,
                onChanged: onChanged,
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
