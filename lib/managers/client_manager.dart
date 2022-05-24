import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../utils/command_consts.dart';
import '../utils/consts.dart';
import 'package:web_socket_channel/io.dart';

import '../main.dart';
import '../models/user_model.dart';
import 'chat_manager.dart';

abstract class ClientManager {
  static IOWebSocketChannel? _ch;

  static String get _wsUrl {
    return 'ws://$ip:$port';
  }

  static Uri get _wsUri => Uri.parse(_wsUrl);
  static StreamSubscription? _subscription;

  static StreamController<MessageModel> chatMessagesController =
      StreamController.broadcast();
  static StreamController<MessageModel> chatUsersController =
      StreamController.broadcast();

  static void setListener(WidgetRef ref) {
    _subscription ??= channel.stream.listen(
      (event) {
        final msg = MessageModel.fromJson(json.decode(event));

        if (msg.title == sendMessageCommand) {
          chatMessagesController.sink.add(msg);
          return;
        }

        if (msg.title == chatsUsersListCommand) {
          chatUsersController.sink.add(msg);
          return;
        }

        if (msg.title == authCommand) {
          final prms = msg.params;
          if (prms == null || prms.isEmpty) {
            return;
          }
          final user = UserModel.fromJson(prms);

          ref.read(userProv.notifier).state = user;
        }
      },
    );

    ChatManager.initChatMessagesList(ref);
    ChatManager.initUsersList(ref);
  }

  static void dispose() {
    _subscription?.cancel();
    _ch?.sink.close();
  }

  static IOWebSocketChannel get _channel {
    _ch ??= IOWebSocketChannel.connect(_wsUri);

    return _ch!;
  }

  static IOWebSocketChannel get channel => _channel;

  static Future<void> auth(WidgetRef ref) async {
    final user = ref.watch(userProv) ?? UserModel();

    final msg = MessageModel(
      title: authCommand,
      params: user.toJson(),
    );

    await sendMessage(msg);
  }

  static Future<void> sendMessage(MessageModel msg) async {
    channel.sink.add(msg.toJsonStr());
  }
}
