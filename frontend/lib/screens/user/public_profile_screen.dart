import 'package:flutter/material.dart';

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hope&Paws - Public Profile Screen')),
      body: Center(child: Text('Public Profile Screen')),
    );
  }
}
