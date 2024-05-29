import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/asset_path.dart';
import 'text_form_field_widget.dart';

class DateFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final String? hintText;
  final Function(DateTime?) onSelectedDate;
  final bool? isRequired;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const DateFormFieldWidget({
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
    return TextFormFieldWidget(
      controller: controller,
      title: title,
      hintText: hintText,
      isRequired: isRequired,
      readOnly: true,
      backgroundColor: Colors.transparent,
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
      suffixIcon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetIconsPath.icCalendarOutlined,
            height: 16,
          ),
        ],
      ),
    );
  }
}
