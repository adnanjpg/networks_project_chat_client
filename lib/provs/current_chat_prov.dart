import '../models/user_model.dart';
import 'package:riverpod/riverpod.dart';

typedef ChatUsers = List<UserModel>;

extension A on ChatUsers {
  String get userNamesStr {
    return names.join(', ');
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
