
class ParentAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? pincode;

  ParentAddress({
    this.street,
    this.city,
    this.state,
    this.pincode,
  });

  factory ParentAddress.fromJson(Map<String, dynamic> json) {
    return ParentAddress(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
    };
  }
}

class ParentModel {
  final String id;
  final String userId;

  final String name;
  final String? email;
  final String? phone;

  final String? city;
  final ParentAddress? address;

  final int credits;
  final int tutorsHired;
  final int jobsPosted;

  final bool isActive;

  ParentModel({
    required this.id,
    required this.userId,
    required this.name,
    this.email,
    this.phone,
    this.city,
    this.address,
    this.credits = 500,
    this.tutorsHired = 0,
    this.jobsPosted = 0,
    this.isActive = true,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      city: json['city'],
      address:
      json['address'] != null ? ParentAddress.fromJson(json['address']) : null,
      credits: json['credits'] ?? 500,
      tutorsHired: json['tutorsHired'] ?? 0,
      jobsPosted: json['jobsPosted'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'address': address?.toJson(),
    };
  }
}
