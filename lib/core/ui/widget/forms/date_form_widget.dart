import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/asset_path.dart';
import '../../extensions/build_context_extension.dart';
import '../../extensions/theme_data_extension.dart';
import 'text_form_widget.dart';

class DateFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final String? hintText;
  final Function(DateTime?) onSelectedDate;
  final bool? isRequired;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const DateFormWidget({
    super.key,
    required this.controller,
    this.title,
    this.hintText,
    required this.onSelectedDate,
    this.isRequired,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return TextFormWidget(
      controller: controller,
      title: title,
      hintText: hintText,
      isRequired: isRequired,
      readOnly: true,
      backgroundColor: Colors.transparent,
      textColor: colorScheme.onSurface,
      onTap: () async {
        // open date picker
        final result = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
        );

        onSelectedDate(result);
      },
      suffixIcon: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 14,
        ),
        child: SvgPicture.asset(
          AssetIconsPath.icCalendarOutlined,
          height: 16,
        ),
      ),
    );
  }
}
