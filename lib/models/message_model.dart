import 'dart:convert';

import '../utils/enums/status_codes.dart';

class MessageModel {
  String? title;
  Map<String, dynamic>? params;
  StatusCode? status;

  MessageModel({
    this.title,
    this.params,
    this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      title: json['title'],
      params: json['params'],
      status: json['status'] != null ? StatusCode.values[json['status']] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'params': params,
      'status': status?.index,
    };
  }

  String toJsonStr() => json.encode(toJson());
}
