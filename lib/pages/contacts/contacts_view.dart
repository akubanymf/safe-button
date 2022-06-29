import 'package:flutter/material.dart';


class ContactsView extends StatelessWidget {
  static const String routeName = '/selectContacts';

  const ContactsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ContactsView'),
        centerTitle: true,
      ),
    );
  }
}