import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';

class RecordWeightBodyWidget extends StatefulWidget {
  final Function() onCancel;
  final DateTime startDate;
  final DateTime endDate;
  final Future<void> Function(
    String value,
    DateTime date,
  ) onSave;

  const RecordWeightBodyWidget({
    super.key,
    required this.onCancel,
    required this.startDate,
    required this.endDate,
    required this.onSave,
  });

  @override
  State<RecordWeightBodyWidget> createState() => _RecordWeightBodyWidgetState();
}

class _RecordWeightBodyWidgetState extends State<RecordWeightBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _weightTextController = TextEditingController();

  late DateTime _nowDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _nowDate = DateTime.now();
    _selectedDate = _nowDate;
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
                          _isDisabledDecreaseDate
                              ? colorScheme.onPrimary.withOpacity(0.4)
                              : colorScheme.onPrimary,
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
                          _isDisabledIncreaseDate
                              ? colorScheme.onPrimary.withOpacity(0.4)
                              : colorScheme.onPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
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

  bool get _isDisabledDecreaseDate {
    return _selectedDate.isSame(
      other: widget.startDate,
      withoutHour: true,
      withoutMinute: true,
      withoutSecond: true,
    );
  }

  void _onDecreaseDate() {
    if (_isDisabledDecreaseDate) {
      return;
    }

    setState(() {
      _selectedDate = _selectedDate.subtract(
        const Duration(days: 1),
      );
    });
  }

  Future<void> _onDate() async {
    try {
      final result = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: widget.startDate,
        lastDate: _nowDate,
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

  bool get _isDisabledIncreaseDate {
    return _selectedDate.isSame(
      other: _nowDate,
      withoutHour: true,
      withoutMinute: true,
      withoutSecond: true,
    );
  }

  void _onIncreaseDate() {
    if (_isDisabledIncreaseDate) {
      return;
    }

    setState(() {
      _selectedDate = _selectedDate.add(
        const Duration(days: 1),
      );
    });
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
