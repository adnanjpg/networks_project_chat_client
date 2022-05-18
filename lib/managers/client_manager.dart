import 'dart:convert';

import 'package:networks_project_chat_client/managers/prefs_manager.dart';
import 'package:networks_project_chat_client/models/message_model.dart';
import 'package:networks_project_chat_client/utils/command_consts.dart';
import 'package:networks_project_chat_client/utils/consts.dart';
import 'package:web_socket_channel/io.dart';

import '../models/user_model.dart';
import '../utils/enums/status_codes.dart';

abstract class ClientManager {
  static IOWebSocketChannel? _ch;

  static String get _wsUrl {
    return 'ws://$ip:$port';
  }

  static Uri get _wsUri => Uri.parse(_wsUrl);

  static IOWebSocketChannel get _channel {
    _ch ??= IOWebSocketChannel.connect(_wsUri);

    return _ch!;
  }

  static IOWebSocketChannel get channel => _channel;

  static Future<void> auth(String? name) async {
    final user = await PrefsManager.getUser() ?? UserModel();

    if (user.name == null) {
      assert(name != null);
      user.name = name;
    }

    final msg = MessageModel(
      title: authCommand,
      user: user,
    );

    channel.sink.add(msg.toJsonStr());

    channel.stream.listen((event) {
      final msg = MessageModel.fromJson(json.decode(event));

      print('Received message: $msg');
    });
  }
}
