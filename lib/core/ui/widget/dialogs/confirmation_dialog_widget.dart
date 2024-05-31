import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../buttons/button_widget.dart';
import 'dialog_widget.dart';

class ConfirmationDialogWidget extends StatelessWidget {
  final String? title, description, cancelText, confirmText;
  final Widget? descriptionWidget;
  final Color? confirmBackrgoundColor;
  final Function()? onCancel, onConfirm;

  const ConfirmationDialogWidget({
    super.key,
    this.title,
    this.description,
    this.descriptionWidget,
    this.cancelText,
    this.confirmText,
    this.confirmBackrgoundColor,
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return DialogWidget(
      title: title,
      description: description,
      descriptionWidget: descriptionWidget,
      button: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              text: cancelText ?? context.locale.no,
              borderColor: Colors.transparent,
              textColor: colorScheme.onSurfaceBright,
              backgroundColor: Colors.transparent,
              onTap: () {
                if (onCancel != null) {
                  onCancel!();

                  return;
                }

                Navigator.pop(context, false);
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: ButtonWidget(
              text: confirmText ?? context.locale.yes,
              backgroundColor: confirmBackrgoundColor,
              onTap: () {
                if (onConfirm != null) {
                  onConfirm!();

                  return;
                }

                Navigator.pop(context, true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
