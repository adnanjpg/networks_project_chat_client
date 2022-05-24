import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_message_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utils/command_consts.dart';
import 'client_manager.dart';

abstract class ChatManager {
  static final usersProv = StateProvider<List<UserModel>>((_) => []);
  static List<UserModel> users = [];
  static StreamSubscription<MessageModel>? _usersLis;
  static Future initUsersList(WidgetRef ref) async {
    _usersLis?.cancel();
    _usersLis = ClientManager.chatUsersController.stream.listen(
      (msg) {
        final params = msg.params;
        if (params == null) {
          return;
        }
        final us = params['users'];
        // it is okay for users to be empty,
        // in case server announcing that
        // the only user connected has
        // disconnected
        if (us == null) {
          return;
        }
        users = [];
        for (var u in us) {
          final user = UserModel.fromJson(u);
          users.add(user);
        }
        ref.read(usersProv.notifier).state = List.from(users);
      },
    );
  }

  static final chatMessagesProv =
      StateProvider<List<ChatMessageModel>>((_) => []);
  static List<ChatMessageModel> chatMessages = [];
  static StreamSubscription<MessageModel>? _msgsLis;
  static Future initChatMessagesList(WidgetRef ref) async {
    _msgsLis?.cancel();
    _msgsLis = ClientManager.chatMessagesController.stream.listen(
      (msg) {
        final params = msg.params;
        if (params == null) {
          return;
        }
        final chatMsg = ChatMessageModel.fromJson(params);
        chatMessages.add(chatMsg);

        ref.read(chatMessagesProv.notifier).state = List.from(chatMessages);
      },
    );
  }

  static void sendMessage(ChatMessageModel chatMsg) {
    final msg = MessageModel(
      title: sendMessageCommand,
      params: chatMsg.toJson(),
    );

    ClientManager.sendMessage(msg);
  }
}
