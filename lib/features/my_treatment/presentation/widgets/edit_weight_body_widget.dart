import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';

class EditWeightBodyWidget extends StatelessWidget {
  final String title;
  final Function() onCancel;
  final Function() onSave;
  final Widget child;

  const EditWeightBodyWidget({
    super.key,
    required this.title,
    required this.onCancel,
    required this.onSave,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: context.paddingHorizontal,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              ButtonWidget(
                onTap: onCancel,
                height: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                child: SizedBox(
                  width: 50,
                  child: Text(
                    context.locale.cancel.toCapitalize(),
                    style: textTheme.labelLarge.copyWith(
                      color: colorScheme.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  style: textTheme.titleMedium.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ButtonWidget(
                height: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                onTap: onSave,
                child: SizedBox(
                  width: 50,
                  child: Text(
                    context.locale.save.toCapitalizes(),
                    style: textTheme.labelLarge.copyWith(
                      color: colorScheme.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.paddingHorizontal,
          ),
          child: child,
        ),
        SizedBox(
          height: context.paddingBottom,
        ),
      ],
    );
  }
}
