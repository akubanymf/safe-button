import 'package:flutter/material.dart';

class ContactUsView extends StatelessWidget {
  static const String routeName = '/contactUs';

  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('contactUsView'),
        centerTitle: true,
      ),
    );
  }
}