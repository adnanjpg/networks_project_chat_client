import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';

import '../managers/client_manager.dart';
import '../models/user_model.dart';

class UserFormScreen extends ConsumerStatefulWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size.zero,
      ),
      body: Column(
        children: [
          Text(
            'Welcome to my amazing app!',
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            'Please enter your name:',
            style: Theme.of(context).textTheme.headline5,
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
            onChanged: (val) {
              name = val;
              setState(() {});
            },
          ),
          if (name.length > 2)
            ElevatedButton(
              onPressed: () {
                final user = UserModel(name: name);
                ref.read(userProv.notifier).state = user;

                ClientManager.auth(ref);
              },
              child: const Text('Continue'),
            ),
        ],
      ),
    );
  }
}
