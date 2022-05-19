import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networks_project_chat_client/managers/prefs_manager.dart';
import 'package:networks_project_chat_client/models/chat_model.dart';
import 'package:networks_project_chat_client/models/message_model.dart';
import 'package:networks_project_chat_client/utils/command_consts.dart';
import 'package:networks_project_chat_client/utils/consts.dart';
import 'package:web_socket_channel/io.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../utils/enums/status_codes.dart';

abstract class ClientManager {
  static IOWebSocketChannel? _ch;

  static String get _wsUrl {
    return 'ws://$ip:$port';
  }

  static Uri get _wsUri => Uri.parse(_wsUrl);
  static StreamSubscription? _subscription;

  static StreamController<MessageModel> authController = StreamController();
  static StreamController<MessageModel> chatController = StreamController();
  static StreamController<MessageModel> chatUsersController =
      StreamController();

  static void setListener() {
    _subscription ??= channel.stream.listen((event) {
      final msg = MessageModel.fromJson(json.decode(event));

      if (msg.title == authCommand) {
        final user = UserModel.fromJson(msg.params!);
        PrefsManager.setUser(user);
      }
      if (msg.title == chatsListCommand) {
        chatController.sink.add(msg);
      }
      if (msg.title == chatsUsersListCommand) {
        chatUsersController.sink.add(msg);
      }
    });
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
      user: user,
    );

    await sendMessage(msg);
  }

  static Future<void> sendMessage(MessageModel msg) async {
    channel.sink.add(msg.toJsonStr());
  }
}
