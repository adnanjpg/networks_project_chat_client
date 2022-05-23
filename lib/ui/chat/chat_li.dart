import 'package:flutter/material.dart';
import '../../models/chat_model.dart';

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
