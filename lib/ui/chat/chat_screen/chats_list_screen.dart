import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:networks_project_chat_client/main.dart';
import 'package:networks_project_chat_client/provs/current_chat_prov.dart';
import 'package:networks_project_chat_client/ui/chat/user_list/user_selection_dialog.dart';
import 'package:networks_project_chat_client/utils/routes_consts.dart';

import '../../../managers/chat_manager.dart';

class ChatsListScreen extends ConsumerStatefulWidget {
  const ChatsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatsListScreenState();
}

class _ChatsListScreenState extends ConsumerState<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    final allMsgs = ref.watch(ChatManager.chatMessagesProv);
    final allRecievers = allMsgs
        .map(
          (msg) => msg.recieversIds..sort(),
        )
        .toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) {
                  return const UserSelectionDialog();
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: allRecievers.isEmpty
          ? const Center(
              child: Text('No chats yet!'),
            )
          : ListView.builder(
              itemCount: allRecievers.length,
              itemBuilder: (context, idx) {
                final ids = allRecievers.elementAt(idx);

                return ChatLI(ids);
              },
            ),
    );
  }
}

class ChatLI extends ConsumerWidget {
  final List<String> ids;
  const ChatLI(this.ids, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final allUsers = ref.watch(ChatManager.usersProv);

    final users = allUsers.where((user) => ids.contains(user.id)).toList();
    final ttl = users.title(ref);

    return ListTile(
      onTap: () {
        final me = ref.watch(userProv);
        ref.read(currentChatProv.notifier).state = [...users, me!];

        Navigator.of(context).pushNamed(rChatScreen);
      },
      leading: Text(ttl),
    );
  }
}
