import 'user_model.dart';

class ChatModel {
  final String id;
  final List<UserModel> users;
  String? title;

  ChatModel({
    required this.id,
    required this.users,
    this.title,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    /// json.users is a list of ids
    return ChatModel(
      id: json['id'],
      users: json['users']
              ?.map<UserModel>((user) => UserModel.fromJson(user))
              .toList() ??
          [],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users': users.map((user) => user.toJson()).toList(),
      'title': title,
    };
  }
}
