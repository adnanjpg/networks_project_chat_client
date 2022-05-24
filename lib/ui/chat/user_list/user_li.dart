import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../../provs/current_chat_prov.dart';
import '../../../utils/routes_consts.dart';

class UserLI extends ConsumerWidget {
  final UserModel user;
  const UserLI(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return ListTile(
      title: Text(user.name!),
      onTap: () async {
        ref.read(currentChatProv.notifier).state = [user];

        Navigator.of(context).pop();

        Navigator.of(context).pushNamed(rChatScreen);
      },
    );
  }
}
