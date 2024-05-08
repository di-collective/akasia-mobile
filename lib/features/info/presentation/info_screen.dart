import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di/depedency_injection.dart';
import '../../../core/ui/extensions/build_context_extension.dart';
import '../../../core/ui/extensions/theme_data_extension.dart';
import 'bloc/info_cubit.dart';
import 'bloc/info_state.dart';

@immutable
class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoCubit>(
      create: (context) => sl<InfoCubit>()..onInit(),
      child: BlocBuilder<InfoCubit, InfoState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.when(
                  initial: () => 'Fake init..',
                  loaded: () => context.locale.info,
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
