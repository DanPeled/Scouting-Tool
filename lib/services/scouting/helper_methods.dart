// Project imports:
import 'package:scouting_site/services/scouting/form_data.dart';

List<FormData> handleSearchQuery(
    List<FormData> forms, Map<String, dynamic> searchQuery) {
  if (searchQuery.isEmpty) return forms;

  List<FormData> modifiedForms = List.from(forms);
  searchQuery.forEach((key, value) {
    modifiedForms = forms.where((form) {
      try {
        switch (key) {
          case "game":
            return form.game == int.parse(value);
          case "score":
            return form.score == num.parse(value);
          case "team":
            return extractNumber(form.scoutedTeam ?? "") == int.parse(value);
          case "scouter":
            return form.scouter == value;
        }
      } catch (_) {}
      if (form.pages
          .map((page) => page.pageName.toLowerCase())
          .contains(key.toLowerCase())) {
        return form.pages
                .firstWhere(
                    (page) => page.pageName.toLowerCase() == key.toLowerCase())
                .score ==
            num.parse(value);
      }
      return true;
    }).toList();
  });

  return modifiedForms;
}

int extractNumber(String team) {
  if (int.tryParse(team) != null) {
    return int.parse(team);
  }
  // Split by the '#' character and parse the number

  List<String> parts = team.split('#');
  if (parts.length > 1) {
    return int.tryParse(parts[1].trim()) ?? 0;
  }

  return 0; // Return 0 if the format is incorrect or parsing fails
}

Map<String, dynamic> evaluateSearchQuery(String text) {
  // Split the input string into pairs
  List<String> pairs = text.split(',');

  // Create a map to store the key-value pairs
  Map<String, String> map = {};

  // Process each pair
  for (String pair in pairs) {
    // Split each pair into key and value
    List<String> parts = pair.split(':');

    if (parts.length == 2) {
      // Trim spaces from the key and value
      String key = parts[0].trim();
      String value = parts[1].trim();

      // Store the key-value pair in the map
      map[key] = value;
    } else {
      return {};
    }
  }

  return map;
}

String getNumAsFixed(num number) {
  if (number is int) return number.toString();

  return number.toStringAsFixed(2);
}
