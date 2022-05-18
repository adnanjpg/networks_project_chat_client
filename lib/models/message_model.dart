import 'dart:convert';

import '../utils/enums/status_codes.dart';
import 'user_model.dart';

class MessageModel {
  UserModel? user;
  String? title;
  Map<String, dynamic>? params;
  StatusCode? status;

  MessageModel({
    this.user,
    this.title,
    this.params,
    this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      title: json['title'],
      params: json['params'],
      status: json['status'] != null ? StatusCode.values[json['status']] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'title': title,
      'params': params,
      'status': status?.index,
    };
  }

  String toJsonStr() => json.encode(toJson());
}
