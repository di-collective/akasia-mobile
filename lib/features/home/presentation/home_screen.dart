import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/depedency_injection.dart';
import '../../../core/ui/extensions/build_context_extension.dart';
import '../../../core/ui/extensions/theme_data_extension.dart';
import 'bloc/home_cubit.dart';
import 'bloc/home_state.dart';

@immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onNavigateToSomeScreen,
  });

  final Function(String param) onNavigateToSomeScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => sl<HomeCubit>()..onInit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.isInitializing
                    ? 'Fake init..'
                    : state.isLoading
                        ? 'Fake loading..'
                        : context.locale.home,
                style: context.theme.appTextTheme.titleLarge,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => context.cubit<HomeCubit>().onLoadSomething(),
                child: Text(
                  state.isLoading ? 'Wait' : 'Load Something',
                  style: context.theme.appTextTheme.labelMedium,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
