class JobModel {
  final String id;
  final String title;
  final String? description;
  final List<String> subjects;
  final String? classRange;
  final int? salary;
  final String? location;
  final String jobType;
  final DateTime? deadline;
  final String status;
  final DateTime createdAt;
  final String postedByRole;

  JobModel({
    required this.id,
    required this.title,
    this.description,
    required this.subjects,
    this.classRange,
    this.salary,
    this.location,
    required this.jobType,
    this.deadline,
    required this.status,
    required this.createdAt,
    required this.postedByRole,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      subjects: List<String>.from(json['subjects'] ?? []),
      classRange: json['classRange'],
      salary: json['salary'],
      location: json['location'],
      jobType: json['jobType'] ?? 'full-time',
      deadline:
      json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      status: json['status'] ?? 'draft',
      createdAt: DateTime.parse(json['createdAt']),
      postedByRole: json['postedByRole'] ?? 'institute',
    );
  }
  JobModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? subjects,
    String? classRange,
    int? salary,
    String? location,
    String? jobType,
    DateTime? deadline,
    String? status,
    DateTime? createdAt,
    String? postedByRole,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subjects: subjects ?? this.subjects,
      classRange: classRange ?? this.classRange,
      salary: salary ?? this.salary,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      postedByRole: postedByRole ?? this.postedByRole,
    );
  }

}
