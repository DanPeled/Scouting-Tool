// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:scouting_site/services/scouting/helper_methods.dart';

void main() async {
  const String tbaAPIKey =
      "<APIKEY>"; // example value, replace to use in your own project

  File jsonFile = File("matches.json");

  if (!jsonFile.existsSync()) {
    jsonFile.createSync(recursive: true);
  }

  var (redAlliance, blueAlliance) = await getEventTeams("2025isde1", tbaAPIKey);

  Map<String, dynamic> blueJson =
      blueAlliance.map((key, value) => MapEntry(key.toString(), value));
  Map<String, dynamic> redJson =
      redAlliance.map((key, value) => MapEntry(key.toString(), value));

  jsonFile.writeAsStringSync(jsonEncode({
    "blue": blueJson,
    "red": redJson,
  }));

  print("Generated matches.json successfuly!");
}
