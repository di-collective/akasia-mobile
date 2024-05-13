import 'package:flutter/material.dart';

class MyTreatmentPage extends StatelessWidget {
  const MyTreatmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Treatment'),
      ),
      body: const Center(
        child: Text('My Treatment'),
      ),
    );
  }
}
