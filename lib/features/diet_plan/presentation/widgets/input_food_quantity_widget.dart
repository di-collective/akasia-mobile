import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/food_quantity_unit_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/forms/text_form_widget.dart';
import '../../domain/entities/food_entity.dart';

class InputFoodQuantityWidget extends StatefulWidget {
  final FoodEntity food;
  final Function() onCancel;
  final Future<void> Function(
    String quantity,
    String quantityUnit,
  ) onAdd;

  const InputFoodQuantityWidget({
    super.key,
    required this.food,
    required this.onCancel,
    required this.onAdd,
  });

  @override
  State<InputFoodQuantityWidget> createState() =>
      _InputFoodQuantityWidgetState();
}

class _InputFoodQuantityWidgetState extends State<InputFoodQuantityWidget> {
  final _formKey = GlobalKey<FormState>();
  final _quantityTextController = TextEditingController();

  FoodQuantityUnit? _selectedQuantityUnit;

  bool _isShowQuantityUnitPicker = false;

  @override
  void initState() {
    super.initState();

    _selectedQuantityUnit = FoodQuantityUnit.servings;
  }

  @override
  void dispose() {
    super.dispose();

    _quantityTextController.dispose();
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
            vertical: 19,
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
              GestureDetector(
                onTap: widget.onCancel,
                child: SizedBox(
                  width: 60,
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
                  widget.food.name?.toCapitalizes() ?? '',
                  maxLines: 1,
                  style: textTheme.titleMedium.copyWith(
                    color: colorScheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  widget.onAdd(
                    _quantityTextController.text,
                    _selectedQuantityUnit!.title(
                      context: context,
                    ),
                  );
                },
                child: SizedBox(
                  width: 60,
                  child: Text(
                    context.locale.add.toCapitalizes(),
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormWidget(
              controller: _quantityTextController,
              hintText: context.locale.inputItem(
                context.locale.quantity,
              ),
              autofocus: true,
              suffixText: _selectedQuantityUnit?.title(
                context: context,
              ),
              onTapSuffixText: _onChangeUnit,
              onTap: _onTapForm,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              validator: (_) {
                return _quantityTextController.validateOnlyNumber(
                  context: context,
                  isRequired: true,
                  minimumAmount: 1,
                );
              },
            ),
          ),
        ),
        if (_isShowQuantityUnitPicker) ...[
          const SizedBox(
            height: 24,
          ),
          const Divider(),
          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 60,
              scrollController: FixedExtentScrollController(
                initialItem: _selectedQuantityUnit!.index,
              ),
              selectionOverlay: Container(
                color: Colors.transparent,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedQuantityUnit = FoodQuantityUnit.values[index];
                });
              },
              children: FoodQuantityUnit.values.map((unit) {
                return Center(
                  child: Text(
                    unit.title(
                      context: context,
                    ),
                    style: textTheme.headlineSmall.copyWith(
                      color: colorScheme.onSurfaceDim,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        SizedBox(
          height: context.paddingBottom,
        ),
      ],
    );
  }

  void _onChangeUnit() {
    // hide keyboard
    context.closeKeyboard;

    if (_isShowQuantityUnitPicker) {
      return;
    }

    // set state to show quantity unit picker
    setState(() {
      _isShowQuantityUnitPicker = true;
    });
  }

  void _onTapForm() {
    if (!_isShowQuantityUnitPicker) {
      return;
    }

    // set state to hide quantity unit picker
    setState(() {
      _isShowQuantityUnitPicker = false;
    });
  }
}
