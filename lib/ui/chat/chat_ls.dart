import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'chat_list.dart';
import 'user_list/user_selection_dialog.dart';

class ChatLS extends StatelessWidget {
  const ChatLS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => const UserSelectionDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const ChatList(),
    );
  }
}
