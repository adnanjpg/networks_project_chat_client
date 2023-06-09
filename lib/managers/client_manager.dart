import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networks_project_chat_client/provs/chat_names_prov.dart';
import '../models/message_model.dart';
import '../utils/command_consts.dart';
import '../utils/consts.dart';
import 'package:web_socket_channel/io.dart';

import '../main.dart';
import '../models/user_model.dart';
import 'chat_manager.dart';

enum ClientType { ec2, ecs }

abstract class ClientManager {
  static IOWebSocketChannel? _ch;

  static const ClientType _clientType = ClientType.ecs;

  static String get _selectedUrl => _clientType == ClientType.ec2
      ? _wsEc2Url
      : _clientType == ClientType.ecs
          ? _wsEcsUrl
          : throw Exception('Invalid client type');

  static String get _wsEc2Url {
    return 'ws://54.144.97.43:49160';
  }

  static String get _wsEcsUrl {
    return 'ws://54.156.91.141:8080';
  }

  static Uri get _wsUri => Uri.parse(_selectedUrl);
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
        if (msg.title == renameChatCommand) {
          final prms = msg.params;
          if (prms == null || prms.isEmpty) {
            return;
          }

          final String? title = prms['title'];
          final List<String> recievers = (prms['recievers'] as List)
              .map(
                (e) => e.toString(),
              )
              .toList();

          if (title == null || title.isEmpty) {
            return;
          }

          ref.read(chatNamesProv.notifier).assign(recievers, title);
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
    try {
      channel.sink.add(msg.toJsonStr());
    } catch (e) {
      print(e);
    }
  }
}
