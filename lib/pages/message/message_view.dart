import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  static const String routeName = '/message';

  const MessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
        centerTitle: true,
      ),
    );
  }
}