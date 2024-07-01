import 'package:akasia365mc/features/appointment/presentation/widgets/calendar_information_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/widget/buttons/bottom_sheet_button_widget.dart';
import '../../../../core/ui/widget/dialogs/toast_info.dart';
import '../../../../core/ui/widget/dropdowns/string_dropdown_widget.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/entities/clinic_location_entity.dart';
import '../cubit/clinic_locations/clinic_locations_cubit.dart';
import '../cubit/clinics/clinics_cubit.dart';
import '../cubit/create_appointment/create_appointment_cubit.dart';
import '../widgets/clinic_location_item_widget.dart';
import '../widgets/clinic_locations_loading_widget.dart';
import '../widgets/date_picker_widget.dart';

enum CreateAppointmentStep {
  chooseClinic,
  selectDate,
}

class CreateAppointmentPage extends StatelessWidget {
  const CreateAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CreateAppointmentCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ClinicsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ClinicLocationsCubit>(),
        ),
      ],
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
  late PageController _pageController;
  late CreateAppointmentStep _currentStep;

  ClinicEntity? _selectedClinic;
  ClinicLocationEntity? _selectedClinicLocation;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    _pageController = PageController(
      initialPage: 0,
    );

    // listener
    _pageController.addListener(() {
      setState(() {
        _currentStep =
            CreateAppointmentStep.values[_pageController.page?.toInt() ?? 0];
      });
    });

    _currentStep = CreateAppointmentStep.chooseClinic;

    final clinicsState = BlocProvider.of<ClinicsCubit>(context).state;
    if (clinicsState is! ClinicsLoaded) {
      _onGetClinics();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  Future<void> _onGetClinics() async {
    await BlocProvider.of<ClinicsCubit>(context).getClinics();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        _onBack();
      },
      child: GestureDetector(
        onTap: () => context.closeKeyboard,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              context.locale.appointment,
              style: TextStyle(
                color: colorScheme.onSurfaceDim,
              ),
            ),
            backgroundColor: colorScheme.white,
            iconTheme: IconThemeData(
              color: colorScheme.primary,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.paddingHorizontal,
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<ClinicsCubit, ClinicsState>(
                            builder: (context, state) {
                              List<ClinicEntity> clinics = [];
                              if (state is ClinicsLoaded) {
                                clinics = state.clinics;
                              }

                              return StringDropdownWidget(
                                options: clinics.map((clinic) {
                                  return clinic.name ?? '';
                                }).toList(),
                                title: context.locale.chooseItem(
                                  context.locale.clinic,
                                ),
                                titleTextStyle: textTheme.titleMedium.copyWith(
                                  color: colorScheme.onSurfaceDim,
                                  fontWeight: FontWeight.w700,
                                ),
                                hintText: context.locale.choose,
                                isLoading: state is ClinicsLoading,
                                isDisabled: state is ClinicsError,
                                selectedValue: _selectedClinic?.name,
                                onChanged: (selectedValue) {
                                  _onChangedClinic(
                                    selectedValue: selectedValue,
                                    clinics: clinics,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Expanded(
                            child: BlocBuilder<ClinicLocationsCubit,
                                ClinicLocationsState>(
                              builder: (context, state) {
                                if (state is ClinicLocationsInitial) {
                                  return const SizedBox.shrink();
                                }

                                if (state is ClinicLocationsLoaded) {
                                  if (state.clinicLocations.isEmpty) {
                                    return const StateEmptyWidget();
                                  }

                                  return Column(
                                    children: [
                                      const Divider(),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      SvgPicture.asset(
                                        AssetImagesPath.logoTextColored,
                                        height: 24,
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Expanded(
                                        child: ListView.separated(
                                          itemCount:
                                              state.clinicLocations.length,
                                          shrinkWrap: true,
                                          primary: false,
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(
                                              height: 12,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            final clinicLocation =
                                                state.clinicLocations[index];

                                            return ClinicLocationItemWidget(
                                              clinicLocation: clinicLocation,
                                              isSelected:
                                                  _selectedClinicLocation ==
                                                      clinicLocation,
                                              onTap: () {
                                                if (_selectedClinicLocation ==
                                                    clinicLocation) {
                                                  return;
                                                }

                                                setState(() {
                                                  _selectedClinicLocation =
                                                      clinicLocation;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (state is ClinicLocationsError) {
                                  return StateErrorWidget(
                                    description: state.error.message(context),
                                  );
                                }

                                return const ClinicLocationsLoadingWidget();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: DatePickerWidget(
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime.now().addDays(300),
                              currentDate: _selectedDate,
                              onDateSelected: (value) {
                                _onDateChanged(
                                  value: value,
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const CalendarInformationWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BottomSheetButtonWidget(
                text: context.locale.next,
                isDisabled: _isDisabled,
                width: context.width,
                onTap: _onNext,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isDisabled {
    switch (_currentStep) {
      case CreateAppointmentStep.chooseClinic:
        if (_selectedClinic == null || _selectedClinicLocation == null) {
          return true;
        }
        break;
      case CreateAppointmentStep.selectDate:
        if (_selectedDate == null || _selectedTime == null) {
          return true;
        }

        break;
    }

    return false;
  }

  Future<void> _onChangedClinic({
    required String? selectedValue,
    required List<ClinicEntity> clinics,
  }) async {
    try {
      final selectedClinic = clinics.firstWhereOrNull(
        (clinic) => clinic.name == selectedValue,
      );
      if (selectedClinic == null || _selectedClinic == selectedClinic) {
        return;
      }

      // set state
      setState(() {
        _selectedClinicLocation = null;
      });

      // get clinic locations
      await BlocProvider.of<ClinicLocationsCubit>(context).getClinicLocations(
        clinicId: selectedClinic.id,
      );

      // set state
      setState(() {
        _selectedClinic = selectedClinic;
      });
    } catch (error) {
      sl<ToastInfo>().show(
        type: ToastType.error,
        message: error.message(context),
        context: context,
      );
    }
  }

  void _onBack() {
    switch (_currentStep) {
      case CreateAppointmentStep.chooseClinic:
        context.pop();
        break;
      case CreateAppointmentStep.selectDate:
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
    }
  }

  Future<void> _onNext() async {
    switch (_currentStep) {
      case CreateAppointmentStep.chooseClinic:
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        break;
      case CreateAppointmentStep.selectDate:
        _onSave();

        break;
    }
  }

  Future<void> _onDateChanged({
    required DateTime? value,
  }) async {
    try {
      setState(() {
        _selectedDate = value;
      });
    } catch (error) {
      sl<ToastInfo>().show(
        type: ToastType.error,
        message: error.message(context),
        context: context,
      );
    }
  }

  Future<void> _onSave() async {}
}
