import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/local_picker_info.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/theme/theme.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/buttons/outline_button_widget.dart';
import '../../../../core/ui/widget/dialogs/confirmation_dialog_widget.dart';
import '../../../../core/ui/widget/dialogs/dialog_widget.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../../core/ui/widget/loadings/shimmer_loading.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/cubit/yaml/yaml_cubit.dart';
import '../../domain/usecases/change_profile_picture_usecase.dart';
import '../cubit/profile/profile_cubit.dart';
import '../widgets/setting_item_widget.dart';
import '../widgets/setting_label_item_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    final profileState = BlocProvider.of<ProfileCubit>(context).state;
    if (profileState is! ProfileLoaded) {
      // if profile not loaded, get profile
      _onGetProfile();
    }
  }

  Future<void> _onGetProfile() async {
    await BlocProvider.of<ProfileCubit>(context).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.overlayStyleLight,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.paddingHorizontal,
                    ),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        String? photoUrl;
                        String? name;
                        String? email;

                        if (state is ProfileLoaded) {
                          photoUrl = state.profile.photoUrl;
                          name = state.profile.name;
                          email = sl<FirebaseAuth>().currentUser?.email;
                        }

                        return Row(
                          children: [
                            NetworkImageWidget(
                              size: const Size(80, 80),
                              shapeBorder: const CircleBorder(),
                              fit: BoxFit.cover,
                              imageUrl: photoUrl,
                              isLoading: state is ProfileLoading,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (state is ProfileLoaded) ...[
                                    Text(
                                      name ?? '',
                                      maxLines: 3,
                                      style: textTheme.headlineSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurfaceDim,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      email ?? '',
                                      maxLines: 2,
                                      style: textTheme.bodyMedium.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    OutlineButtonWidget(
                                      colorScheme: colorScheme,
                                      height: 32,
                                      text: context.locale.changeProfilePicture,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      style: textTheme.bodyMedium.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      onTap: () => _onProfilePicture(
                                        state: state,
                                      ),
                                    ),
                                  ] else ...[
                                    ShimmerLoading.rectangular(
                                      width: context.width * 0.3,
                                      height: 32,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    ShimmerLoading.rectangular(
                                      width: context.width * 0.4,
                                      height: 16,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    ShimmerLoading.rectangular(
                                      width: context.width * 0.5,
                                      height: 32,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  SettingLabelItemWidget(
                    title: context.locale.personalSettings,
                  ),
                  SettingItemWidget(
                    title: context.locale.informationDetails,
                    onTap: _onInformationDetails,
                  ),
                  SettingItemWidget(
                    title: context.locale.accountSettings,
                    onTap: _onAccountSettings,
                  ),
                  SettingItemWidget(
                    title: context.locale.notificationSetting,
                    onTap: _onNotificationSettings,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SettingLabelItemWidget(
                    title: context.locale.appSettings,
                  ),
                  SettingItemWidget(
                    title: context.locale.partnerServices,
                    onTap: _onPartnerServices,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SettingLabelItemWidget(
                    title: context.locale.more,
                  ),
                  SettingItemWidget(
                    title: context.locale.faq,
                    onTap: _onFaq,
                  ),
                  SettingItemWidget(
                    title: context.locale.helpCenter,
                    onTap: _onHelpCenter,
                  ),
                  SettingItemWidget(
                    title: context.locale.termsAndConditions,
                    onTap: _onTermsAndConditions,
                  ),
                  SettingItemWidget(
                    title: context.locale.privacyPolicy,
                    onTap: _onPrivacyPolicy,
                  ),
                  SettingItemWidget(
                    title: context.locale.ratings,
                    onTap: _onRatings,
                  ),
                  SettingItemWidget(
                    title: context.locale.logout,
                    titleColor: colorScheme.error,
                    onTap: _onLogout,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  BlocBuilder<YamlCubit, YamlState>(
                    builder: (context, state) {
                      String? version;

                      if (state is YamlLoaded) {
                        version = state.yaml.version;
                      }

                      return Center(
                        child: Text(
                          '${context.locale.appVersion} ${version ?? ''}',
                          style: textTheme.bodySmall.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    try {
      await Future.wait([
        BlocProvider.of<ProfileCubit>(context).refreshGetProfile(),
      ]);
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }

  Future<void> _onProfilePicture({
    required ProfileState state,
  }) async {
    if (state is! ProfileLoaded) {
      return;
    }

    // show dialog change profile picture
    await showDialog(
      context: context,
      builder: (context) {
        final colorScheme = context.theme.appColorScheme;

        return DialogWidget(
          title: context.locale.photo,
          description: context.locale.choosePhotoSource,
          button: Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  text: context.locale.takePhoto,
                  borderColor: Colors.transparent,
                  textColor: colorScheme.primary,
                  backgroundColor: Colors.transparent,
                  onTap: () async {
                    final iSuccess = await _onChangeProfilePicture(
                      source: ImageSource.camera,
                    );
                    if (!iSuccess) {
                      return;
                    }

                    // close dialog
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ButtonWidget(
                  text: context.locale.photoLibrary,
                  borderColor: Colors.transparent,
                  textColor: colorScheme.primary,
                  backgroundColor: Colors.transparent,
                  onTap: () async {
                    final iSuccess = await _onChangeProfilePicture(
                      source: ImageSource.gallery,
                    );
                    if (!iSuccess) {
                      return;
                    }

                    // close dialog
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _onChangeProfilePicture({
    required ImageSource source,
  }) async {
    try {
      final image = await sl<LocalPickerInfo>().selectImage(
        imageSource: source,
      );
      if (image == null) {
        return false;
      }

      final profileState = BlocProvider.of<ProfileCubit>(context).state;
      if (profileState is! ProfileLoaded) {
        throw Exception("Profile not loaded");
      }
      final userId = profileState.profile.userId;

      // show full screen loading
      context.showFullScreenLoading();

      // post image to server
      final photUrl = await sl<ChangeProfilePictureUseCase>().call(
        ChangeProfilePictureParams(
          image: image,
          userId: userId,
        ),
      );

      if (photUrl != null) {
        // update profile photo url on profile state
        final profile = profileState.profile.copyWith(
          photoUrl: photUrl,
        );
        BlocProvider.of<ProfileCubit>(context).emitProfileData(
          profile,
        );
      }

      return true;
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );

      return false;
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }

  void _onInformationDetails() {
    // go to profile page
    context.goNamed(AppRoute.profile.name);
  }

  void _onAccountSettings() {
    // go to account setting page
    context.goNamed(AppRoute.accountSetting.name);
  }

  void _onNotificationSettings() {
    // TODO: Implement this method
  }

  void _onPartnerServices() {
    // go to partner services page
    context.goNamed(
      AppRoute.partnerServices.name,
    );
  }

  void _onFaq() {
    // go to afaq page
    context.goNamed(AppRoute.faq.name);
  }

  void _onHelpCenter() {
    // go to help center page
    context.goNamed(AppRoute.helpCenter.name);
  }

  void _onTermsAndConditions() {
    // TODO: Implement this method
  }

  void _onPrivacyPolicy() {
    // TODO: Implement this method
  }

  void _onRatings() {
    context.goNamed(AppRoute.ratings.name);
  }

  Future<void> _onLogout() async {
    try {
      // show confirmation dialog
      final isConfirm = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return ConfirmationDialogWidget(
            title: context.locale.loggingOut,
            description: context.locale.logOutConfirmation,
          );
        },
      );
      if (isConfirm != true) {
        return;
      }

      // show full screen loading
      context.showFullScreenLoading();

      // logout
      await sl<AuthRepository>().signOut();

      // init all cubits
      BlocProvider.of<ProfileCubit>(context).init();

      // go to splash page
      context.goNamed(AppRoute.splash.name);
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    } finally {
      // hide full screen loading
      context.hideFullScreenLoading;
    }
  }
}
