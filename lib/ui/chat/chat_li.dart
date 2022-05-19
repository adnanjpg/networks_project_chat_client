import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:networks_project_chat_client/models/chat_model.dart';

class ChatLI extends StatelessWidget {
  final ChatModel chat;
  const ChatLI(this.chat, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: chat.title != null ? Text(chat.title!) : null,
      // subtitle: Text(chat.lastMessage),
    );
  }
}
