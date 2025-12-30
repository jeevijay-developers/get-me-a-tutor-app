class ExpectedSalary {
  final int? min;
  final int? max;

  ExpectedSalary({this.min, this.max});

  factory ExpectedSalary.fromJson(Map<String, dynamic> json) {
    return ExpectedSalary(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
