import 'dart:io';

import 'package:conduit/conduit.dart';

import '../models/response/error/error.dart';
import '../models/response/success/success.dart';
import '../models/user.dart';

class RegisterController extends ResourceController {
  RegisterController(this.context, this.authServer);

  final ManagedContext? context;
  final AuthServer? authServer;

  @Operation.get()
  Future<Response> getRegisterPage() async {
    final file = File("lib/web/register.html");
    return Response.ok(file.openRead())
      ..encodeBody = false
      ..contentType = ContentType.html
      ..cachePolicy = const CachePolicy(preventCaching: true);
  }

  @Operation.post()
  Future<Response> createUser(@Bind.body() User user) async {
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
    } else if (user.firstName == null || user.lastName == null) {
      return Response.badRequest(
        body: {
          "error": const ErrorResponse(
            type: "missing required fields",
            message: "First name and last name is required.",
            code: 400,
          ).toJson(),
        },
      );
    }

    final salt = generateRandomSalt();
    final hashedPassword = authServer!.hashPassword(user.password!, salt);

    final query = Query<User>(context!)
      ..values = user
      ..values.hashedPassword = hashedPassword
      ..values.salt = salt
      ..values.email = user.username
      ..values.firstName = user.firstName
      ..values.lastName = user.lastName;

    try {
      final u = await query.insert();
      return Response.ok(
        SuccessResponse(
          data: {},
          message: "Successfully registered ${u.username}",
        ),
      );
    } catch (error) {
      if (error is QueryException) {
        return Response.badRequest(
          body: const ErrorResponse(
            type: "entity already exists",
            message: "That email address is already registered.",
            code: 400,
          ),
        );
      } else {
        return Response.badRequest(
          body: const ErrorResponse(
            type: "unknown",
            message: "Something went wrong.",
            code: 400,
          ),
        );
      }
    }
  }
}
