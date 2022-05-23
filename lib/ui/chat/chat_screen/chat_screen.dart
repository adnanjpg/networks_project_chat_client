import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provs/current_chat_prov.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final chat = ref.watch(currentChatProv);

    return Scaffold(
      appBar: AppBar(
        title: Text(chat?.userNamesStr ?? ''),
      ),
    );
  }
}
