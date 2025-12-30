import 'package:get_me_a_tutor/import_export.dart';

class TeacherModel {
  final String id;
  final String userId;

  final String? bio;
  final int experienceYears;

  final List<String> subjects;
  final List<int> classes;
  final List<String> languages;

  final String? city;

  final ExpectedSalary? expectedSalary;

  final String? availability;

  final TeacherFile? resume;
  final TeacherFile? photo;

  final String? demoVideoUrl;

  final bool isPublic;
  final bool isVerified;
  final bool isActive;
  final int? credits;
  final int? jobsApplied;
  final int? rating;
  final int? examsPassed;
  final List<String> tags;

  TeacherModel({
     this.jobsApplied = 0,
     this.credits = 500,
     this.rating = 0,
     this.examsPassed = 0,
    required this.id,
    required this.userId,
    this.bio,
    this.experienceYears = 0,
    this.subjects = const [],
    this.classes = const [],
    this.languages = const [],
    this.city,
    this.expectedSalary,
    this.availability,
    this.resume,
    this.photo,
    this.demoVideoUrl,
    this.isPublic = true,
    this.isVerified = false,
    this.isActive = true,
    this.tags = const [],
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      credits: json['credits'] ?? 0,
      jobsApplied: json['jobsApplied'] ?? 0,
      examsPassed: json['examsPassed'] ?? 0,
      rating: json['rating'] ?? 0,
      bio: json['bio'],
      experienceYears: json['experienceYears'] ?? 0,

      subjects:
      (json['subjects'] as List?)?.map((e) => e.toString()).toList() ?? [],

      classes:
      (json['classes'] as List?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList() ?? [],

      languages:
      (json['languages'] as List?)?.map((e) => e.toString()).toList() ?? [],

      city: json['city'],

      expectedSalary: json['expectedSalary'] != null
          ? ExpectedSalary.fromJson(json['expectedSalary'])
          : null,

      availability: json['availability'],

      resume: json['resume'] != null
          ? TeacherFile.fromJson(json['resume'])
          : null,

      photo: json['photo'] != null
          ? TeacherFile.fromJson(json['photo'])
          : null,

      demoVideoUrl: json['demoVideoUrl'],

      isPublic: json['isPublic'] ?? true,
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,

      tags:
      (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'experienceYears': experienceYears,
      'subjects': subjects,
      'classes': classes,
      'languages': languages,
      'city': city,
      'expectedSalary': expectedSalary?.toJson(),
      'availability': availability,
      'resume': resume?.toJson(),
      'photo': photo?.toJson(),
      'demoVideoUrl': demoVideoUrl,
      'isPublic': isPublic,
      'tags': tags,
      'credits': credits,
      'jobsApplied': jobsApplied,
      'rating': rating,
      'examsPassed':examsPassed,
    };
  }
}
