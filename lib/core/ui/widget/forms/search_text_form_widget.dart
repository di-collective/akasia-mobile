import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/asset_path.dart';
import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import '../dialogs/debouncer_info.dart';
import 'text_form_field_widget.dart';

class SearchTextFormWidget extends TextFormFieldWidget {
  final BuildContext context;
  final bool? isDisableDebouncer;
  final Function()? onChangedText;

  SearchTextFormWidget({
    super.key,
    required this.context,
    super.controller,
    super.title,
    super.hintText,
    super.isRequired,
    super.onTap,
    super.validator,
    super.onClear,
    this.isDisableDebouncer,
    this.onChangedText,
  }) : super(
          suffixIcon: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: context.theme.appColorScheme.surfaceDim,
                ),
              ),
            ),
            child: SvgPicture.asset(
              AssetIconsPath.icSearch,
            ),
          ),
          onChanged: (value) {
            if (onChangedText == null) {
              return;
            }

            if (isDisableDebouncer == true) {
              onChangedText();

              return;
            }

            // debounce for 0.8 seconds
            final debouncer = DebouncerInfo(milliseconds: 800);

            debouncer.run(() {
              if (value == controller?.text) {
                // do handle change when bouncer value same with text controller
                onChangedText();
              }
            });
          },
        );
}
