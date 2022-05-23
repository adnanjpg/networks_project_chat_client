import 'package:flutter/material.dart';

import '../../../managers/chat_manager.dart';
import '../../../models/user_model.dart';
import 'user_li.dart';

class UserSelectionDialog extends StatefulWidget {
  const UserSelectionDialog({Key? key}) : super(key: key);

  @override
  State<UserSelectionDialog> createState() => _UserSelectionDialogState();
}

class _UserSelectionDialogState extends State<UserSelectionDialog> {
  @override
  void initState() {
    ChatManager.initUsersList();
    super.initState();
  }

  @override
  void dispose() {
    // ChatManager.usersController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder(
        stream: ChatManager.usersController.stream,
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

          final users = (snp.data! as List<UserModel>)
              .where((element) => element.name != null);
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users.elementAt(index);
              return UserLI(user);
            },
          );
        },
      ),
    );
  }
}
