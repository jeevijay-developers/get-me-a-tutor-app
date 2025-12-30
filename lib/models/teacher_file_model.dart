class TeacherFile {
  final String? url;
  final String? filename;
  final String? mimeType;
  final int? size;

  TeacherFile({
    this.url,
    this.filename,
    this.mimeType,
    this.size,
  });

  factory TeacherFile.fromJson(Map<String, dynamic> json) {
    return TeacherFile(
      url: json['url'],
      filename: json['filename'],
      mimeType: json['mimeType'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'filename': filename,
      'mimeType': mimeType,
      'size': size,
    };
  }
}
