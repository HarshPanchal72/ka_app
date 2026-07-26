class LoginPassModel {
  final String userId;
  final String mobile;
  final String userName;
  final String city;
  final String branch;
  final String email;
  final String orange_id;
  final String department;
  final String designation;
  final String company;
  final String reporting_man;

  LoginPassModel({
    required this.userName,
    required this.mobile, required this.city, required this.branch, required this.email, required this.orange_id, required this.department, required this.designation, required this.company, required this.reporting_man, required this.userId,
  });

  factory LoginPassModel.fromJson(Map<String, dynamic> json) {
    return LoginPassModel(
      userName: json['userName'],
      mobile: json['mobile'],
      city: json['city'],
      branch: json['branch'],
      email: json['email'],
      orange_id: json['orange_id'],
      department: json['department'],
      designation: json['designation'],
      company: json['company'],
      reporting_man: json['reporting_man'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'mobile': mobile,
      'city': city,
      'branch': branch,
      'email': email,
      'orange_id': orange_id,
      'department': department,
      'designation': designation,
      'company': company,
      'reporting_man': reporting_man,
    };
  }
}