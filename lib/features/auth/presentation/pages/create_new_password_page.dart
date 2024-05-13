import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/depedency_injection.dart';
import '../../../../app/navigation/app_route.dart';
import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/object_parsing.dart';
import '../../../../core/ui/extensions/toast_type_parsing.dart';
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
    return BlocBuilder<CreateNewPasswordCubit, CreateNewPasswordState>(
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: Text('Create New Password Page'),
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

      // go to sign in page
      context.goNamed(AppRoute.signIn.name);
    } catch (error) {
      context.showToast(
        type: ToastType.error,
        message: error.message(context),
      );
    }
  }
}
