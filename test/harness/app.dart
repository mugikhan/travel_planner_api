import 'package:travel_planner_api/travel_planner_api.dart';
import 'package:conduit_test/conduit_test.dart';

export 'package:travel_planner_api/travel_planner_api.dart';
export 'package:conduit_test/conduit_test.dart';
export 'package:test/test.dart';
export 'package:conduit/conduit.dart';

/// A testing harness for travel_planner_api.
///
/// A harness for testing an conduit application. Example test file:
///
///         void main() {
///           Harness harness = Harness()..install();
///
///           test("GET /path returns 200", () async {
///             final response = await harness.agent.get("/path");
///             expectResponse(response, 200);
///           });
///         }
///
class Harness extends TestHarness<TravelPlannerApiChannel> {
  @override
  Future onSetUp() async {}

  @override
  Future onTearDown() async {}
}
