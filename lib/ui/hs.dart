import 'package:flutter/material.dart';
import 'chat/user_list/user_selection_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UserSelectionDialog(),
    );
  }
}
