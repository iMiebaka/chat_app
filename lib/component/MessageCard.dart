import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String messages;
  final String username;

  const MessageCard({
    Key? key,
    required this.messages,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(username),
            const Text(" : "),
            Text(
              messages,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
