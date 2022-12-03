import 'package:conduit/managed_auth.dart';
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
}
