import 'package:conduit/managed_auth.dart';
import 'package:travel_planner_api/travel_planner_api.dart';

import 'controllers/heroes_controller.dart';
import 'controllers/user_controller.dart';

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
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      "postgres",
      "travel_planner_pg",
      "localhost",
      5432,
      "travel_planner_db",
    );

    context = ManagedContext(dataModel, persistentStore);
    authServer = AuthServer(ManagedAuthDelegate(context));
    CORSPolicy.defaultPolicy.allowedOrigins = ["localhost:8888"];
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

    router
        .route('/users/[:id]')
        .link(() => Authorizer(authServer))!
        .link(() => UserController(context, authServer));

    return router;
  }
}
