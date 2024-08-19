import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../../../account/presentation/cubit/profile/profile_cubit.dart';
import '../widgets/emergency_call_widget.dart';
import '../widgets/weight_chart_widget.dart';

class MyTreatmentPage extends StatefulWidget {
  const MyTreatmentPage({super.key});

  @override
  State<MyTreatmentPage> createState() => _MyTreatmentPageState();
}

class _MyTreatmentPageState extends State<MyTreatmentPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.myTreatment,
        ),
      ),
      backgroundColor: colorScheme.surfaceBright,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.paddingHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.paddingTop,
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                String? phoneNumber;
                if (state is ProfileLoaded) {
                  final ecPhone = state.profile.ecPhone;
                  final ecCountryCode = state.profile.ecCountryCode;
                  if (ecCountryCode != null && ecPhone != null) {
                    phoneNumber = "$ecCountryCode$ecPhone";
                  }
                }

                return EmergencyCallWidget(
                  isDisabled: phoneNumber == null,
                  phoneNumber: phoneNumber,
                );
              },
            ),
            const SizedBox(
              height: 32,
            ),
            const WeightChartWidget(),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }
}
