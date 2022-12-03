import 'package:conduit/conduit.dart';

class AppConfiguration extends Configuration {
  AppConfiguration.fromFile(super.file) : super.fromFile();

  late DatabaseConfiguration database;
}
