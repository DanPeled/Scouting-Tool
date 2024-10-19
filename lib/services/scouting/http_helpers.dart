// Package imports:
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<(Map<int, List<String>>, Map<int, List<String>>)> getTBAEventTeams(
    String eventKey, String tbaApiKey) async {
  const String apiUrl = 'https://www.thebluealliance.com/api/v3';

  final response = await http.get(
      Uri.parse("$apiUrl/event/$eventKey/matches/simple"),
      headers: {'X-TBA-Auth-Key': tbaApiKey});

  final jsonResponse = jsonDecode(response.body);

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

Future<(Map<int, List<String>>, Map<int, List<String>>)> getTOAEventTeams(
    String eventKey, String tbaApiKey) async {
  const String apiUrl = 'https://www.thebluealliance.com/api/v3';

  final response = await http.get(
      Uri.parse("$apiUrl/event/$eventKey/matches/simple"),
      headers: {'X-TBA-Auth-Key': tbaApiKey});

  final jsonResponse = jsonDecode(response.body);

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
