import 'dart:async';

import 'package:networks_project_chat_client/managers/client_manager.dart';
import 'package:networks_project_chat_client/models/chat_model.dart';
import 'package:networks_project_chat_client/models/message_model.dart';
import 'package:networks_project_chat_client/models/user_model.dart';

import '../utils/command_consts.dart';
import 'prefs_manager.dart';

abstract class ChatManager {
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
