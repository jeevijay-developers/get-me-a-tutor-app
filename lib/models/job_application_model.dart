class JobApplicationModel {
  final String id;
  final String tutorName;
  final String tutorUserId;
  final String jobTitle;
  final String? tutorPhoto;
  final String status;
  final DateTime createdAt;

  JobApplicationModel({
    required this.id,
    this.tutorPhoto,
    required this.tutorUserId,
    required this.tutorName,
    required this.jobTitle,
    required this.status,
    required this.createdAt,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      id: json['_id'],
      tutorUserId: json['tutor']?['_id']??'',
      tutorName: json['tutor']?['name'] ?? 'Tutor',
      tutorPhoto: json['tutor']?['photo']?['url'],
      jobTitle: json['job']?['title'] ?? 'Job',
      status: json['status'] ?? 'applied',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  JobApplicationModel copyWith({String? status}) {
    return JobApplicationModel(
      id: id,
      tutorName: tutorName,
      jobTitle: jobTitle,
      tutorPhoto: tutorPhoto,
      status: status ?? this.status,
      createdAt: createdAt, tutorUserId: tutorUserId,
    );
  }

}
