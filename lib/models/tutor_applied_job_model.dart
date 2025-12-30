class TutorAppliedJobModel {
  final String applicationId;
  final String status; // applied / shortlisted / rejected / selected
  final DateTime appliedAt;

  // Job details
  final String jobId;
  final String title;
  final List<String> subjects;
  final String? location;
  final String jobType;
  final int? salary;

  TutorAppliedJobModel({
    required this.applicationId,
    required this.status,
    required this.appliedAt,
    required this.jobId,
    required this.title,
    required this.subjects,
    this.location,
    required this.jobType,
    this.salary,
  });

  factory TutorAppliedJobModel.fromJson(Map<String, dynamic> json) {
    final job = json['job'];

    return TutorAppliedJobModel(
      applicationId: json['_id'],
      status: json['status'] ?? 'applied',
      appliedAt: DateTime.parse(json['createdAt']),

      jobId: job['_id'],
      title: job['title'],
      subjects: List<String>.from(job['subjects'] ?? []),
      location: job['location'],
      jobType: job['jobType'],
      salary: job['salary'],
    );
  }
}
