import 'package:conduit/conduit.dart';
import 'package:crypt/crypt.dart';

import '../models/user.dart';

class UserController extends ResourceController {
  UserController(this.context, this.authServer);

  final ManagedContext? context;
  final AuthServer? authServer;

  @Operation.get()
  Future<Response> getUsers() async {
    final query = Query<User>(context!);
    return Response.ok(await query.fetch());
  }

  @Operation.get('id')
  Future<Response> getUserById(@Bind.path('id') int id) async {
    final q = Query<User>(context!)..where((o) => o.id).equalTo(id);
    final user = await q.fetchOne();

    if (user == null) {
      return Response.notFound();
    }

    return Response.ok(user);
  }

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
    if (user.username == null || user.password == null) {
      return Response.badRequest(
        body: {"error": "username and password required."},
      );
    }

    final salt = Crypt.sha256("fa0c2731ac59ba01", rounds: 10000).toString();
    final hashedPassword = authServer!.hashPassword(user.password!, salt);

    final query = Query<User>(context!)
      ..values = user
      ..values.hashedPassword = hashedPassword
      ..values.salt = salt
      ..values.email = user.username
      ..values.firstName = user.firstName
      ..values.lastName = user.lastName;

    final u = await query.insert();
    final token = await authServer!.authenticate(
      u.username,
      query.values.password,
      request!.authorization!.credentials!.username,
      request!.authorization!.credentials!.password,
    );

    return AuthController.tokenResponse(token);
  }
}
