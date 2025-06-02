// User model to represent user data from backend
class User {
  final String userId;
  final String? firebaseUid;
  final String userEmail;
  final String userRole;
  final bool isRoleVerified;
  final String userFirstName;
  final String userLastName;
  final String userPhoneNumber;
  final String userAddress;
  final DateTime createUserDate;
  final DateTime userBirthDate;
  final String userProfilePicture;
  final bool userIsVerified;

  User({
    required this.userId,
    this.firebaseUid,
    required this.userEmail,
    required this.userRole,
    required this.isRoleVerified,
    required this.userFirstName,
    required this.userLastName,
    required this.userPhoneNumber,
    required this.userAddress,
    required this.createUserDate,
    required this.userBirthDate,
    required this.userProfilePicture,
    required this.userIsVerified,
  });

  // Factory method to create a User from JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      firebaseUid: json['firebaseUid'],
      userEmail: json['userEmail'] ?? '',
      userRole: json['userRole'] ?? '',
      isRoleVerified: json['isRoleVerified'] ?? false,
      userFirstName: json['userFirstName'] ?? '',
      userLastName: json['userLastName'] ?? '',
      userPhoneNumber: json['userPhoneNumber'] ?? '',
      userAddress: json['userAddress'] ?? '',
      createUserDate: DateTime.parse(
        json['createUserDate'] ?? DateTime.now().toIso8601String(),
      ),
      userBirthDate: DateTime.parse(
        json['userBirthDate'] ?? DateTime.now().toIso8601String(),
      ),
      userProfilePicture: json['userProfilePicture'] ?? '',
      userIsVerified: json['userIsVerified'] ?? false,
    );
  }
}
