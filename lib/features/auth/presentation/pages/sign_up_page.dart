import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/country_config.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/auth_type_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/ktp_text_form_widget.dart';
import '../../../../core/ui/widget/forms/phone_number_text_form_widget.dart';
import '../../../../core/ui/widget/forms/text_form_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../country/domain/entities/country_entity.dart';
import '../cubit/sign_up/sign_up_cubit.dart';
import '../widgets/social_auth_button_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignUpCubit>(),
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
  final _eKtpFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _emailPasswordFormKey = GlobalKey<FormState>();

  final _eKtpTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  late CountryEntity _selectedCountry;

  @override
  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    // init country
    _initCountry();
  }

  void _initCountry() {
    _selectedCountry = CountryConfig.indonesia;
  }

  @override
  void dispose() {
    _eKtpTextController.dispose();
    _nameTextController.dispose();
    _emailTextController.dispose();
    _phoneTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.closeKeyboard,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.paddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: context.paddingTop + 20,
                    ),
                    Text(
                      context.locale.createYourAccount,
                      style: textTheme.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      context.locale.registrationIsEasy,
                      style: textTheme.labelMedium.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _eKtpFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: KtpTextFormWidget(
                        context: context,
                        controller: _eKtpTextController,
                        title: context.locale.eKtpNumber,
                        onChanged: (_) {
                          // reload
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _nameFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormWidget(
                        controller: _nameTextController,
                        title: context.locale.fullName,
                        keyboardType: TextInputType.name,
                        isRequired: true,
                        validator: (val) {
                          return _nameTextController.cannotEmpty(
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
                    Form(
                      key: _phoneFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: PhoneNumberTextFormWidget(
                        context: context,
                        controller: _phoneTextController,
                        title: context.locale.phoneNumber,
                        isRequired: true,
                        selectedCountry: _selectedCountry,
                        onChanged: (val) {
                          // reload
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _emailPasswordFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormWidget(
                            controller: _emailTextController,
                            title: context.locale.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (state.authType != AuthType.email) {
                                return null;
                              }

                              return _emailTextController.validateEmail(
                                context: context,
                              );
                            },
                            onChanged: (val) {
                              // reload
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormWidget(
                            controller: _passwordTextController,
                            title: context.locale.password,
                            keyboardType: TextInputType.visiblePassword,
                            description:
                                context.locale.passwordsMustBeCharacters(12),
                            validator: (val) {
                              return _passwordTextController.validatePassword(
                                context: context,
                                isRequired:
                                    _emailTextController.text.isNotEmpty,
                              );
                            },
                            onChanged: (val) {
                              // reload
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormWidget(
                            controller: _confirmPasswordTextController,
                            title: context.locale.repeatPassword,
                            keyboardType: TextInputType.visiblePassword,
                            onEditingComplete: () {
                              _onSignUp(
                                authType: AuthType.email,
                              );
                            },
                            validator: (val) {
                              if (_passwordTextController.text.isEmpty) {
                                return null;
                              }

                              return _confirmPasswordTextController
                                  .validateConfirmPassword(
                                context: context,
                                anotherPassword: _passwordTextController.text,
                                isRequired: true,
                              );
                            },
                            onChanged: (val) {
                              // reload
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonWidget(
                      text: context.locale.register,
                      width: context.width,
                      isDisabled: _phoneTextController.text.isEmpty ||
                          _phoneFormKey.currentState?.validate() == false ||
                          _eKtpFormKey.currentState?.validate() == false ||
                          _nameTextController.text.isEmpty ||
                          _nameFormKey.currentState?.validate() == false ||
                          _emailTextController.text.isEmpty ||
                          _emailPasswordFormKey.currentState?.validate() ==
                              false ||
                          _passwordTextController.text.isEmpty ||
                          _emailPasswordFormKey.currentState?.validate() ==
                              false,
                      isLoading: state is SignUpLoading &&
                          state.authType == AuthType.email,
                      onTap: () {
                        _onSignUp(
                          authType: AuthType.email,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        context.locale.or,
                        style: textTheme.bodySmall.copyWith(
                          color: colorScheme.onSurfaceBright,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (Platform.isIOS) ...[
                      AuthTypeButtonWidget(
                        label: AuthType.apple.signUpLabel(context)!,
                        iconPath: AuthType.apple.iconPath!,
                        isLoading: state is SignUpLoading &&
                            state.authType == AuthType.apple,
                        onTap: () {
                          _onSignUp(
                            authType: AuthType.apple,
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    AuthTypeButtonWidget(
                      label: AuthType.google.signUpLabel(context)!,
                      iconPath: AuthType.google.iconPath!,
                      isLoading: state is SignUpLoading &&
                          state.authType == AuthType.google,
                      onTap: () {
                        _onSignUp(
                          authType: AuthType.google,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    GestureDetector(
                      onTap: _onSignIn,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "${context.locale.alreadyHaveAnAccount}? ",
                                  style: textTheme.labelMedium.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                TextSpan(
                                  text: context.locale.signIn,
                                  style: textTheme.labelMedium.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
        );
      },
    );
  }

  void _onSignIn() {
    context.goNamed(AppRoute.signIn.name);
  }

  Future<void> _onSignUp({
    required AuthType authType,
  }) async {
    try {
      final signInState = BlocProvider.of<SignUpCubit>(context).state;
      if (signInState is SignUpLoading) {
        return;
      }

      if (authType == AuthType.email) {
        // validate name form
        if (_nameFormKey.currentState?.validate() == false) {
          return;
        }

        // validate email password form
        if (_emailPasswordFormKey.currentState?.validate() == false) {
          return;
        }
      }

      // validate phone form
      if (_phoneFormKey.currentState?.validate() == false) {
        return;
      }

      // close keyboard
      context.closeKeyboard;

      // sign up
      final userCredential = await BlocProvider.of<SignUpCubit>(context).signUp(
        authType: authType,
        email: _emailTextController.text.isEmpty
            ? null
            : _emailTextController.text,
        name:
            _nameTextController.text.isEmpty ? null : _nameTextController.text,
        phoneCode: _selectedCountry.phoneCode,
        phoneNumber: _phoneTextController.text,
        password: _passwordTextController.text.isEmpty
            ? null
            : _passwordTextController.text,
      );

      if (userCredential == null) {
        // user canceled sign up process
        return;
      }

      // go to main page
      context.goNamed(AppRoute.main.name);
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
