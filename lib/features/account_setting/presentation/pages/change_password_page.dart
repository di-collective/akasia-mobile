import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/string_extension.dart';
import '../../../../core/ui/extensions/toast_type_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/text_form_field_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../cubit/change_password/change_password_cubit.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChangePasswordCubit>(),
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

  final _oldPasswordTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _oldPasswordTextController.dispose();
    _newPasswordTextController.dispose();
    _confirmPasswordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.closeKeyboard,
      child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                context.locale.changePassword.toCapitalizes(),
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
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormFieldWidget(
                              controller: _oldPasswordTextController,
                              title: context.locale.oldPassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                return _oldPasswordTextController
                                    .validatePassword(
                                  context: context,
                                  isRequired: true,
                                );
                              },
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldWidget(
                              controller: _newPasswordTextController,
                              title: context.locale.newPassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                return _newPasswordTextController
                                    .validatePassword(
                                  context: context,
                                  isRequired: true,
                                );
                              },
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormFieldWidget(
                              controller: _confirmPasswordTextController,
                              title: context.locale.resetPassword,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                return _confirmPasswordTextController
                                    .validateConfirmPassword(
                                  context: context,
                                  anotherPassword:
                                      _newPasswordTextController.text,
                                );
                              },
                              onChanged: (_) {
                                // reload
                                setState(() {});
                              },
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
                    isLoading: state is ChangePasswordLoading,
                    isDisabled: _oldPasswordTextController.text.isEmpty ||
                        _formKey.currentState?.validate() == false,
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
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      // call change password
      await BlocProvider.of<ChangePasswordCubit>(context).changePassword(
        oldPassword: _oldPasswordTextController.text,
        newPassword: _newPasswordTextController.text,
        confirmPassword: _confirmPasswordTextController.text,
      );

      // show success message
      context.showToast(
        message: context.locale.successChangePassword,
        type: ToastType.success,
      );

      // close page
      Navigator.pop(context);
    } catch (error) {
      context.showToast(
        message: error.message(context),
        type: ToastType.error,
      );
    }
  }
}
