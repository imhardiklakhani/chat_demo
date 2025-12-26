import '../../../../core/constants/app_strings.dart';

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final bool isOnline;
  final String lastActive;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.isOnline,
    required this.lastActive,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return (f + l).toUpperCase();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      imageUrl: json['image'] ?? '',
      isOnline: _randomOnline(),
      lastActive: _randomLastActive(),
    );
  }

  static bool _randomOnline() {
    return DateTime.now().millisecondsSinceEpoch % 2 == 0;
  }

  static String _randomLastActive() {
    final values = AppStrings.userLastActiveOptions;
    return values[
      DateTime.now().millisecondsSinceEpoch % values.length
    ];
  }
}
