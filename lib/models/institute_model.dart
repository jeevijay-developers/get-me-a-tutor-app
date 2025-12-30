import 'package:get_me_a_tutor/import_export.dart';
class InstitutionModel {
  final String id;
  final String owner;

  final String institutionName;
  final String institutionType;
  final String? about;

  final String? email;
  final String? phone;
  final String? website;

  final InstitutionAddress? address;

  final String? logo;
  final List<String> galleryImages;

  final bool isVerified;
  final bool isActive;
  final int credits;
  final int tutorsHired;
  final int jobsPosted;
  InstitutionModel({
    required this.id,
    required this.owner,
    required this.institutionName,
    required this.institutionType,
    this.about,
    this.email,
    this.phone,
    this.website,
    this.address,
    this.logo,
    this.galleryImages = const [],
    this.isVerified = false,
    this.isActive = true,
    this.credits = 500,
    this.tutorsHired = 0,
    this.jobsPosted = 0,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      owner: json['owner']?.toString() ?? '',

      institutionName: json['institutionName'] ?? '',
      institutionType: json['institutionType'] ?? '',
      about: json['about'],

      email: json['email'],
      phone: json['phone'],
      website: json['website'],
      credits: json['credits'],
      tutorsHired: json['tutorsHired'],
      jobsPosted: json['jobsPosted'],
      address: json['address'] != null
          ? InstitutionAddress.fromJson(json['address'])
          : null,

      logo: json['logo'],
      galleryImages:
      (json['galleryImages'] as List?)?.map((e) => e.toString()).toList() ??
          [],

      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institutionName': institutionName,
      'institutionType': institutionType,
      'about': about,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address?.toJson(),
      'logo': logo,
      'galleryImages': galleryImages,
      'credits': credits,
      'jobsPosted': jobsPosted,
      'tutorsHired': tutorsHired,
    };
  }
  InstitutionModel copyWith({
    String? id,
    String? owner,
    String? institutionName,
    String? institutionType,
    String? about,
    String? email,
    String? phone,
    String? website,
    InstitutionAddress? address,
    String? logo,
    List<String>? galleryImages,
    bool? isVerified,
    bool? isActive,
    int? credits,
    int? tutorsHired,
    int? jobsPosted,
  }) {
    return InstitutionModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      institutionName: institutionName ?? this.institutionName,
      institutionType: institutionType ?? this.institutionType,
      about: about ?? this.about,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      galleryImages: galleryImages ?? this.galleryImages,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      credits: credits ?? this.credits,
      tutorsHired: tutorsHired ?? this.tutorsHired,
      jobsPosted: jobsPosted ?? this.jobsPosted,
    );
  }

}
