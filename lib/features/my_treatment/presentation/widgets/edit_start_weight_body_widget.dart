import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/double_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';
import 'edit_weight_body_widget.dart';

class EditStartWeightBodyWidget extends StatefulWidget {
  final bool isStartDateSameAsToday;
  final bool? isAutoFocusStartWeight;
  final bool? isAutoFocusCurrentWeight;
  final double? currentStartWeight;
  final double? currentWeight;
  final Function(
    String? startWeight,
    String? currentWeight,
  ) onSave;

  const EditStartWeightBodyWidget({
    super.key,
    required this.isStartDateSameAsToday,
    this.isAutoFocusStartWeight,
    this.isAutoFocusCurrentWeight,
    required this.currentStartWeight,
    required this.currentWeight,
    required this.onSave,
  });

  @override
  State<EditStartWeightBodyWidget> createState() =>
      _EditStartWeightBodyWidgetState();
}

class _EditStartWeightBodyWidgetState extends State<EditStartWeightBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _startWeightTextController = TextEditingController();
  final _currentWeightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _startWeightTextController.text =
        widget.currentStartWeight?.parseToString() ?? "";
    _currentWeightTextController.text =
        widget.currentWeight?.parseToString() ?? "";
  }

  @override
  void dispose() {
    super.dispose();

    _currentWeightTextController.dispose();
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
              autofocus: widget.isAutoFocusStartWeight,
              readOnly: widget.isStartDateSameAsToday,
            ),
            const SizedBox(
              height: 20,
            ),
            WeightTextFormWidget(
              context: context,
              controller: _currentWeightTextController,
              title: context.locale.currentItem(
                context.locale.weight,
              ),
              isRequired: true,
              autofocus: widget.isAutoFocusCurrentWeight,
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

    final startWeight = _startWeightTextController.text;
    final currentWeight = _currentWeightTextController.text;

    String? newStartWeight;
    final activeStartWeight = widget.currentStartWeight?.parseToString();
    if (!startWeight.isSame(otherValue: activeStartWeight)) {
      newStartWeight = startWeight;
    }

    String? newCurrentWeight;
    final activeCurrentWeight = widget.currentWeight?.parseToString();
    if (!currentWeight.isSame(otherValue: activeCurrentWeight)) {
      newCurrentWeight = currentWeight;
    }

    if (widget.isStartDateSameAsToday) {
      // if start date is same as today, then new start weight is same as new current weight
      newStartWeight = newCurrentWeight;
    }

    widget.onSave(
      newStartWeight,
      newCurrentWeight,
    );
  }
}
