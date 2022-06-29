import 'package:flutter/material.dart';

class LocationView extends StatelessWidget {
  static const String routeName = '/locationSetup';

  const LocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocationView'),
        centerTitle: true,
      ),
    );
  }
}