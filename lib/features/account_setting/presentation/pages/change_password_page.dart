import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _oldPasswordTextController.dispose();
    _newPasswordTextController.dispose();
    _confirmPasswordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Change Password Page'),
      ),
    );
  }
}
