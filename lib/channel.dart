import 'package:conduit/managed_auth.dart';
import 'package:travel_planner_api/controllers/register_controller.dart';
import 'package:travel_planner_api/controllers/success_controller.dart';
import 'package:travel_planner_api/models/user.dart';
import 'package:travel_planner_api/travel_planner_api.dart';

import 'configuration.dart';
import 'controllers/heroes_controller.dart';
import 'controllers/user_controller.dart';
import 'web/login.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class TravelPlannerApiChannel extends ApplicationChannel {
  ManagedContext? context;
  AuthServer? authServer;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final config =
        AppConfiguration.fromFile(File(options!.configurationFilePath!));
    final db = config.database;
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      db.username,
      db.password,
      db.host,
      db.port,
      db.databaseName,
    );

    context = ManagedContext(dataModel, persistentStore);
    final delegate = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(delegate);
    CORSPolicy.defaultPolicy.allowedOrigins = ["localhost", "127.0.0.1"];
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/heroes').link(() => HeroesController());

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://conduit.io/docs/http/request_controller/
    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    router.route('/auth/token').link(() => AuthController(authServer));

    router.route("/auth/code").link(() => AuthRedirectController(
          authServer,
          delegate: RenderDelegate(),
        ));

    router
        .route('/register')
        .link(() => RegisterController(context, authServer));

    router
        .route('/users/[:id]')
        .link(() => Authorizer.bearer(authServer))!
        .link(() => UserController(context, authServer));

    //.link(() => Authorizer(authServer))!

    return router;
  }
}

class RenderDelegate implements AuthRedirectControllerDelegate {
  @override
  Future<String?> render(
    AuthRedirectController forController,
    Uri requestUri,
    String? responseType,
    String? clientID,
    String? state,
    String? scope,
  ) async {
    final html = HtmlPages.loginPage(requestUri, responseType, clientID, state);

    return html;
  }
}
