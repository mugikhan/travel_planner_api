import 'package:travel_planner_api/travel_planner_api.dart';

Future main() async {
  final app = Application<TravelPlannerApiChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8888;

  await app.startOnCurrentIsolate();

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}