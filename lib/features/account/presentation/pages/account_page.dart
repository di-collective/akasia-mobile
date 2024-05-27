import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/config/asset_path.dart';
import '../../../../app/di/depedency_injection.dart';
import '../../../../app/navigation/app_route.dart';
import '../../../../core/common/local_picker_info.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_parsing.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/dialogs/confirmation_dialog_widget.dart';
import '../../../../core/ui/widget/dialogs/dialog_widget.dart';
import '../../../../core/ui/widget/dialogs/toast_info.dart';
import '../../../../core/ui/widget/images/network_image_widget.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/cubit/yaml/yaml_cubit.dart';
import '../../domain/usecases/change_profile_picture_usecase.dart';
import '../widgets/account_item_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.paddingTop,
              ),
              GestureDetector(
                onTap: _onProfilePicture,
                child: Stack(
                  children: [
                    const NetworkImageWidget(
                      size: Size(120, 120),
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.white,
                            width: 2,
                          ),
                        ),
                        child: SvgPicture.asset(
                          AssetIconsPath.icCamera,
                          height: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'John Doe',
                style: textTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceDim,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 24,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              AccountItemWidget(
                title: context.locale.informationDetails,
                onTap: _onInformationDetails,
              ),
              AccountItemWidget(
                title: context.locale.accountSettings,
                onTap: _onAccountSettings,
              ),
              AccountItemWidget(
                title: context.locale.faq,
                onTap: _onFaq,
              ),
              AccountItemWidget(
                title: context.locale.helpCenter,
                onTap: _onHelpCenter,
              ),
              AccountItemWidget(
                title: context.locale.termsAndConditions,
                onTap: _onTermsAndConditions,
              ),
              AccountItemWidget(
                title: context.locale.privacyPolicy,
                onTap: _onPrivacyPolicy,
              ),
              AccountItemWidget(
                title: context.locale.ratings,
                onTap: _onRatings,
              ),
              AccountItemWidget(
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

                  return Text(
                    '${context.locale.appVersion} ${version ?? ''}',
                    style: textTheme.bodySmall.copyWith(
                      color: colorScheme.onSurface,
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
    );
  }

  Future<void> _onProfilePicture() async {
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

      // show full screen loading
      context.showFullScreenLoading();

      // post image to server
      await sl<ChangeProfilePictureUseCase>().call(
        ChangeProfilePictureParams(
          image: image,
        ),
      );

      return true;
    } catch (error) {
      sl<ToastInfo>().show(
        type: ToastType.error,
        message: error.message(context),
        context: context,
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
    // TODO: Implement this method
  }

  void _onFaq() {
    // TODO: Implement this method
  }

  void _onHelpCenter() {
    // TODO: Implement this method
  }

  void _onTermsAndConditions() {
    // TODO: Implement this method
  }

  void _onPrivacyPolicy() {
    // TODO: Implement this method
  }

  void _onRatings() {
    // TODO: Implement this method
  }

  Future<void> _onLogout() async {
    try {
      // show confirmation dialog
      final isLogout = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return ConfirmationDialogWidget(
            title: context.locale.loggingOut,
            description: context.locale.logOutConfirmation,
          );
        },
      );

      if (isLogout == null || !isLogout) {
        return;
      }

      // show full screen loading
      context.showFullScreenLoading();

      // logout
      await sl<AuthRepository>().signOut();

      // go to splash page
      context.goNamed(AppRoute.splash.name);
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