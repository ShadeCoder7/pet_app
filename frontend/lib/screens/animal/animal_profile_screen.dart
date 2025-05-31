import 'package:flutter/material.dart';

class AnimalProfileScreen extends StatelessWidget {
  const AnimalProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hope&Paws - Animal Profile Screen')),
      body: Center(child: Text('Animal Profile Screen')),
    );
  }
}
