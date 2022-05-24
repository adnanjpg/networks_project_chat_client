class AttachmentModel {
  final String id;
  final String? url;
  final String? path;

  const AttachmentModel({
    required this.id,
    this.url,
    this.path,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    /// json.users is a list of ids
    return AttachmentModel(
      id: json['id'],
      url: json['url'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'path': path,
    };
  }
}
