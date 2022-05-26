import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import '../models/user_model.dart';
import 'chat_names_prov.dart';

typedef ChatUsers = List<UserModel>;

extension A on ChatUsers {
  String title(WidgetRef ref) {
    final value = ref.read(chatNamesProv)[this];

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
