import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'models/user_model.dart';

import 'managers/prefs_manager.dart';

UserModel? initUser;

final userProv = StateProvider<UserModel?>((_) => null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initUser = await PrefsManager.getUser();

  runApp(const ProviderScope(child: App()));
}
