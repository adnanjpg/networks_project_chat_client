import 'dart:async';

import 'package:flutter/material.dart';
import 'package:networks_project_chat_client/managers/chat_manager.dart';

import '../../models/chat_model.dart';
import 'chat_li.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    ChatManager.initChatsList();
    super.initState();
  }

  @override
  void dispose() {
    // ChatManager.chatsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatManager.chatsController.stream,
      builder: (context, snp) {
        if (snp.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snp.hasError) {
          return Center(
            child: Text('Error: ${snp.error}'),
          );
        }

        if (!snp.hasData) {
          return const Center(
            child: Text('No chats'),
          );
        }

        final chats = snp.data! as List<ChatModel>;
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return ChatLI(chat);
          },
        );
      },
    );
  }
}
