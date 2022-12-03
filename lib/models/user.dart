import 'package:conduit/managed_auth.dart';
import 'package:travel_planner_api/models/enums/verification_state.dart';
import 'package:travel_planner_api/travel_planner_api.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String? password;
}

class _User extends ResourceOwnerTableDefinition {
  @Column(unique: true)
  String? email;
  @Column()
  String? firstName;
  @Column()
  String? lastName;
  @Column(nullable: true)
  String? profilePicture;

  Verification? verification;
}

class Verification extends ManagedObject<_Verification>
    implements _Verification {}

class _Verification {
  @primaryKey
  int? id;
  @Column(unique: true)
  String? code;
  @Column(defaultValue: "'unverified'")
  VerificationState? verificationState;

  @Relate(#verification, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
}
