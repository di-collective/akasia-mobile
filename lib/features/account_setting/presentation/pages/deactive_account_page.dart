import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/deactive_account_reason_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/buttons/radio_widget.dart';
import '../../../../core/ui/widget/dialogs/confirmation_dialog_widget.dart';
import '../../../../core/ui/widget/forms/text_form_field_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../cubit/deactive_account/deactive_account_cubit.dart';

class DeactiveAccountPage extends StatelessWidget {
  const DeactiveAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeactiveAccountCubit>(),
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
  final _formKey = GlobalKey<FormState>();

  final _otherTextController = TextEditingController();

  DeactiveAccountReason? _selectedReason;

  @override
  void dispose() {
    super.dispose();

    _otherTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: BlocBuilder<DeactiveAccountCubit, DeactiveAccountState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.locale.deactiveAccount.toCapitalizes(),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            SizedBox(
                              height: context.paddingTop,
                            ),
                            Text(
                              "${context.locale.whyDoYouWantToDeactiveYourAccount}?",
                              style: textTheme.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurfaceDim,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            ...DeactiveAccountReason.values.map(
                              (reason) => Container(
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceBright,
                                  borderRadius: BorderRadius.circular(
                                    _selectedReason ==
                                            DeactiveAccountReason.other
                                        ? 20
                                        : 99,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    RadioWidget<DeactiveAccountReason>(
                                      value: reason,
                                      title: reason.title(
                                        context: context,
                                      ),
                                      groupValue: _selectedReason,
                                      titleStyle: textTheme.labelLarge.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: colorScheme.onSurfaceDim,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedReason = value;
                                        });
                                      },
                                    ),
                                    if (_selectedReason ==
                                            DeactiveAccountReason.other &&
                                        reason ==
                                            DeactiveAccountReason.other) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                          left: 48,
                                        ),
                                        child: TextFormFieldWidget(
                                          controller: _otherTextController,
                                          hintText: context.locale.example,
                                          validator: (value) {
                                            return _otherTextController
                                                .cannotEmpty(
                                              context: context,
                                            );
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: context.paddingBottom,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    text: context.locale.save,
                    width: context.width,
                    isLoading: state is DeactiveAccountLoading,
                    isDisabled: _selectedReason == null ||
                        (_selectedReason == DeactiveAccountReason.other &&
                            _otherTextController.text.isEmpty),
                    onTap: _onSave,
                  ),
                  SizedBox(
                    height: context.paddingBottom,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSave() async {
    try {
      // validate
      if (_selectedReason == DeactiveAccountReason.other) {
        if (_formKey.currentState?.validate() != true) {
          return;
        }
      }

      // confirmation
      final isConfirm = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return ConfirmationDialogWidget(
            title: "${context.locale.deactiveYourAccountWillDoTheFollowing}:",
            description: context.locale.logOutConfirmation,
            descriptionWidget: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AssetIconsPath.icCloseCircle,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        context.locale.logOutOnAllDevices,
                        style: context.theme.appTextTheme.labelLarge.copyWith(
                          color: context.theme.appColorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AssetIconsPath.icCloseCircle,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        context.locale.deleteAllOfYourAccountInformation,
                        style: context.theme.appTextTheme.labelLarge.copyWith(
                          color: context.theme.appColorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            cancelText: context.locale.cancel,
            confirmText: context.locale.deactive,
            confirmBackrgoundColor: context.theme.appColorScheme.error,
          );
        },
      );
      if (isConfirm != true) {
        return;
      }

      // call deactive account
      await BlocProvider.of<DeactiveAccountCubit>(context).deactiveAccount(
        reason: _selectedReason!,
      );

      // init all cubits
      BlocProvider.of<ProfileCubit>(context).init();

      // go to success page
      context.goNamed(
        AppRoute.successDeactiveAccount.name,
      );
    } catch (error) {
      context.showToast(
        message: error.message(context),
        type: ToastType.error,
      );
    }
  }
}
