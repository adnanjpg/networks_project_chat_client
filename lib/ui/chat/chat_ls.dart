import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:networks_project_chat_client/managers/chat_manager.dart';
import 'package:networks_project_chat_client/models/user_model.dart';
import 'package:networks_project_chat_client/ui/chat/chat_list.dart';

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
            builder: (context) {
              return const UserSelectionDialog();
            },
          );
        },
      ),
      body: const ChatList(),
    );
  }
}

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
      appBar: AppBar(),
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

class UserLI extends StatelessWidget {
  final UserModel user;
  const UserLI(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name!),
      // onTap: () {
      //   Navigator.pop(context, user);
      // },
    );
  }
}
