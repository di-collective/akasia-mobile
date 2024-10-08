import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/asset_path.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/ui/extensions/auth_type_extension.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../../core/ui/extensions/validation_extension.dart';
import '../../../../core/ui/theme/theme.dart';
import '../../../../core/ui/widget/buttons/button_widget.dart';
import '../../../../core/ui/widget/forms/text_form_widget.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../cubit/sign_in/sign_in_cubit.dart';
import '../widgets/social_auth_button_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignInCubit>(),
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
  final _passwordTextController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.closeKeyboard,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.overlayStyleLight,
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.paddingHorizontal,
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            AssetImagesPath.logoTextColored,
                            height: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          context.locale.login,
                          style: textTheme.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormWidget(
                          controller: _emailTextController,
                          title: context.locale.email,
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
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormWidget(
                          controller: _passwordTextController,
                          title: context.locale.password,
                          keyboardType: TextInputType.visiblePassword,
                          onEditingComplete: () {
                            _onSignIn(
                              authType: AuthType.email,
                            );
                          },
                          validator: (val) {
                            return _passwordTextController.validatePassword(
                              context: context,
                              isRequired: true,
                            );
                          },
                          onChanged: (val) {
                            // reload
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: _onForgotPassword,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Text(
                              context.locale.forgotPassword,
                              style: textTheme.labelMedium.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonWidget(
                          text: context.locale.login,
                          width: context.width,
                          isDisabled: _emailTextController.text.isEmpty ||
                              _formKey.currentState?.validate() == false,
                          isLoading: state is SignInLoading &&
                              state.authType == AuthType.email,
                          onTap: () {
                            _onSignIn(
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
                            label: AuthType.apple.signInLabel(context)!,
                            iconPath: AuthType.apple.iconPath!,
                            isLoading: state is SignInLoading &&
                                state.authType == AuthType.apple,
                            onTap: () {
                              _onSignIn(
                                authType: AuthType.apple,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                        AuthTypeButtonWidget(
                          label: AuthType.google.signInLabel(context)!,
                          iconPath: AuthType.google.iconPath!,
                          isLoading: state is SignInLoading &&
                              state.authType == AuthType.google,
                          onTap: () {
                            _onSignIn(
                              authType: AuthType.google,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        GestureDetector(
                          onTap: _onSignUp,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Center(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${context.locale.newToAkasia}? ",
                                      style: textTheme.labelMedium.copyWith(
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    TextSpan(
                                      text: context.locale.signUp,
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
            ),
          ),
        );
      },
    );
  }

  void _onForgotPassword() {
    context.goNamed(AppRoute.forgotPassword.name);
  }

  void _onSignUp() {
    context.goNamed(AppRoute.signUp.name);
  }

  Future<void> _onSignIn({
    required AuthType authType,
  }) async {
    try {
      final signInState = BlocProvider.of<SignInCubit>(context).state;
      if (signInState is SignInLoading) {
        return;
      }

      if (authType == AuthType.email) {
        if (_formKey.currentState?.validate() == false) {
          return;
        }
      }

      // close keyboard
      context.closeKeyboard;

      // sign in
      final userCredential = await BlocProvider.of<SignInCubit>(context).signIn(
        authType: authType,
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      if (userCredential == null) {
        // user canceled sign in process
        return;
      }

      // get profile
      await BlocProvider.of<ProfileCubit>(context).getProfile();

      // go to main page
      context.goNamed(AppRoute.main.name);
    } catch (error) {
      context.showErrorToast(
        message: error.message(context),
      );
    }
  }
}
