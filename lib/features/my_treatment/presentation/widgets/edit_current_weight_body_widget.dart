import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';
import 'edit_weight_body_widget.dart';

class EditCurrentWeightBodyWidget extends StatefulWidget {
  final double? currentWeight;

  final Function(String value) onSave;

  const EditCurrentWeightBodyWidget({
    super.key,
    required this.currentWeight,
    required this.onSave,
  });

  @override
  State<EditCurrentWeightBodyWidget> createState() =>
      _EditCurrentWeightBodyWidgetState();
}

class _EditCurrentWeightBodyWidgetState
    extends State<EditCurrentWeightBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _currentWeightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    if (widget.currentWeight != null) {
      _currentWeightTextController.text =
          widget.currentWeight?.parseToString() ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();

    _currentWeightTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditWeightBodyWidget(
      title: context.locale
          .editItem(
            context.locale.value,
          )
          .toCapitalizes(),
      onCancel: () {
        Navigator.of(context).pop();
      },
      onSave: _onSave,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            WeightTextFormWidget(
              context: context,
              controller: _currentWeightTextController,
              title: context.locale.currentItem(
                context.locale.weight,
              ),
              isRequired: true,
              autofocus: true,
              onEditingComplete: _onSave,
            ),
          ],
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    widget.onSave(_currentWeightTextController.text);
  }
}
