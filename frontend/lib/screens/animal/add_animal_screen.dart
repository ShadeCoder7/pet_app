import 'package:flutter/material.dart';

class AddAnimalScreen extends StatelessWidget {
  const AddAnimalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hope&Paws - Add animal Screen')),
      body: Center(child: Text('Add Animal Screen')),
    );
  }
}
