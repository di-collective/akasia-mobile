import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dialogs/confirmation_dialog_widget.dart';
import '../../../../core/ui/widget/forms/text_form_widget.dart';

class RecordWeightBodyWidget extends StatefulWidget {
  final Function() onCancel;
  final Future<void> Function(
    String value,
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
              GestureDetector(
                onTap: widget.onCancel,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _onDecreaseDate,
                      icon: SvgPicture.asset(
                        AssetIconsPath.icChevronLeft,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _onDate,
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
                    IconButton(
                      onPressed: _onIncreaseDate,
                      icon: SvgPicture.asset(
                        AssetIconsPath.icChevronRight,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
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

                  widget.onSave(
                    _weightTextController.text,
                  );
                },
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
                child: TextFormWidget(
                  controller: _weightTextController,
                  autofocus: true,
                  suffixText: "kgs",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                  ),
                  validator: (_) {
                    return _weightTextController.validateOnlyNumber(
                      context: context,
                      isRequired: true,
                      minimumAmount: 1,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              ButtonWidget(
                text: context.locale.deleteItem(
                  context.locale.weight,
                ),
                width: context.width,
                textColor: colorScheme.primary,
                backgroundColor: colorScheme.primaryTonal,
                onTap: _onDeleteWeight,
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

  void _onDecreaseDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(
        const Duration(days: 1),
      );
    });
  }

  Future<void> _onDate() async {
    try {
      final currentDate = DateTime.now();
      final result = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: currentDate.addDays(-365), // TODO: Change this from API
        lastDate: currentDate.addDays(365), // TODO: Change this from API
      );
      if (result == null || result == _selectedDate) {
        return;
      }

      setState(() {
        _selectedDate = result;
      });
    } catch (error) {
      context.showWarningToast(
        message: error.message(context),
      );
    }
  }

  void _onIncreaseDate() {
    setState(() {
      _selectedDate = _selectedDate.add(
        const Duration(days: 1),
      );
    });
  }

  Future<void> _onDeleteWeight() async {
    try {
      // show confirmation dialog
      final isConfirm = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return ConfirmationDialogWidget(
            title: context.locale.deleteItem(
              context.locale.weight,
            ),
            description: context.locale.deleteWeightConfirmation,
            confirmText: context.locale.delete,
            cancelText: context.locale.cancel,
          );
        },
      );
      if (isConfirm != true) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      // show full screen loading
      context.showFullScreenLoading();

      // TODO: Implement delete weight
      await Future.delayed(
        const Duration(seconds: 1),
      );

      // show success toast
      context.showSuccessToast(
        message: context.locale.successItem(
          context.locale.deleteItem(
            context.locale.weight,
          ),
        ),
      );

      // close dialog
      widget.onCancel();
    } catch (error) {
      context.showWarningToast(
        message: error.message(context),
      );
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }
}
