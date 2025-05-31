import 'package:flutter/material.dart';

class OptionsMenuScreen extends StatelessWidget {
  const OptionsMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hope&Paws - Options Menu Screen')),
      body: Center(child: Text('Options Menu Screen')),
    );
  }
}
