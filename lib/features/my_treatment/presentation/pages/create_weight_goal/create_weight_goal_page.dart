import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../../core/ui/extensions/double_extension.dart';
import '../../../../../core/ui/extensions/object_extension.dart';
import '../../../../../core/ui/extensions/sex_extension.dart';
import '../../../../../core/ui/extensions/string_extension.dart';
import '../../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../../core/ui/extensions/weight_goal_activity_level_extension.dart';
import '../../../../../core/ui/extensions/weight_goal_pace_extension.dart';
import '../../../../../core/ui/theme/theme.dart';
import '../../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../../core/utils/service_locator.dart';
import '../../../../account/domain/entities/profile_entity.dart';
import '../../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../../../domain/entities/weight_goal_pacing_entity.dart';
import '../../cubit/simulation/simulation_cubit.dart';
import '../../cubit/weight_goal/weight_goal_cubit.dart';
import 'steps/fill_information_step_widget.dart';
import 'steps/finish_step_widget.dart';
import 'steps/select_pace_step_widget.dart';

class CreateWeightGoalPage extends StatelessWidget {
  const CreateWeightGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SimulationCubit>(),
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
  WeightGoalActivityLevel? _selectedActivityLevel;
  WeightGoalPace? _selectedPace;

  ProfileEntity? _activeProfile;

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

    //  set default value
    _initDefaultValue();
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
    final colorScheme = context.theme.appColorScheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        _onBack();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.overlayStyleLight,
        child: GestureDetector(
          onTap: () => context.closeKeyboard,
          child: Scaffold(
            backgroundColor: colorScheme.surfaceContainerBright,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        FillInformationStepWidget(
                          formKey: _formKey,
                          weightTextController: _weightTextController,
                          weightGoalTextController: _weightGoalTextController,
                          dateOfBirthTextController: _dateOfBirthTextController,
                          selectedDateOfBirth: _selectedDateOfBirth,
                          selectedSex: _selectedSex,
                          heightTextController: _heightTextController,
                          activityLevelTextController:
                              _activityLevelTextController,
                          selectedActivityLevel: _selectedActivityLevel,
                          selectedPace: _selectedPace,
                          onSelectedDateOfBirth: _onChangeDateOfBirth,
                          onSelectedSexType: _onSelectedGender,
                          onSelectedActivityLevel: _onSelectedActivityLevel,
                        ),
                        SelectPaceStepWidget(
                          selectedPace: _selectedPace,
                          onSelectedPace: _onSelectedPace,
                          onCreateWeightGoal: _onCreateWeightGoal,
                        ),
                        const FinishStepWidget(),
                      ],
                    ),
                  ),
                  _buildNextButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildNextButton {
    if (_currentPage == 1) {
      return const SizedBox.shrink();
    }

    String? buttonText;
    if (_currentPage == 0) {
      buttonText = context.locale.next;
    } else {
      buttonText = context.locale.continues;
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: context.paddingBottom,
        left: context.paddingHorizontal,
        right: context.paddingHorizontal,
      ),
      child: ButtonWidget(
        text: buttonText,
        width: context.width,
        isDisabled: _isDisabled,
        onTap: _onNext,
      ),
    );
  }

  void _initDefaultValue() {
    final profileState = BlocProvider.of<ProfileCubit>(context).state;
    if (profileState is! ProfileLoaded) {
      return;
    }

    _activeProfile = profileState.profile;
    if (_activeProfile == null) {
      return;
    }

    _weightTextController.text = _activeProfile?.weight?.parseToString() ?? "";
    _selectedDateOfBirth = _activeProfile?.dob?.toDateTime();
    _dateOfBirthTextController.text = _selectedDateOfBirth?.formatDate() ?? "";
    _selectedSex = SexTypeExtension.fromString(_activeProfile?.sex);
    _heightTextController.text = _activeProfile?.height?.parseToString() ?? "";
    _selectedActivityLevel = WeightGoalActivityLevelExtension.fromString(
      _activeProfile?.activityLevel,
    );
  }

  void _onBack() {
    switch (_currentPage) {
      case 0:
        context.pop(false);

        break;
      case 1:
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case 2:
        // close page
        context.pop(true);

        break;
    }
  }

  void _onChangeDateOfBirth(DateTime? value) {
    if (value == null) {
      return;
    }
    if (value == _selectedDateOfBirth) {
      return;
    }

    final newDate = value.formatDate();
    if (newDate == null) {
      return;
    }

    setState(() {
      _dateOfBirthTextController.text = newDate;
      _selectedDateOfBirth = value;
    });
  }

  void _onSelectedGender(SexType? value) {
    if (value != null && value != _selectedSex) {
      setState(() {
        _selectedSex = value;
      });
    }
  }

  void _onSelectedActivityLevel(WeightGoalActivityLevel? value) {
    if (value != null && value != _selectedActivityLevel) {
      setState(() {
        _selectedActivityLevel = value;
      });
    }
  }

  void _onSelectedPace(WeightGoalPacingEntity? value) {
    final pace = value?.pace;

    if (pace != null && pace != _selectedPace) {
      setState(() {
        _selectedPace = pace;
      });
    }
  }

  bool get _isDisabled {
    if (_currentPage == 0) {
      return _formKey.currentState?.validate() != true || _selectedSex == null;
    }

    return false;
  }

  void _onNext() {
    if (_currentPage == 0) {
      // validate form
      if (_formKey.currentState?.validate() != true || _selectedSex == null) {
        return;
      }

      _onGetSimulation();
    } else if (_currentPage == 1) {
      _onCreateWeightGoal();
    } else {
      _onContinue();
    }
  }

  Future<void> _onGetSimulation() async {
    try {
      // close keyboard
      context.closeKeyboard;

      // show full screen loading
      context.showFullScreenLoading();

      // get simulation
      await BlocProvider.of<SimulationCubit>(context).getSimulation(
        startingWeight: _weightTextController.text,
        targetWeight: _weightGoalTextController.text,
        activityLevel: _selectedActivityLevel,
      );

      // go page select weight goal
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }

  Future<void> _onCreateWeightGoal() async {
    try {
      // show full screen loading
      context.showFullScreenLoading();

      // create weight goal
      await BlocProvider.of<WeightGoalCubit>(context).createWeightGoal(
        activityLevel: _selectedActivityLevel,
        pace: _selectedPace,
        startingWeight: _weightTextController.text,
        targetWeight: _weightGoalTextController.text,
      );

      // update profile
      try {
        await _onUpdateProfile();
      } catch (error) {
        context.showErrorToast(
          message: error.message(context),
        );
      }

      // go to success page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }

  Future<void> _onUpdateProfile() async {
    try {
      ProfileEntity newProfile = const ProfileEntity();

      // new weight
      final newWeight = _weightTextController.text.parseToDouble;
      if (newWeight?.isSame(otherValue: _activeProfile?.weight) != true) {
        newProfile = newProfile.copyWith(
          weight: newWeight,
        );
      }

      // new dob
      final newDob = _selectedDateOfBirth?.formatDate(
        format: "yyyy-MM-dd",
      );
      final activeDob = _activeProfile?.dob?.formatDate(
        format: "yyyy-MM-dd",
      );
      if (newDob?.isSame(otherValue: activeDob) != true) {
        newProfile = newProfile.copyWith(
          dob: _selectedDateOfBirth?.toDateApi,
        );
      }

      // new gender
      final newSex = _selectedSex?.title(context: context);
      final activeSex = _activeProfile?.sex;
      if (newSex?.isSame(otherValue: activeSex) != true) {
        newProfile = newProfile.copyWith(
          sex: newSex,
        );
      }

      // new height
      final newHeight = _heightTextController.text.parseToDouble;
      if (newHeight?.isSame(otherValue: _activeProfile?.height) != true) {
        newProfile = newProfile.copyWith(
          height: newHeight,
        );
      }

      // new activity level
      final newActivityLevel = _selectedActivityLevel?.title;
      if (newActivityLevel?.isSame(otherValue: _activeProfile?.activityLevel) !=
          true) {
        newProfile = newProfile.copyWith(
          activityLevel: newActivityLevel,
        );
      }
      if (newProfile.isNull) {
        return;
      }

      // set user id
      newProfile = newProfile.copyWith(
        userId: _activeProfile?.userId,
      );

      // if profile data is changed, update profile data
      await BlocProvider.of<ProfileCubit>(context).updateProfile(
        newProfile: newProfile,
      );
    } catch (_) {
      rethrow;
    }
  }

  void _onContinue() {
    // return true
    context.pop(true);
  }
}
