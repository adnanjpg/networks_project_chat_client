import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';

import '../../../models/user_model.dart';
import '../../../provs/current_chat_prov.dart';
import '../../../utils/routes_consts.dart';

class UserLI extends ConsumerWidget {
  final UserModel user;
  const UserLI(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final selectedOnes = ref.watch(currentChatProv);

    return CheckboxListTile(
      title: Text(user.name!),
      onChanged: (bool? value) {
        if (value != true) {
          final oldSt = List.from(ref.read(currentChatProv));
          oldSt.remove(user);

          ref.read(currentChatProv.notifier).state = List.from(oldSt);
          return;
        }

        final me = ref.watch(userProv);

        if (me == null) {
          throw Exception('UserLI: me is null');
        }

        ref.read(currentChatProv.notifier).state = {
          ...(selectedOnes.toList()),
          user,
          me,
        }.toList();
      },
      value: selectedOnes.contains(user),
    );
  }
}
