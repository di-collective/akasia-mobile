import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/text_form_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../cubit/forgot_password/forgot_password_cubit.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordCubit>(),
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

  final _emailTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _emailTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.closeKeyboard,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                context.locale.forgotPassword,
                style: TextStyle(
                  color: colorScheme.onSurfaceDim,
                ),
              ),
              backgroundColor: colorScheme.white,
              iconTheme: IconThemeData(
                color: colorScheme.primary,
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.paddingHorizontal,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  // TODO: Add a image
                  const SizedBox(
                    height: 120,
                  ),
                  Text(
                    context.locale.enterYourEmail,
                    style: textTheme.bodyMedium.copyWith(
                      color: colorScheme.onSurface,
                      height: 0,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormWidget(
                      controller: _emailTextController,
                      title: context.locale.emailAddress,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        return _emailTextController.validateEmail(
                          context: context,
                        );
                      },
                      onChanged: (val) {
                        // reload
                        setState(() {});
                      },
                      onEditingComplete: _onSendLinkToEmail,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    text: context.locale.sendLinkToEmail,
                    width: context.width,
                    isDisabled: _emailTextController.text.isEmpty ||
                        _formKey.currentState?.validate() == false,
                    isLoading: state is ForgotPasswordLoading,
                    onTap: _onSendLinkToEmail,
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

  Future<void> _onSendLinkToEmail() async {
    try {
      final forgotPasswordState =
          BlocProvider.of<ForgotPasswordCubit>(context).state;
      if (forgotPasswordState is ForgotPasswordLoading) {
        return;
      }

      if (_formKey.currentState?.validate() == false) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      // forgot password
      await BlocProvider.of<ForgotPasswordCubit>(context).forgotPassword(
        email: _emailTextController.text,
      );

      // show success message
      context.showSuccessToast(
        message: context.locale.emailSent,
      );
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
