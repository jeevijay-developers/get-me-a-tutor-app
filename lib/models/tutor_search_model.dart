class TutorSearchModel {
  final String id;        // profileId
  final String userId;    // IMPORTANT
  final String bio;
  final String city;
  final List<String> subjects;
  final int experienceYears;
  final Map<String, dynamic>? expectedSalary;
  final bool isPublic;

  TutorSearchModel({
    required this.id,
    required this.userId,
    required this.bio,
    required this.city,
    required this.subjects,
    required this.experienceYears,
    required this.expectedSalary,
    required this.isPublic,
  });

  factory TutorSearchModel.fromJson(Map<String, dynamic> json) {
    return TutorSearchModel(
      id: json['_id'],
      userId: json['userId'], // ✅
      bio: json['bio'] ?? '',
      city: json['city'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []),
      experienceYears: json['experienceYears'] ?? 0,
      expectedSalary: json['expectedSalary'],
      isPublic: json['isPublic'] ?? false,
    );
  }
}
