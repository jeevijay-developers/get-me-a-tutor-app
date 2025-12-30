class InstitutionAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? pincode;

  InstitutionAddress({
    this.street,
    this.city,
    this.state,
    this.pincode,
  });

  factory InstitutionAddress.fromJson(Map<String, dynamic> json) {
    return InstitutionAddress(
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
