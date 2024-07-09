import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/widget/buttons/bottom_sheet_button_widget.dart';
import '../../../../core/ui/widget/dialogs/toast_info.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../../../core/ui/widget/states/state_empty_widget.dart';
import '../../../../core/ui/widget/states/state_error_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../cubit/my_schedules/my_schedules_cubit.dart';
import '../widgets/schedule_item_widget.dart';
import '../widgets/schedule_loading_item_widget.dart';

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    final mySchedulesState = BlocProvider.of<MySchedulesCubit>(context).state;
    if (mySchedulesState is! MySchedulesLoaded) {
      _onGetMaySchedules();
    }
  }

  Future<void> _onGetMaySchedules() async {
    await BlocProvider.of<MySchedulesCubit>(context).getMySchedules();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.mySchedule,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    BlocBuilder<MySchedulesCubit, MySchedulesState>(
                      builder: (context, state) {
                        if (state is MySchedulesError) {
                          return const SizedBox.shrink();
                        } else if (state is MySchedulesLoaded) {
                          if (state.schedules.isEmpty) {
                            return const SizedBox.shrink();
                          }
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 19,
                                horizontal: context.paddingHorizontal,
                              ),
                              child: BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileLoaded) {
                                    String? name = state.profile.name;

                                    if (name != null) {
                                      name = ", $name!";
                                    }

                                    return Row(
                                      children: [
                                        NetworkImageWidget(
                                          size: const Size(56, 56),
                                          fit: BoxFit.cover,
                                          imageUrl: state.profile.photoUrl,
                                          shapeBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Hi${name ?? ''}",
                                                style: textTheme.titleMedium
                                                    .copyWith(
                                                  color:
                                                      colorScheme.onSurfaceDim,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 2,
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                "Jangan lupa hari ini kamu punya jadwal temu dokter yaa",
                                                style: textTheme.bodyMedium
                                                    .copyWith(
                                                  color: colorScheme.onSurface,
                                                ),
                                                maxLines: 3,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  }

                                  return Row(
                                    children: [
                                      ShimmerLoading.circular(
                                        width: 56,
                                        height: 56,
                                        shapeBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ShimmerLoading.circular(
                                              width: context.width * 0.3,
                                              height: 32,
                                              shapeBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            ShimmerLoading.circular(
                                              width: context.width,
                                              height: 16,
                                              shapeBorder:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Divider(
                              color: colorScheme.surfaceBright,
                              height: 0,
                              thickness: 4,
                            ),
                          ],
                        );
                      },
                    ),
                    BlocBuilder<MySchedulesCubit, MySchedulesState>(
                      builder: (context, state) {
                        if (state is MySchedulesLoaded) {
                          if (state.schedules.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: context.height * 0.3,
                                left: context.paddingHorizontal,
                                right: context.paddingHorizontal,
                              ),
                              child: BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  String? name;
                                  if (state is ProfileLoaded) {
                                    name = "Hi, ${state.profile.name ?? ''}!";
                                  }

                                  return StateEmptyWidget(
                                    width: context.width,
                                    buttonText: context.locale.createItem(
                                      context.locale.appointment,
                                    ),
                                    title: name,
                                    description:
                                        'Saat ini kamu belum memiliki jadwal konsultasi dengan dokter manapun.',
                                    onTapButton: _onCreateAppointment,
                                  );
                                },
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: state.schedules.length,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: context.paddingHorizontal,
                            ),
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 16,
                              );
                            },
                            itemBuilder: (context, index) {
                              return ScheduleItemWidget(
                                index: index,
                                isDisabled: false,
                                onTap: _onSchedule,
                              );
                            },
                          );
                        } else if (state is MySchedulesError) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: context.height * 0.3,
                              left: context.paddingHorizontal,
                              right: context.paddingHorizontal,
                            ),
                            child: StateErrorWidget(
                              description: state.error.message(context),
                              width: context.width,
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: 3,
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: context.paddingHorizontal,
                          ),
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
                          itemBuilder: (context, index) {
                            return ScheduleLoadingItemWidget(
                              index: index,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<MySchedulesCubit, MySchedulesState>(
              builder: (context, state) {
                if (state is MySchedulesError) {
                  return const SizedBox.shrink();
                } else if (state is MySchedulesLoaded) {
                  if (state.schedules.isEmpty) {
                    return const SizedBox.shrink();
                  }
                }

                return BottomSheetButtonWidget(
                  text: context.locale.createItem(
                    context.locale.appointment,
                  ),
                  width: context.width,
                  isLoading: state is MySchedulesLoading,
                  isUseShimmerLoading: true,
                  onTap: _onCreateAppointment,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    try {
      List<Future> futures = [];
      final profileState = BlocProvider.of<ProfileCubit>(context).state;
      if (profileState is! ProfileLoaded) {
        futures.add(BlocProvider.of<ProfileCubit>(context).refreshGetProfile());
      }

      futures
          .add(BlocProvider.of<MySchedulesCubit>(context).refreshSchedules());

      await Future.wait(
        futures,
      );
    } catch (error) {
      sl<ToastInfo>().show(
        context: context,
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }

  void _onSchedule() {
    // TODO: implement onSchedule
  }

  void _onCreateAppointment() {
    // go to create appointment page
    context.goNamed(
      AppRoute.createAppointment.name,
    );
  }
}
