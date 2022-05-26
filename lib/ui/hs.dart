import 'package:flutter/material.dart';
import 'chat/chat_screen/chats_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChatsListScreen(),
    );
  }
}
