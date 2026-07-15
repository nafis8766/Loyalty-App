class User {
  String username;
  String password;
  String role;
  int loyaltyPoints;
  String? name;
  String? phoneNumber;

  User({
    required this.username,
    required this.password,
    required this.role,
    this.loyaltyPoints = 0,
    this.name,
    this.phoneNumber,
  });
}