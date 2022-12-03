import 'package:conduit/conduit.dart';

import '../models/response/error/error.dart';
import '../models/user.dart';

class LoginController extends ResourceController {
  LoginController(this.context, this.authServer);

  final ManagedContext? context;
  final AuthServer? authServer;

  @Operation.post()
  Future<Response> login(@Bind.body() User user) async {
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
