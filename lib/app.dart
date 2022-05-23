import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networks_project_chat_client/ui/chat/chat_screen/chat_screen.dart';
import 'main.dart';
import 'ui/chat/chat_ls.dart';
import 'ui/user_form_screen.dart';

import 'managers/client_manager.dart';
import 'utils/routes_consts.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    ref.read(userProv.notifier).state = initUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ClientManager.setListener();
    final user = ref.watch(userProv);
    return MaterialApp(
      routes: {
        rMain: (context) =>
            user == null ? const UserFormScreen() : const ChatLS(),
        rChatList: (context) => const ChatLS(),
        rChatScreen: (context) => const ChatScreen(),
      },
    );
  }
}
