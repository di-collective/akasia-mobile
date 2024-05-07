import '../../../core/common/service_locator.dart';
import '../../../core/ui/extensions/build_context_extension.dart';
import '../../../core/ui/extensions/theme_data_extension.dart';
import 'bloc/my_treatment_cubit.dart';
import 'bloc/my_treatment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class MyTreatmentScreen extends StatefulWidget {
  const MyTreatmentScreen({super.key});

  @override
  State<MyTreatmentScreen> createState() => _MyTreatmentScreenState();
}

class _MyTreatmentScreenState extends State<MyTreatmentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyTreatmentCubit>(
      create: (context) => serviceLocator<MyTreatmentCubit>()..onInit(),
      child: BlocBuilder<MyTreatmentCubit, MyTreatmentState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.when(
                  initial: () => 'Fake init..',
                  loaded: () => context.locale.myTreatment,
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
