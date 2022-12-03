import 'package:conduit/conduit.dart';
import 'package:travel_planner_api/models/enums/verification_state.dart';

class User extends Serializable {
  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.verificationState,
  });

  String email;
  String firstName;
  String lastName;
  String? profilePicture;

  VerificationState? verificationState;

  @override
  Map<String, dynamic> asMap() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "profilePicture": profilePicture,
      "verification": verificationState,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    firstName = object['firstName'] as String;
    lastName = object['lastName'] as String;
    email = object['email'] as String;
    profilePicture = object['profilePicture'] as String;
    final String _verificationState = object['verificationState'] as String;
    verificationState = VerificationState.values.byName(_verificationState);
  }
}
