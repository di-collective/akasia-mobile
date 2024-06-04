import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/password_indicator_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/text_form_field_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../cubit/create_new_password/create_new_password_cubit.dart';
import '../widgets/password_indicator_widget.dart';

class CreateNewPasswordPageParams {
  final String resetToken;
  final String userId;

  CreateNewPasswordPageParams({
    required this.resetToken,
    required this.userId,
  });
}

class CreateNewPasswordPage<T> extends StatelessWidget {
  final T? params;

  const CreateNewPasswordPage({
    super.key,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateNewPasswordCubit>(),
      child: _Body(
        params: params,
      ),
    );
  }
}

class _Body<T> extends StatefulWidget {
  final T? params;

  const _Body({
    this.params,
  });

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  CreateNewPasswordPageParams? params;

  final _formKey = GlobalKey<FormState>();

  final _passwordTextController = TextEditingController();

  PasswordIndicator? _passwordIndicator;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    if (widget.params != null && widget.params is CreateNewPasswordPageParams) {
      params = widget.params;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _passwordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (params == null) {
      return const SizedBox.shrink();
    }

    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return BlocBuilder<CreateNewPasswordCubit, CreateNewPasswordState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.closeKeyboard,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                context.locale.createNewPassword,
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
                    context.locale.passwordsMustBeCharacters(12),
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
                          isRequired: true,
                        );
                      },
                      onChanged: (val) {
                        // reload
                        setState(() {
                          _passwordIndicator =
                              PasswordIndicatorExtension.parse(val);
                        });
                      },
                      onEditingComplete: _onResetPassword,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  PasswordIndicatorWidget(
                    indicator: _passwordIndicator,
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
      // validate
      if (_formKey.currentState?.validate() == false) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      // create new password
      await BlocProvider.of<CreateNewPasswordCubit>(context).updatePassword(
        userId: params!.userId,
        resetToken: params!.resetToken,
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
