import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/sex_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/theme/theme.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dividers/title_divider_widget.dart';
import '../../../../core/ui/widget/dropdowns/activity_level_dropdown_widget.dart';
import '../../../../core/ui/widget/forms/date_form_widget.dart';
import '../../../../core/ui/widget/forms/height_text_form_widget.dart';
import '../../../../core/ui/widget/forms/weight_text_form_widget.dart';
import '../../../../core/ui/widget/radios/gender_radio_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../activity_level/domain/entities/activity_level_entity.dart';
import '../cubit/fill_personal_information/fill_personal_information_cubit.dart';
import '../widgets/finish_chart_widget.dart';

class FillPersonalInformationPage extends StatelessWidget {
  const FillPersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FillPersonalInformationCubit>(),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  int _currentPage = 0;

  late PageController _pageController;

  final _formKey = GlobalKey<FormState>();
  final _weightTextController = TextEditingController();
  final _weightGoalTextController = TextEditingController();
  final _dateOfBirthTextController = TextEditingController();
  DateTime? _selectedDateOfBirth;
  SexType? _selectedSex;
  final _heightTextController = TextEditingController();
  final _activityLevelTextController = TextEditingController();
  ActivityLevelEntity? _selectedActivityLevel;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _pageController = PageController(
      initialPage: _currentPage,
    );

    // listener
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.toInt() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
    _weightTextController.dispose();
    _weightGoalTextController.dispose();
    _dateOfBirthTextController.dispose();
    _heightTextController.dispose();
    _activityLevelTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.overlayStyleLight,
      child: GestureDetector(
        onTap: () => context.closeKeyboard,
        child: BlocBuilder<FillPersonalInformationCubit,
            FillPersonalInformationState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: colorScheme.surfaceContainerBright,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.paddingHorizontal,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: context.height * 0.07,
                                ),
                                Text(
                                  context.locale.personalInformation
                                      .toCapitalizes(),
                                  style: textTheme.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurfaceDim,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const TitleDividerWidget(),
                                const SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  "${context.locale.takeAGuessIfYouAreNotSure}."
                                      .toCapitalize(),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: textTheme.labelMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: colorScheme.primary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      children: [
                                        WeightTextFormWidget(
                                          context: context,
                                          controller: _weightTextController,
                                          title: context.locale.your(
                                            context.locale.weight,
                                          ),
                                          isRequired: true,
                                          onChanged: (_) {
                                            // reload
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        WeightTextFormWidget(
                                          context: context,
                                          controller: _weightGoalTextController,
                                          title: context.locale.weightGoal,
                                          isRequired: true,
                                          onChanged: (_) {
                                            // reload
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        DateFormWidget(
                                          controller:
                                              _dateOfBirthTextController,
                                          title: context.locale.dateOfBirth,
                                          hintText: context.locale.select(
                                            context.locale.date,
                                          ),
                                          isRequired: true,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          initialDate: _selectedDateOfBirth,
                                          onSelectedDate: (val) {
                                            if (val == null) {
                                              return;
                                            }
                                            if (val == _selectedDateOfBirth) {
                                              return;
                                            }

                                            final newDate = val.formatDate();
                                            if (newDate == null) {
                                              return;
                                            }

                                            setState(() {
                                              _dateOfBirthTextController.text =
                                                  newDate;
                                              _selectedDateOfBirth = val;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GenderRadioWidget(
                                          title: context.locale.gender,
                                          isRequired: true,
                                          groupValue: _selectedSex,
                                          onChanged: (val) {
                                            if (val != null &&
                                                val != _selectedSex) {
                                              setState(() {
                                                _selectedSex = val;
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        HeightTextFormWidget(
                                          context: context,
                                          controller: _heightTextController,
                                          title: context.locale.your(
                                            context.locale.height,
                                          ),
                                          isRequired: true,
                                          onChanged: (_) {
                                            // reload
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ActivityLevelDropdownWidget(
                                          context: context,
                                          title: context.locale.activityLevel,
                                          hintText: context.locale.choose,
                                          selectedValue: _selectedActivityLevel,
                                          isRequired: true,
                                          onChanged: (option) {
                                            if (option != null &&
                                                option !=
                                                    _selectedActivityLevel) {
                                              setState(() {
                                                _selectedActivityLevel = option;
                                              });
                                            }
                                          },
                                          validator: (val) {
                                            if (val == null) {
                                              return context
                                                  .locale.cannotBeEmpty;
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: context.height * 0.07,
                              ),
                              Text(
                                context.locale.wePredictThatYouWillBe
                                    .toCapitalizes(),
                                style: textTheme.bodyLarge.copyWith(
                                  color: colorScheme.onSurfaceDim,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${_weightGoalTextController.text}kg",
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    const TextSpan(text: " by "),
                                    TextSpan(
                                      text: "April 9",
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: textTheme.headlineLarge.copyWith(
                                  color: colorScheme.onSurfaceDim,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TitleDividerWidget(
                                color: colorScheme.onSurfaceDim,
                                width: 80,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Spacer(),
                              SizedBox(
                                height: context.height * 0.4,
                                child: const FinishChartWidget(),
                              ),
                              const Spacer(),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                context.locale.yourPlanIsReady.toCapitalizes(),
                                style: textTheme.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurfaceDim,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.paddingHorizontal,
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: context.locale
                                            .yourBudgetCalories("1.478"),
                                      ),
                                      const TextSpan(text: ". "),
                                      TextSpan(
                                        text: context.locale
                                            .ifYourConsistenlyEatAnAverage(
                                                "1.478"),
                                      ),
                                      const TextSpan(text: "."),
                                    ],
                                  ),
                                  maxLines: 5,
                                  textAlign: TextAlign.center,
                                  style: textTheme.labelLarge.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: context.paddingBottom,
                        left: context.paddingHorizontal,
                        right: context.paddingHorizontal,
                      ),
                      child: ButtonWidget(
                        text: _buttonText,
                        width: context.width,
                        isDisabled: _isDisabled,
                        isLoading: state is FillPersonalInformationLoading,
                        onTap: _onNext,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool get _isDisabled {
    if (_currentPage == 0) {
      return _formKey.currentState?.validate() != true;
    }

    return false;
  }

  String get _buttonText {
    if (_currentPage == 0) {
      return context.locale.next;
    }

    return context.locale.continues;
  }

  void _onNext() {
    if (_currentPage == 0) {
      _onNextPage();
    } else {
      _onContinue();
    }
  }

  Future<void> _onNextPage() async {
    try {
      // validate
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      // fill personal information
      await BlocProvider.of<FillPersonalInformationCubit>(context)
          .fillPersonalInformation();

      // redirect to success page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }

  void _onContinue() {
    // return true
    context.pop(true);
  }
}

class SalesData {
  SalesData(
    this.day,
    this.sales,
  );

  final double day;
  final double? sales;
}
