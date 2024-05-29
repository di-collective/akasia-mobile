import 'package:flutter/material.dart';

class DeactiveAccountPage extends StatefulWidget {
  const DeactiveAccountPage({super.key});

  @override
  State<DeactiveAccountPage> createState() => _DeactiveAccountPageState();
}

class _DeactiveAccountPageState extends State<DeactiveAccountPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Deactive Account Page'),
      ),
    );
  }
}
