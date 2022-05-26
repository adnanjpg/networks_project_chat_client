import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../managers/chat_manager.dart';
import '../../../provs/current_chat_prov.dart';
import '../../../utils/routes_consts.dart';
import 'user_li.dart';

class UserSelectionDialog extends StatefulWidget {
  const UserSelectionDialog({Key? key}) : super(key: key);

  @override
  State<UserSelectionDialog> createState() => _UserSelectionDialogState();
}

class _UserSelectionDialogState extends State<UserSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final users = ref.watch(ChatManager.usersProv);

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users.elementAt(index);

              return UserLI(user);
            },
          );
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final selectedUsers = ref.watch(currentChatProv);
          final anySelected = selectedUsers.isNotEmpty;

          return SizedBox(
            height: 60,
            child: ElevatedButton(
              child: const Text('Done'),
              onPressed: anySelected
                  ? () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(rChatScreen);
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}
