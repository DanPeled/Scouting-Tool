// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:http/http.dart' as http;

void main() async {
  const String tbaAPIKey =
      "fHNgYvUmzk3iawp0SC8XCIzePCWIE4kbZWMn6ypsL7VZ5NclTgcy9v0lbgXECA7E"; // example value, replace to use in your own project

  File jsonFile = File("matches.json");

  if (!jsonFile.existsSync()) {
    jsonFile.createSync(recursive: true);
  }

  var (redAlliance, blueAlliance) = await getEventTeams("2025isde3", tbaAPIKey);

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

Future<(Map<int, List<String>>, Map<int, List<String>>)> getEventTeams(
    String eventKey, String tbaApiKey) async {
  const String apiUrl = 'https://www.thebluealliance.com/api/v3';

  final response = await http.get(
      Uri.parse("$apiUrl/event/$eventKey/matches/simple"),
      headers: {'X-TBA-Auth-Key': tbaApiKey});

  final jsonResponse = jsonDecode(response.body);

  if (jsonResponse.length == 0) {
    throw ArgumentError(
        "Error while getting data from https://www.thebluealliance.com/api/v3");
  }

  Map<int, List<String>> redAlliance = {};
  Map<int, List<String>> blueAlliance = {};

  if (jsonResponse is List<dynamic>) {
    for (var match in jsonResponse) {
      final alliancesObjects = match["alliances"];
      List<String> currentGameRed = [];
      List<String> currentGameBlue = [];

      for (var teamKey in alliancesObjects["red"]["team_keys"]) {
        currentGameRed
            .add(teamKey.toString().substring(3)); // remove the frc prefix
      }
      for (var teamKey in alliancesObjects["blue"]["team_keys"]) {
        currentGameBlue
            .add(teamKey.toString().substring(3)); // remove the frc prefix
      }

      redAlliance[match["match_number"] as int] = currentGameRed;
      blueAlliance[match["match_number"] as int] = currentGameBlue;
    }
  }
  // print(jsonResponse);
  return (
    redAlliance,
    blueAlliance,
  );
}

String prettyJson(dynamic json) {
  var spaces = ' ' * 4;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}
