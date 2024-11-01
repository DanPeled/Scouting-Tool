// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:scouting_site/services/firebase/firebase_api.dart';
import 'package:scouting_site/services/localstorage.dart';
import 'package:scouting_site/services/scouting/form_data.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/helper_methods.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/services/scouting/scouting.dart';
import 'package:scouting_site/services/title_case.dart';
import 'package:scouting_site/theme.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_text_input.dart';

class ScoutingEntriesPage extends StatefulWidget {
  const ScoutingEntriesPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScoutingEntriesPageState();
}

class _ScoutingEntriesPageState extends State<ScoutingEntriesPage> {
  List<FormData> _formsData = [];

  Map<int, Map<String, List<FormData>>> gamesDataMap =
      {}; // Game |-> (Team |-> entries)
  final bool _showScouterField = false;

  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  String _sortBy = "game";
  Map<String, dynamic> _searchQuery = {};
  @override
  Widget build(BuildContext context) {
    _formsData = handleSearchQuery(_formsData, _searchQuery);

    switch (_sortBy) {
      case "total_score":
        sortByTotalScore(_formsData);
        break;
      case "game":
        sortByGame(_formsData);
        break;
      case "scouter":
        sortByScouter(_formsData);
        break;
      case "team":
        sortByTeam(_formsData);
        break;
      default:
        sortByPage(_formsData, _sortBy);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackButton,
          tooltip: "Back",
          color: GlobalColors.backButtonColor,
        ),
        backgroundColor: GlobalColors.appBarColor,
        title: const Text(
          "Scouting Entries",
          style: TextStyle(
            color: GlobalColors.teamColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: GlobalColors.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              DialogTextInput(
                onSubmit: (value) {
                  setState(() {
                    _searchQuery = evaluateSearchQuery(value);
                  });
                },
                label: "Search",
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataTable(
                      columns: [
                        if (_showScouterField)
                          DataColumn(
                            label: Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    "Scouter",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: (_sortBy == "scouter")
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _sortBy = "scouter";
                                        });
                                      },
                                      tooltip: "Sort by Scouter",
                                      icon: const Icon(Icons.sort_outlined))
                                ],
                              ),
                            ),
                          ),
                        const DataColumn(
                            label: Expanded(
                                child: Row(
                          children: [
                            Text("Match Type"),
                          ],
                        ))),
                        DataColumn(
                          label: Expanded(
                            child: Row(
                              children: [
                                Text(
                                  "Team",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: (_sortBy == "team")
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _sortBy = "team";
                                      });
                                    },
                                    tooltip: "Sort by Team",
                                    icon: const Icon(Icons.sort_outlined))
                              ],
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Row(
                              children: [
                                Text(
                                  "Game",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: (_sortBy == "game")
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _sortBy = "game";
                                    });
                                  },
                                  tooltip: "Sort by Game",
                                  icon: const Icon(Icons.sort_outlined),
                                )
                              ],
                            ),
                          ),
                        ),
                        ...getPagesDataColumns(_formsData),
                      ],
                      rows: getDataTableRows(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              getDocuments();
            },
            tooltip: "Re-Fetch Documents",
            icon: const Icon(Icons.refresh_outlined),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  void _handleBackButton() {
    Navigator.of(context).pop();
  }

  void getDocuments() async {
    QuerySnapshot<Map<String, dynamic>>? snapshot = await DatabaseAPI
        .instance.firestore
        ?.collection("scouting_${Scouting.competitionName}")
        .get();

    List<Map<String, dynamic>> data = [];

    if (snapshot != null) {
      data = snapshot.docs.map((doc) => doc.data()).toList();
    } else {
      data = jsonDecode(localStorage?.getString("scouting_data_cache") ?? "[]");
    }

    setState(() {
      _formsData = data
          .map((scout) {
            return FormData.fromJson(scout);
          })
          .toList()
          .map((match) {
            if (match.matchType != MatchType.normal &&
                (match.game ?? 0) < 200) {
              int addition =
                  MatchType.rematch == (match.game ?? MatchType.normal)
                      ? 200
                      : 300;
              return match..game = (match.game ?? 0) + addition;
            } else {
              return match;
            }
          })
          .toList();

      localStorage?.setString("scouting_data_cache", jsonEncode(data));
    });
  }

  List<DataRow> getDataTableRows() {
    List<DataRow> rows = [];
    for (FormData form in _formsData) {
      rows.add(
        DataRow(
          cells: [
            if (_showScouterField) DataCell(Text(form.scouter ?? "")),
            DataCell(Text((form.matchType.name).toTitleCase())),
            DataCell(TextButton(
              child: Text(form.scoutedTeam ?? ""),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "${form.scoutedTeam} - Game #${form.game} by ${form.scouter}"),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [...getAnswersWidgetsForDialog(form)],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            )),
            DataCell(Text(form.game?.toString() ?? "0")),
            ...getPagesDataRows(
                pages: _formsData.first.pages, data: form.pages),
          ],
        ),
      );
    }

    return rows;
  }

  List<Widget> getAnswersWidgetsForDialog(FormData form) {
    List<Widget> answersWidgets = [];

    for (FormPageData page in form.pages) {
      answersWidgets.add(Text(
        page.pageName,
        textScaler: const TextScaler.linear(1.5),
      ));
      for (Question question in page.questions) {
        answersWidgets.add(Text(
          "${question.questionText}: ${question.answer}",
          textScaler: const TextScaler.linear(1.2),
        ));
      }
      answersWidgets.add(const Divider());
      answersWidgets.add(const SizedBox(height: 5));
    }

    answersWidgets.add(const SizedBox(height: 5));
    answersWidgets.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.close_outlined),
            iconSize: 20,
            tooltip: "Close",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return answersWidgets;
  }

  void sortByGame(List<FormData> formsData) {
    formsData.sort((form1, form2) {
      final game1 = form1.game ?? 0;
      final game2 = form2.game ?? 0;
      return game1.compareTo(game2);
    });
  }

  void sortByScouter(List<FormData> formsData) {
    formsData.sort((form1, form2) {
      String scouter1 = form1.scouter ?? "";
      String scouter2 = form2.scouter ?? "";
      return scouter1.compareTo(scouter2);
    });
  }

  void sortByTeam(List<FormData> formsData) {
    formsData.sort((form1, form2) {
      String scouter1 = form1.scoutedTeam ?? "";
      String scouter2 = form2.scoutedTeam ?? "";

      int number1 = extractNumber(scouter1);
      int number2 = extractNumber(scouter2);

      return number1.compareTo(number2);
    });
  }

  void sortByPage(List<FormData> formsData, String pageName) {
    formsData.sort((form1, form2) {
      double value1 =
          form1.pages.firstWhere((page) => page.pageName == pageName).score;

      double value2 =
          form2.pages.firstWhere((page) => page.pageName == pageName).score;

      return value2.compareTo(value1);
    });
  }

  List<DataColumn> getPagesDataColumns(List<FormData> formsData) {
    List<DataColumn> columns = [];

    if (formsData.isNotEmpty) {
      for (FormPageData page in formsData.first.pages) {
        columns.add(
          DataColumn(
            label: Expanded(
              child: Row(
                children: [
                  Text(
                    page.pageName,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: (_sortBy == page.pageName)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _sortBy = page.pageName;
                        });
                      },
                      tooltip: "Sort by ${page.pageName}",
                      icon: const Icon(Icons.sort_outlined))
                ],
              ),
            ),
          ),
        );
      }
    }
    columns.add(DataColumn(
      label: Expanded(
        child: Row(
          children: [
            Text(
              "Total Score",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: (_sortBy == "total_score")
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    _sortBy = "total_score";
                  });
                },
                tooltip: "Sort by Total Score",
                icon: const Icon(Icons.sort_outlined))
          ],
        ),
      ),
    ));

    return columns;
  }

  List<DataCell> getPagesDataRows(
      {required List<FormPageData> pages, required List<FormPageData> data}) {
    List<DataCell> cells = [];
    List<String> pageNames = pages.map((page) => page.pageName).toList();
    double totalScore = 0;
    for (FormPageData page in data) {
      if (pageNames.contains(page.pageName)) {
        if (data.map((page_) => page_.pageName).contains(page.pageName)) {
          double score = page.score;
          cells.add(DataCell(Text(score.toString())));
          totalScore += score;
        } else {
          cells.add(DataCell.empty);
        }
      }
    }

    cells.add(DataCell(Text(totalScore.toString())));

    return cells;
  }

  void sortByTotalScore(List<FormData> data) {
    data.sort((form1, form2) => form2.score.compareTo(form1.score));
  }
}
