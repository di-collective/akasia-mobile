import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/chips/choice_chip_widget.dart';
import '../../../../core/ui/widget/dialogs/confirmation_dialog_widget.dart';
import '../widgets/total_rating_section.dart';

class WriteReviewPageArgs {
  final String reviewId;
  final int effectivenessRating, valueForMoneyRating;

  const WriteReviewPageArgs({
    required this.reviewId,
    required this.effectivenessRating,
    required this.valueForMoneyRating,
  });
}

class WriteReviewPage<T> extends StatefulWidget {
  final T? args;

  const WriteReviewPage({
    super.key,
    this.args,
  });

  @override
  State<StatefulWidget> createState() => _PageState();
}

class _PageState extends State<WriteReviewPage> {
  String? _reviewId;
  String _writtenReview = "";
  int? _effectivenessRating, _valueForMoneyRating;
  String? _selectedTreatmentPeriod, _selectedRecommends, _selectedWillRepurchase;
  static const _treatmentPeriodChoices = [
    'Less Than 1 Week',
    '1 Week - 1 Month',
    '1 - 3 Months',
    '3 - 6 Months',
    '6 Months - 1 Year',
    'More than 1 Year',
  ];

  static final _recommendsChoices = <String, String>{
    'Yes Absolutely!': AssetIconsPath.icSmiley,
    'No': AssetIconsPath.icSmileySad,
  };

  static final _willRepurchaseChoices = <String, String>{
    'Yes': AssetIconsPath.icSmiley,
    'No': AssetIconsPath.icSmileySad,
    'Maybe': AssetIconsPath.icSmileyFlat,
  };

  @override
  void initState() {
    super.initState();
    final args = widget.args;
    if (args is WriteReviewPageArgs) {
      setState(() {
        _reviewId = args.reviewId;
        _effectivenessRating = args.effectivenessRating;
        _valueForMoneyRating = args.valueForMoneyRating;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColorScheme;
    final textTheme = context.theme.appTextTheme;
    final locale = context.locale;
    return GestureDetector(
      onTap: () {
        context.closeKeyboard;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(context.locale.writeReview),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        color: colors.surfaceContainerBright,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: TotalRatingSection(
                          totalRating: _totalRating,
                        ),
                      ),
                      _WriteReviewItemLabelWrapper(
                        label: locale.writeAReview,
                        content: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: locale.tellUsAboutYourExperienceAfterThisTreatment,
                              hintStyle: textTheme.labelMedium.copyWith(
                                color: colors.onSurfaceBright,
                              ),
                            ),
                            maxLines: 10,
                            minLines: 1,
                            style: textTheme.labelMedium.copyWith(
                              color: colors.onSurface,
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: _onUpdateWrittenReview,
                            autocorrect: false,
                          ),
                        ),
                      ),
                      _WriteReviewItemLabelWrapper(
                        label: locale.howLongHaveYouHadThisTreatment,
                        content: _WriteReviewItemChoiceWrapper(
                          contents: _treatmentPeriodChoices
                              .map(
                                (label) => _WriteReviewChoiceChip(
                                  label: label,
                                  onTap: () => _onSelectTreatmentPeriod(label),
                                  isSelected: _selectedTreatmentPeriod == label,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      _WriteReviewItemLabelWrapper(
                        label: locale.willYouRecommendThisTreatment,
                        content: _WriteReviewItemChoiceWrapper(
                          contents: _recommendsChoices.toList().map((e) {
                            final label = e.first;
                            final iconAssetPath = e.second;
                            return _WriteReviewChoiceChip(
                              label: label,
                              isSelected: label == _selectedRecommends,
                              iconAssetPath: iconAssetPath,
                              onTap: () => _onSelectRecommends(label),
                            );
                          }).toList(),
                        ),
                      ),
                      _WriteReviewItemLabelWrapper(
                        label: locale.willYouRepurchaseThisTreatment,
                        content: _WriteReviewItemChoiceWrapper(
                          contents: _willRepurchaseChoices.toList().map((e) {
                            final label = e.first;
                            final iconAssetPath = e.second;
                            return _WriteReviewChoiceChip(
                              label: label,
                              isSelected: label == _selectedWillRepurchase,
                              iconAssetPath: iconAssetPath,
                              onTap: () => _onSelectWillRepurchase(label),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ) +
              EdgeInsets.only(
                bottom: context.mediaQuery.padding.bottom,
              ),
          child: ButtonWidget(
            text: context.locale.submit,
            isDisabled: !_isFormReady,
            onTap: () => _onSubmit(),
          ),
        ),
      ),
    );
  }

  void _onSelectTreatmentPeriod(String value) {
    setState(() {
      _selectedTreatmentPeriod = value;
    });
  }

  void _onSelectRecommends(String value) {
    setState(() {
      _selectedRecommends = value;
    });
  }

  void _onSelectWillRepurchase(String value) {
    setState(() {
      _selectedWillRepurchase = value;
    });
  }

  void _onUpdateWrittenReview(String value) {
    setState(() {
      _writtenReview = value;
    });
  }

  void _onSubmit() async {
    final locale = context.locale;
    final shouldSubmit = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialogWidget(
        title: locale.attention,
        description: locale.letsGiveItAFinalCheck,
        confirmText: locale.submit,
        cancelText: locale.cancel,
      ),
    );

    if (!shouldSubmit) return;

    //todo: submit review
  }

  double get _totalRating {
    return ((_effectivenessRating ?? 0).toDouble() + (_valueForMoneyRating ?? 0).toDouble()) / 2;
  }

  bool get _isFormReady {
    final isReviewFilled = _writtenReview.isNotEmpty;
    final isTreatmentPeriodSelected = _selectedTreatmentPeriod != null;
    final isRecommendsSelected = _selectedRecommends != null;
    final isWillRepurchaseSelected = _selectedWillRepurchase != null;
    return isReviewFilled &&
        isTreatmentPeriodSelected &&
        isRecommendsSelected &&
        isWillRepurchaseSelected;
  }
}

class _WriteReviewItemLabelWrapper extends StatelessWidget {
  final String label;
  final Widget content;

  const _WriteReviewItemLabelWrapper({
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            label,
            style: textTheme.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        content,
        Padding(
          padding: const EdgeInsets.all(16),
          child: Divider(
            height: 0,
            color: colorScheme.outlineBright,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _WriteReviewItemChoiceWrapper extends StatelessWidget {
  final List<_WriteReviewChoiceChip> contents;

  const _WriteReviewItemChoiceWrapper({
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 12,
        children: contents,
      ),
    );
  }
}

class _WriteReviewChoiceChip extends StatelessWidget {
  final String label;
  final String? iconAssetPath;
  final bool isSelected;
  final Function() onTap;

  const _WriteReviewChoiceChip({
    required this.label,
    this.iconAssetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leadingIconAssetPath = iconAssetPath;
    final colors = context.theme.appColorScheme;
    final selectedIconColor = isSelected ? colors.primary : colors.onSurface;
    return ChoiceChipWidget(
      label: label,
      labelStyle: context.theme.appTextTheme.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: context.theme.appColorScheme.onSurface,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      isSelected: isSelected,
      onTap: onTap,
      leadingIcon: leadingIconAssetPath != null
          ? SvgPicture.asset(
              leadingIconAssetPath,
              colorFilter: ColorFilter.mode(
                selectedIconColor,
                BlendMode.srcIn,
              ),
            )
          : null,
    );
  }
}
