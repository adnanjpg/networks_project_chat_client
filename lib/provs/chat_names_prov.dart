import 'package:riverpod/riverpod.dart';

import '../models/user_model.dart';

final chatNamesProv = StateProvider<Map<List<UserModel>, String>>(
  (_) => {},
);
