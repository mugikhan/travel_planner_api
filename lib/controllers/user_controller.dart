import 'package:conduit/conduit.dart';
import 'package:conduit/managed_auth.dart';

import '../models/response/error/error.dart';
import '../models/response/success/success.dart';
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
  Future<Response> loginUser(@Bind.body() User user) async {
    if (user.password == null || user.username == null) {
      return Response.badRequest(
        body: {
          "error": const ErrorResponse(
            type: "missing required fields",
            message: "Email and password is required.",
            code: 400,
          ).toJson(),
        },
      );
    }

    final query = Query<User>(context!)
      ..where((u) => u.email).equalTo(user.email);

    final u = await query.fetchOne();

    if (u == null) {
      return Response.badRequest(
        body: {
          "error": ErrorResponse(
            type: "invalid data",
            message: "${user.email} is not registered",
            code: 400,
          ).toJson(),
        },
      );
    }

    // Authorize token
    final token = await authServer!.authenticate(
      u.username,
      query.values.password,
      request!.authorization!.credentials!.username,
      request!.authorization!.credentials!.password,
    );

    return AuthController.tokenResponse(token);
  }
}
