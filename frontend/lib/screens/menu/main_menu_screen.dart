import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hope&Paws - Main Menu Screen')),
      body: Center(child: Text('Main Menu Screen')),
    );
  }
}
