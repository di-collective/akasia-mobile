import 'package:flutter/material.dart';

class ChangePhoneNumberPage extends StatefulWidget {
  const ChangePhoneNumberPage({super.key});

  @override
  State<ChangePhoneNumberPage> createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  final _oldPhoneNumberTextController = TextEditingController();
  final _newPhoneNumberTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _oldPhoneNumberTextController.dispose();
    _newPhoneNumberTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Change Phone Number Page'),
      ),
    );
  }
}
