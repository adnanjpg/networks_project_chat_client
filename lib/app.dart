import 'package:flutter/material.dart';

import 'managers/client_manager.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClientManager.auth('adnan');
    ClientManager.setListener((msg) {
      debugPrint(msg.toString());
    });

    return const MaterialApp();
  }
}