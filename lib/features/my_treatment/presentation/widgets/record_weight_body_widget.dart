import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';

class RecordWeightBodyWidget extends StatefulWidget {
  final Function() onCancel;
  final Future<void> Function(
    String value,
    DateTime date,
  ) onSave;

  const RecordWeightBodyWidget({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<RecordWeightBodyWidget> createState() => _RecordWeightBodyWidgetState();
}

class _RecordWeightBodyWidgetState extends State<RecordWeightBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _weightTextController = TextEditingController();

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();

    _weightTextController.dispose();
  }

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
                onTap: widget.onCancel,
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
                  _formattedDate,
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
                onTap: _onSave,
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
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: WeightTextFormWidget(
                  context: context,
                  controller: _weightTextController,
                  isRequired: true,
                  autofocus: true,
                  onEditingComplete: _onSave,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.paddingBottom,
        ),
      ],
    );
  }

  String get _formattedDate {
    final result = _selectedDate.formatDate(
      format: 'EEE, dd MMM',
    );

    return result ?? '';
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onSave(
      _weightTextController.text,
      _selectedDate,
    );
  }
}
