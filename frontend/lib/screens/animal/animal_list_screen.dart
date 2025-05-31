import 'package:flutter/material.dart';

class AnimalListScreen extends StatelessWidget {
  const AnimalListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hope&Paws - Animal ListS creen')),
      body: Center(child: Text('Animal List Screen')),
    );
  }
}
