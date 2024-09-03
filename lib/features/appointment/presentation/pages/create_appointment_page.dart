import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/date_time_extension.dart';
import '../../../../core/ui/extensions/event_type_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/widget/buttons/bottom_sheet_button_widget.dart';
import '../../../../core/ui/widget/dialogs/toast_info.dart';
import '../../../../core/ui/widget/dropdowns/string_dropdown_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../domain/entities/calendar_appointment_entity.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/entities/clinic_location_entity.dart';
import '../cubit/appointments/appointments_cubit.dart';
import '../cubit/calendars/calendars_cubit.dart';
import '../cubit/clinic_locations/clinic_locations_cubit.dart';
import '../cubit/clinics/clinics_cubit.dart';
import '../widgets/calendar_information_widget.dart';
import '../widgets/clinic_location_item_widget.dart';
import '../widgets/clinic_locations_loading_widget.dart';
import '../widgets/date_picker_widget.dart';
import '../widgets/arrival_time_widget.dart';

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
          create: (context) => sl<ClinicsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ClinicLocationsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CalendarsCubit>(),
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

  late DateTime _selectedMonth;
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

    _selectedMonth = DateTime.now();

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

  Future<void> _onInitGetCalendars() async {
    await BlocProvider.of<CalendarsCubit>(context).initGetCalendars(
      startTime: _selectedMonth,
      locationId: _selectedClinicLocation?.id,
    );
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
                                      NetworkImageWidget(
                                        imageUrl: _selectedClinic?.logo,
                                        size: Size(context.width, 50),
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
                            child: BlocBuilder<CalendarsCubit, CalendarsState>(
                              builder: (context, state) {
                                CalendarAppointmentEntity? calendar;
                                if (state is CalendarsLoaded) {
                                  final calendars = state.calendars;

                                  final currentMonthYear =
                                      _selectedMonth.onlyYearMonth;

                                  calendar = calendars.entries
                                      .firstWhereOrNull((element) {
                                    return element.key == currentMonthYear;
                                  })?.value;
                                }

                                List<DateTime?> unavailableDays = [];
                                List<DateTime?> availableDays = [];

                                final events = calendar?.events;
                                if (events != null) {
                                  for (final event in events) {
                                    final eventType = event.eventType;
                                    if (eventType == null) {
                                      continue;
                                    }

                                    switch (eventType) {
                                      case EventType.holiday:
                                        unavailableDays.add(event.startTime);
                                        break;
                                      case EventType.appointment:
                                        availableDays.add(event.startTime);
                                        break;
                                    }
                                  }
                                }

                                return DatePickerWidget(
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().addYears(100),
                                  currentDate: _selectedDate,
                                  currentMonth: _selectedMonth,
                                  isLoading: calendar == null,
                                  availableDays: availableDays,
                                  unavailableDays: unavailableDays,
                                  onDateSelected: (value) {
                                    _onDateChanged(
                                      value: value,
                                    );
                                  },
                                  onMonthChanged: (value) {
                                    _onMonthChanged(
                                      value: value,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const CalendarInformationWidget(),
                          const SizedBox(
                            height: 24,
                          ),
                          ArrivalTimeWidget(
                            isToday: _selectedDate?.isToday == true,
                            selectedHour: _selectedTime,
                            clinicLocation: _selectedClinicLocation,
                            onHourSelected: (value) {
                              _onHourSelected(
                                value: value,
                              );
                            },
                          ),
                          SizedBox(
                            height: context.paddingBottom,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              BottomSheetButtonWidget(
                text: _buttonText,
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

  String get _buttonText {
    switch (_currentStep) {
      case CreateAppointmentStep.chooseClinic:
        return context.locale.next;
      case CreateAppointmentStep.selectDate:
        return context.locale.save;
    }
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

        // reset state
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _selectedMonth = DateTime.now();
        });
        BlocProvider.of<CalendarsCubit>(context).init();
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

        final calendarsState = BlocProvider.of<CalendarsCubit>(context).state;
        if (calendarsState is! CalendarsLoaded) {
          _onInitGetCalendars();
        }

        break;
      case CreateAppointmentStep.selectDate:
        _onSave();

        break;
    }
  }

  void _onMonthChanged({
    required DateTime value,
  }) {
    if (_selectedMonth == value) {
      return;
    }

    _onGetCalendar(
      value: value,
    );
  }

  Future<void> _onGetCalendar({
    required DateTime value,
  }) async {
    try {
      setState(() {
        _selectedMonth = value;
      });

      // get calendars
      await BlocProvider.of<CalendarsCubit>(context).onChangedMonth(
        month: value,
      );

      // reload
      setState(() {});
    } catch (error) {
      sl<ToastInfo>().show(
        type: ToastType.error,
        message: error.message(context),
        context: context,
      );
    }
  }

  void _onDateChanged({
    required DateTime? value,
  }) async {
    if (value == null || _selectedDate == value) {
      return;
    }

    if (value.year != _selectedDate?.year) {
      // if selected yea not same with current month year, get calendar
      _onGetCalendar(
        value: value,
      );
    }

    setState(() {
      _selectedDate = value; // set new value
      _selectedTime = null; // reset time
    });
  }

  void _onHourSelected({
    required TimeOfDay value,
  }) {
    if (_selectedTime == value) {
      return;
    }

    setState(() {
      _selectedTime = value;
    });
  }

  Future<void> _onSave() async {
    try {
      // show full screen loading
      context.showFullScreenLoading();

      // create appointment
      await BlocProvider.of<AppointmentsCubit>(context).createEvent(
        clinic: _selectedClinic,
        location: _selectedClinicLocation,
        startTime: _selectedDate?.add(
          Duration(
            hours: _selectedTime?.hour ?? 0,
            minutes: _selectedTime?.minute ?? 0,
          ),
        ),
      );

      // show toast
      sl<ToastInfo>().show(
        type: ToastType.success,
        message: context.locale.successCreatedAppointment,
        context: context,
      );

      // go to my schedule
      context.goNamed(
        AppRoute.mySchedule.name,
      );
    } catch (error) {
      sl<ToastInfo>().show(
        type: ToastType.error,
        message: error.message(context),
        context: context,
      );
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }
}
