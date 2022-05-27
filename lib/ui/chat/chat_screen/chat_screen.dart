import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networks_project_chat_client/provs/chat_names_prov.dart';

import '../../../managers/chat_manager.dart';
import '../../../models/chat_message_model.dart';
import '../../../provs/current_chat_prov.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ChatAppBar(),
      body: ChatMessagesList(),
      bottomNavigationBar: MessageSendBar(),
    );
  }
}

class ChatAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatAppBar> createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _ChatAppBarState extends ConsumerState<ChatAppBar> {
  bool isEditing = false;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(currentChatProv);

    return AppBar(
      title: isEditing
          ? TextFormField(controller: _controller)
          : Text(
              chat.title(ref),
            ),
      actions: isEditing
          ? [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  isEditing = false;

                  setState(() {});

                  ref.read(chatNamesProv.notifier).assignWithSend(
                        chat.map((e) => e.id!).toList(),
                        _controller.text,
                      );
                  _controller.clear();
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  isEditing = !isEditing;
                  setState(() {});
                },
              ),
            ],
    );
  }
}

class MessageSendBar extends ConsumerStatefulWidget {
  const MessageSendBar({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageSendBar> createState() => _MessageSendBarState();
}

class _MessageSendBarState extends ConsumerState<MessageSendBar> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(currentChatProv);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type your message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            child: const Text('Send'),
            onPressed: () {
              final text = controller.text;
              final msg = ChatMessageModel(
                message: text,
                recieversIds: chat.ids.toList(),
              );

              ChatManager.sendMessage(msg);

              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessagesList extends ConsumerStatefulWidget {
  const ChatMessagesList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatMessagesListState();
}

class _ChatMessagesListState extends ConsumerState<ChatMessagesList> {
  bool _listsAreEqual(List<String> list1, List<String> list2) {
    final l1 = Set.from(List.from(list1)..sort());
    final l2 = Set.from(List.from(list2)..sort());

    return const IterableEquality().equals(l1, l2);
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(currentChatProv);
    final allMsgs = ref.watch(ChatManager.chatMessagesProv);
    final msgs = allMsgs.where(
      (msg) => _listsAreEqual(msg.recieversIds, chat.ids.toList()),
    );

    return ListView.builder(
      itemCount: msgs.length,
      itemBuilder: (context, index) {
        final msg = msgs.elementAt(index);
        return ChatMessageLI(msg);
      },
    );
  }
}

class ChatMessageLI extends ConsumerWidget {
  final ChatMessageModel message;
  const ChatMessageLI(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(currentChatProv);

    final messageOwner = chat.firstWhere((u) => u.id == message.senderId);

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            messageOwner.name ?? '',
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            message.message,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
