import 'dart:async';

import 'client_manager.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

import '../utils/command_consts.dart';
import 'prefs_manager.dart';

abstract class ChatManager {
  static Future<ChatModel?> createChat(List<UserModel> users) async {
    final msg = MessageModel(
      title: createChatCommand,
      params: {
        'users': users.map((e) => e.toJson()).toList(),
      },
    );
    ClientManager.sendMessage(msg);

    await for (final msg in ClientManager.chatController.stream) {
      if (msg.title == createChatCommand) {
        return ChatModel.fromJson(msg.params!);
      }
    }

    return null;
  }

  static final chatsController = StreamController<List<ChatModel>>.broadcast();
  static List<ChatModel> chats = [];
  static Future initChatsList() async {
    final msg = MessageModel(
      user: await PrefsManager.getUser(),
      title: getChatsCommand,
    );
    await ClientManager.sendMessage(msg);

    ClientManager.chatController.stream.listen((msg) {
      final chat = ChatModel.fromJson(msg.params as Map<String, dynamic>);
      chats.add(chat);
      chatsController.sink.add(chats);
    });
  }

  static final usersController = StreamController<List<UserModel>>.broadcast();
  static List<UserModel> users = [];
  static Future initUsersList() async {
    final msg = MessageModel(
      user: await PrefsManager.getUser(),
      title: chatsUsersListCommand,
    );
    await ClientManager.sendMessage(msg);

    ClientManager.chatUsersController.stream.listen((msg) {
      final user = UserModel.fromJson(msg.params as Map<String, dynamic>);
      users.add(user);
      usersController.sink.add(users);
    });
  }
}
