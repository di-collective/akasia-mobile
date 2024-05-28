import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/service_locator.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/text_form_field_widget.dart';
import '../cubit/create_new_password/create_new_password_cubit.dart';

class CreateNewPasswordPage extends StatelessWidget {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateNewPasswordCubit>(),
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

  final _passwordTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return BlocBuilder<CreateNewPasswordCubit, CreateNewPasswordState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.closeKeyboard,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                context.locale.forgotPassword,
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: context.paddingTop * 2,
                  ),
                  Text(
                    context.locale.newPassword,
                    style: textTheme.titleMedium.copyWith(
                      color: colorScheme.onSurfaceDim,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    context.locale.passwordMustContains,
                    style: textTheme.labelMedium.copyWith(
                      color: colorScheme.onSurface,
                      height: 0,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormFieldWidget(
                      controller: _passwordTextController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: context.locale.inputNewPassword,
                      validator: (val) {
                        return _passwordTextController.validatePassword(
                          context: context,
                        );
                      },
                      onChanged: (val) {
                        // reload
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    text: context.locale.resetPassword,
                    width: context.width,
                    isDisabled: _passwordTextController.text.isEmpty ||
                        _formKey.currentState?.validate() == false,
                    isLoading: state is CreateNewPasswordLoading,
                    onTap: _onResetPassword,
                  ),
                  SizedBox(
                    height: context.paddingBottom,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onResetPassword() async {
    try {
      final createNewPasswordState =
          BlocProvider.of<CreateNewPasswordCubit>(context).state;
      if (createNewPasswordState is CreateNewPasswordLoading) {
        return;
      }

      if (_formKey.currentState?.validate() == false) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      // create new password
      await BlocProvider.of<CreateNewPasswordCubit>(context)
          .confirmPasswordReset(
        code: "", // TODO: Get code from deep link email
        newPassword: _passwordTextController.text,
      );

      // go to success create new password page
      context.goNamed(AppRoute.successCreateNewPassword.name);
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
