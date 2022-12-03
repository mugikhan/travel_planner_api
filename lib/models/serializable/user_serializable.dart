import 'package:conduit/conduit.dart';

class User extends Serializable {
  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  String email;
  String firstName;
  String lastName;
  String? profilePicture;

  @override
  Map<String, dynamic> asMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "profilePicture": profilePicture,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    firstName = object['firstName'] as String;
    lastName = object['lastName'] as String;
    email = object['email'] as String;
    profilePicture = object['profilePicture'] as String;
  }
}
