import '../../../core/common/service_locator.dart';
import '../../../core/ui/extensions/build_context_extension.dart';
import '../../../core/ui/extensions/theme_data_extension.dart';
import 'bloc/account_cubit.dart';
import 'bloc/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountCubit>(
      create: (context) => serviceLocator<AccountCubit>()..onInit(),
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.when(
                  initial: () => 'Fake init..',
                  loaded: () => context.locale.account,
                ),
                style: context.theme.appTextTheme.titleLarge,
              ),
            ],
          );
        },
      ),
    );
  }
}
