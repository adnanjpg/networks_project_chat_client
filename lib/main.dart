import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networks_project_chat_client/app.dart';
import 'package:networks_project_chat_client/models/user_model.dart';
import 'package:riverpod/riverpod.dart';

import 'managers/prefs_manager.dart';

UserModel? initUser;

final userProv = StateProvider<UserModel?>((_) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initUser = await PrefsManager.getUser();

  runApp(const ProviderScope(child: App()));
}
