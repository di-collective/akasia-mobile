import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';
import 'edit_weight_body_widget.dart';

class EditTargetWeightBodyWidget extends StatefulWidget {
  final double? currentTargetWeight;
  final Function(String value) onSave;

  const EditTargetWeightBodyWidget({
    super.key,
    required this.currentTargetWeight,
    required this.onSave,
  });

  @override
  State<EditTargetWeightBodyWidget> createState() =>
      _EditTargetWeightBodyWidgetState();
}

class _EditTargetWeightBodyWidgetState
    extends State<EditTargetWeightBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _targetWeightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _targetWeightTextController.text =
        widget.currentTargetWeight?.parseToString() ?? "";
  }

  @override
  void dispose() {
    super.dispose();

    _targetWeightTextController.dispose();
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
              controller: _targetWeightTextController,
              title: context.locale.goalItem(
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

    widget.onSave(_targetWeightTextController.text);
  }
}
