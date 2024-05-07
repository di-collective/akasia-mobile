import 'package:flutter/material.dart';

class MainPageParams {
  final int? selectedIndex;

  MainPageParams({
    this.selectedIndex,
  });
}

class MainPage extends StatelessWidget {
  final MainPageParams? params;

  const MainPage({
    super.key,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
