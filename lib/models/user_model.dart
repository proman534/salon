class UserModel {
  final int id;
  final String username;
  final String password;
  final String role;  // 'customer' or 'salon_owner'
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String dateOfBirth;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    };
  }
}
