import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networks_project_chat_client/managers/chat_manager.dart';
import 'package:networks_project_chat_client/managers/prefs_manager.dart';
import 'package:networks_project_chat_client/utils/routes_consts.dart';

import '../../../models/user_model.dart';
import '../../../provs/current_chat_prov.dart';

class UserLI extends ConsumerWidget {
  final UserModel user;
  const UserLI(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return ListTile(
      title: Text(user.name!),
      onTap: () async {
        final me = await PrefsManager.getUser();
        final chat = await ChatManager.createChat([me!, user]);

        ref.read(currentChatProv.notifier).state = chat;

        Navigator.of(context).pop();

        Navigator.of(context).pushNamed(rChatScreen);
      },
    );
  }
}
