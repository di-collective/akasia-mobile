import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';
import 'edit_weight_body_widget.dart';

class EditStartWeightBodyWidget extends StatefulWidget {
  final Function(String value) onSave;

  const EditStartWeightBodyWidget({
    super.key,
    required this.onSave,
  });

  @override
  State<EditStartWeightBodyWidget> createState() =>
      _EditStartWeightBodyWidgetState();
}

class _EditStartWeightBodyWidgetState extends State<EditStartWeightBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _startWeightTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _startWeightTextController.dispose();
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
              controller: _startWeightTextController,
              title: context.locale.startItem(
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

    widget.onSave(_startWeightTextController.text);
  }
}
