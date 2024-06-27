import 'package:flutter/material.dart';

import '../../../../core/ui/extensions/build_context_extension.dart';
import '../../../../core/ui/extensions/theme_data_extension.dart';
import '../widgets/emergency_call_widget.dart';

class MyTreatmentPage extends StatefulWidget {
  const MyTreatmentPage({super.key});

  @override
  State<MyTreatmentPage> createState() => _MyTreatmentPageState();
}

class _MyTreatmentPageState extends State<MyTreatmentPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.appTextTheme;
    final colorScheme = context.theme.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.locale.myTreatment,
        ),
      ),
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
            const EmergencyCallWidget(
              isDisabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
