import 'package:networks_project_chat_client/managers/client_manager.dart';
import 'package:networks_project_chat_client/models/message_model.dart';
import 'package:networks_project_chat_client/utils/command_consts.dart';
import 'package:riverpod/riverpod.dart';

typedef ChatNames = Map<String, String>;

final chatNamesProv = StateNotifierProvider<ChatNamesProvNot, ChatNames>(
  (_) => ChatNamesProvNot(),
);

class ChatNamesProvNot extends StateNotifier<ChatNames> {
  ChatNamesProvNot() : super({});

  static String userIdsToString(List<String> ids) {
    ids.sort();
    return ids.join(',');
  }

  static List<String> stringToUserIds(String str) => str.split(',');

  void assign(List<String> recievers, String title) {
    recievers.sort();

    final st = Map<String, String>.from(state);
    st[userIdsToString(recievers)] = title;

    state = st;
  }

  void assignWithSend(List<String> recievers, String title) {
    assign(recievers, title);

    final msg = MessageModel(
      title: renameChatCommand,
      params: {
        'title': title,
        'recievers': recievers,
      },
    );

    ClientManager.sendMessage(msg);
  }
}
