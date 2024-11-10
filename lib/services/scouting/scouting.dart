// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:universal_html/html.dart' as html;

// Project imports:
import 'package:scouting_site/pages/form_page.dart';
import 'package:scouting_site/services/firebase/firebase_api.dart';
import 'package:scouting_site/services/localstorage.dart';
import 'package:scouting_site/services/scouting/form_data.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/question.dart';

class Scouting {
  static List<FormPageData> _pitPages = [];
  static List<FormPageData> _matchPages = [];

  static MatchesTeams _matchesTeamsPair = MatchesTeams({}, {});

  static List<BuildContext> _matchPagesContexts = [];

  static const String competitionName = "2024isos2";

  static int _currentPage = -1;

  static Future<void> _getFormQuestions() async {
    var (data, successful) = await DatabaseAPI.instance
        .downloadJson("form_questions", "${competitionName}_questions");

    if (successful) {
      _matchPages = Scouting.fromJson(jsonEncode(data["data"][0]));
      _pitPages = Scouting.fromJson(jsonEncode(data["data"][1]));
    }
  }

  static FormData data = FormData(
    pages: _matchPages,
    scouter: localStorage?.getString("scouter"),
    matchType: MatchType.normal,
  );

  static bool hasInternet = true;

  static bool isOnLastPage() {
    if (data.matchType == MatchType.pit) {
      return _currentPage >= _pitPages.length - 1;
    }
    return _currentPage >= _matchPages.length - 1;
  }

  static void _resetValues() {
    _currentPage = -1;
    _matchPagesContexts = [];
    data.game = null;
    data.scoutedTeam = null;

    for (FormPageData page in _matchPages) {
      for (Question question in page.questions) {
        question.answer = null;
      }
    }

    for (FormPageData page in _pitPages) {
      for (Question question in page.questions) {
        question.answer = null;
      }
    }
  }

  static void setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        hasInternet = false;
      } else {
        hasInternet = true;
      }
    });
  }

  static Future<void> initialize() async {
    setupConnectivityListener();
    _resetValues();
    await DatabaseAPI.instance.initialize();

    if (localStorage == null) {
      loadLocalStorage();
    }

    initializeData();
    await _getFormQuestions();
    await sendUnsentFormEntries();
    data = FormData(
      pages: _matchPages,
      scouter: localStorage?.getString("scouter"),
      matchType: MatchType.normal,
    );
    _matchesTeamsPair = await getEventTeamsFromJson();
  }

  static Future<MatchesTeams> getEventTeamsFromJson() async {
    const url = 'assets/matches.json';

    // Fetch the asset using an HTTP request
    final response = await html.HttpRequest.getString(url);

    return MatchesTeams.fromJson(jsonDecode(response));
  }

  static (Map<int, List<String>>, Map<int, List<String>>) matchesTeamsPair() =>
      (_matchesTeamsPair.redAlliance, _matchesTeamsPair.blueAlliance);

  static Future<void> sendUnsentFormEntries() async {
    List<String>? formsToSend = localStorage
        ?.getKeys()
        .where((key) => key.startsWith("scout_"))
        .toList();

    if (formsToSend != null) {
      for (String formName in formsToSend) {
        String textData = localStorage?.getString(formName) ?? "";

        if (textData.isNotEmpty) {
          Map<String, dynamic> jsonData = jsonDecode(textData);
          await sendData(jsonData, header: formName);
          await localStorage?.remove(formName);
        }
      }
    }
  }

  static int getPageCount() {
    if (data.matchType == MatchType.pit) {
      return _pitPages.length;
    }
    return _matchPages.length;
  }

  static FormPage generateCurrentPage() {
    if (data.matchType == MatchType.pit) {
      return FormPage(data: _pitPages[_currentPage]);
    } else {
      return FormPage(data: _matchPages[_currentPage]);
    }
  }

  static void advance(BuildContext context) {
    List<FormPageData> pages =
        data.matchType == MatchType.pit ? _pitPages : _matchPages;

    if (pages.length - 1 > _currentPage) {
      _currentPage++;

      _matchPagesContexts.add(context);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scouting.generateCurrentPage()));
    }
  }

  static bool _isIndexValid(int index) {
    return _matchPages.length - 1 > _currentPage;
  }

  static String getNextPageName() {
    if (data.matchType == MatchType.pit) {
      return (_isIndexValid(_currentPage + 1)
          ? _pitPages[_currentPage + 1].pageName
          : "Unknown");
    }
    return (_isIndexValid(_currentPage + 1)
        ? _matchPages[_currentPage + 1].pageName
        : "Unknown");
  }

  static void onPagePop() {
    _matchPagesContexts.removeAt(_currentPage);
    _currentPage--;
  }

  static int getCurrentPageNumber() {
    return _currentPage;
  }

  static Map<String, dynamic> toJson(List<FormPageData> pages, FormData? data) {
    List<Map<String, dynamic>> pagesJson =
        pages.map((page) => page.toJson()).toList();

    if (data != null) {
      return {
        'pages': pagesJson,
        'scouter': data.scouter,
        'match_type': data.matchType.name,
        'scouted_on': data.scoutedTeam,
        'game': data.game,
        'score': data.evaluate(),
      };
    } else {
      return {
        'pages': pagesJson,
      };
    }
  }

  static List<FormPageData> fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return fromJsonMap(jsonMap);
  }

  static List<FormPageData> fromJsonMap(Map<String, dynamic> jsonMap) {
    List<FormPageData> pages = (jsonMap['pages'] as List<dynamic>)
        .map((item) => FormPageData.fromJson(item as Map<String, dynamic>))
        .toList();

    return pages;
  }

  static Future<void> sendData(Map<String, dynamic> json,
      {String? header}) async {
    if (data.scoutedTeam == null) return;

    for (int i = 0; i < _matchPagesContexts.length; i++) {
      Navigator.pop(_matchPagesContexts[i]);
    }

    header ??= "${DateTime.now()} ${data.scouter ?? ""}";

    if (hasInternet) {
      DatabaseAPI.instance
          .uploadJson(json, 'scouting_$competitionName', header);
    } else {
      localStorage?.setString("scout_$header", jsonEncode(json));
    }

    _resetValues();
  }

  static void initializeData() {
    data.scouter = localStorage?.getString("scouter");
  }

  static List<FormPageData> getMatchPages() {
    return _matchPages;
  }

  static void setMatchPages(List<FormPageData> pages) {
    _matchPages = pages;
  }

  static void setPitPages(List<FormPageData> pages) {
    _pitPages = pages;
  }

  static List<FormPageData> getPitPages() {
    return _pitPages;
  }
}

class MatchesTeams {
  final Map<int, List<String>> blueAlliance;
  final Map<int, List<String>> redAlliance;

  MatchesTeams(this.blueAlliance, this.redAlliance);

  static MatchesTeams fromJson(Map<String, dynamic> json) {
    // Convert the "blue" and "red" entries to Map<int, List<String>>
    Map<int, List<String>> blueAlliance =
        (json['blue'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(int.parse(key), List<String>.from(value)),
    );

    Map<int, List<String>> redAlliance =
        (json['red'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(int.parse(key), List<String>.from(value)),
    );

    return MatchesTeams(blueAlliance, redAlliance);
  }
}

enum MatchType { normal, rematch, practice, pit }
