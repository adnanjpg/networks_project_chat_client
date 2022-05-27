import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networks_project_chat_client/main.dart';

import '../models/user_model.dart';
import 'chat_names_prov.dart';

typedef ChatUsers = List<UserModel>;

extension A on ChatUsers {
  String title(WidgetRef ref) {
    final allNms = ref.watch(chatNamesProv);
    final ids = map((e) => e.id!).toList();

    final value = allNms[ChatNamesProvNot.userIdsToString(ids)];

    if (value == null) {
      return names.join(', ');
    }

    return value;
  }

  Iterable<String> get names {
    return map((user) {
      return user.name!;
    });
  }

  Iterable<String> get ids {
    return map((user) {
      return user.id!;
    });
  }
}

final currentChatProv = StateProvider<ChatUsers>((_) => []);
