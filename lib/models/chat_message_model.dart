import 'attachment_model.dart';

class ChatMessageModel {
  final String? id;
  final List<String> recieversIds;
  final String senderId;

  final String message;

  final List<AttachmentModel>? attachments;

  const ChatMessageModel({
    this.id,
    required this.message,
    required this.senderId,
    required this.recieversIds,
    this.attachments,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      recieversIds: List<String>.from(json['recieversIds']),
      message: json['message'],
      attachments: json['attachments']
          .map<AttachmentModel>((json) => AttachmentModel.fromJson(json))
          .toList(),
      senderId: json['senderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recieversIds': recieversIds,
      'message': message,
      'attachments': attachments?.map((a) => a.toJson()),
      'senderId': senderId,
    };
  }
}
