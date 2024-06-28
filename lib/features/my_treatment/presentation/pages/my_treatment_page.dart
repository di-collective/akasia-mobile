import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../widgets/emergency_call_widget.dart';
import '../widgets/procedure_history_widget.dart';
import '../widgets/weight_chart_widget.dart';

class MyTreatmentPage extends StatefulWidget {
  const MyTreatmentPage({super.key});

  @override
  State<MyTreatmentPage> createState() => _MyTreatmentPageState();
}

class _MyTreatmentPageState extends State<MyTreatmentPage> {
  bool _isDisabled = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    _isDisabled = false;

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
            EmergencyCallWidget(
              isDisabled: _isDisabled,
            ),
            const SizedBox(
              height: 32,
            ),
            WeightChartWidget(
              isDisabled: _isDisabled,
            ),
            const SizedBox(
              height: 32,
            ),
            const ProcedureHistoryWidget(
              procedureHistories: [1, 1, 1],
            ),
            SizedBox(
              height: context.paddingBottom,
            ),
          ],
        ),
      ),
    );
  }
}
