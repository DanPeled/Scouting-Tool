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
  static final List<FormPageData> _pages = [
    FormPageData(
      pageName: "Autonomous",
      questions: [
        Question(
          type: AnswerType.checkbox,
          questionText: "Autonomous?",
          evaluation: 2.0,
        ),
        Question(
          type: AnswerType.counter,
          questionText: "Amount of scored speaker notes",
          evaluation: 5.0,
          options: [
            0, // initial
            0, // min
          ],
        ),
        Question(
          type: AnswerType.counter,
          questionText: "Amount of scored amp notes",
          evaluation: 2.0,
          options: [
            0, // initial
            0, // min
          ],
        ),
      ],
    ),
    FormPageData(
      pageName: "TeleOp",
      questions: [
        Question(
          type: AnswerType.counter,
          questionText: "Scored speaker notes",
          evaluation: 2.0,
          options: [
            0, // initial
            0, // min
          ],
        ),
        Question(
          type: AnswerType.counter,
          questionText: "Scored amp notes",
          evaluation: 1.0,
          options: [
            0, // initial
            0, // min
          ],
        ),
      ],
    ),
    FormPageData(
      pageName: "End-Game",
      questions: [
        Question(
          type: AnswerType.checkbox,
          questionText: "Trap",
          evaluation: 10.0,
        ),
        Question(
          type: AnswerType.checkbox,
          questionText: "Climb",
          evaluation: 5.0,
        ),
        Question(
          type: AnswerType.checkbox,
          questionText: "Harmony",
          evaluation: 2.0,
        ),
      ],
    ),
  ];

  static MatchesTeams _matchesTeamsPair = MatchesTeams({}, {});

  static List<BuildContext> _pagesContexts = [];

  static const String competitionName = "2024isos2";

  static int _currentPage = -1;

  static FormData data = FormData(
    pages: _pages,
    scouter: localStorage?.getString("scouter"),
    matchType: MatchType.normal,
  );

  static bool hasInternet = true;

  static bool isOnLastPage() {
    return _currentPage >= _pages.length - 1;
  }

  static void _resetValues() {
    _currentPage = -1;
    _pagesContexts = [];
    data.game = null;
    data.scoutedTeam = null;

    for (FormPageData page in _pages) {
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

    await sendUnsentFormEntries();

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
    return _pages.length;
  }

  static FormPage generateCurrentPage() {
    return FormPage(data: _pages[_currentPage]);
  }

  static void advance(BuildContext context) {
    if (_pages.length - 1 > _currentPage) {
      _currentPage++;

      _pagesContexts.add(context);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scouting.generateCurrentPage()));
    }
  }

  static bool _isIndexValid(int index) {
    return _pages.length - 1 > _currentPage;
  }

  static String getNextPageName() {
    return (_isIndexValid(_currentPage + 1)
        ? _pages[_currentPage + 1].pageName
        : "Unknown");
  }

  static void onPagePop() {
    _pagesContexts.removeAt(_currentPage);
    _currentPage--;
  }

  static int getCurrentPageNumber() {
    return _currentPage;
  }

  static Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> pagesJson =
        _pages.map((page) => page.toJson()).toList();

    return {
      'pages': pagesJson,
      'scouter': data.scouter,
      'match_type': data.matchType.name,
      'scouted_on': data.scoutedTeam,
      'game': data.game,
      'score': data.evaluate(),
    };
  }

  static List<FormPageData> fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    List<FormPageData> pages = (jsonMap['pages'] as List<dynamic>)
        .map((item) => FormPageData.fromJson(item as Map<String, dynamic>))
        .toList();

    return pages;
  }

  static Future<void> sendData(Map<String, dynamic> json,
      {String? header}) async {
    if (data.scoutedTeam == null) return;

    for (int i = 0; i < _pagesContexts.length; i++) {
      Navigator.pop(_pagesContexts[i]);
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

enum MatchType { normal, rematch, practice }
