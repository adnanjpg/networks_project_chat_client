import 'package:networks_project_chat_client/models/chat_model.dart';
import 'package:riverpod/riverpod.dart';

final currentChatProv = StateProvider<ChatModel?>((_) => null);
