import 'dart:io';

import 'package:conduit/conduit.dart';

class SuccessController extends ResourceController {
  SuccessController(this.context, this.authServer);

  final ManagedContext? context;
  final AuthServer? authServer;

  @Operation.get()
  Future<Response> getSuccessPage() async {
    final file = File("lib/web/success.html");
    return Response.ok(file.openRead())
      ..encodeBody = false
      ..contentType = ContentType.html;
  }
}
