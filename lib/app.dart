import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';
import 'managers/client_manager.dart';
import 'ui/chat/chat_screen/chat_screen.dart';
import 'ui/hs.dart';
import 'ui/user_form_screen.dart';
import 'utils/routes_consts.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ClientManager.setListener(ref);

    return MaterialApp(
      routes: {
        rMain: (context) {
          final user = ref.watch(userProv);

          if (user == null) {
            return const UserFormScreen();
          }

          return const HomeScreen();
        },
        rChatScreen: (context) => const ChatScreen(),
      },
    );
  }
}
