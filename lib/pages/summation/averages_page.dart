// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:scouting_site/pages/summation/scouting_entries_page.dart';
import 'package:scouting_site/pages/summation/team_overview.dart';
import 'package:scouting_site/services/firebase/firebase_api.dart';
import 'package:scouting_site/services/scouting/form_data.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/helper_methods.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/services/scouting/scouting.dart';
import 'package:scouting_site/theme.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_text_input.dart';

class AveragesPage extends StatefulWidget {
  List<FormData>? formsData;

  AveragesPage({super.key, this.formsData});

  @override
  State<StatefulWidget> createState() => _AveragesPageState();
}

class _AveragesPageState extends State<AveragesPage> {
  List<FormData> _formsData = [];

  Map<String, double> _pageAvgs = {};
  double _totalAllTeamsAvg = 0;
  String _sortBy = "total_score";
  Map<String, dynamic> _searchQueryMap = {};

  @override
  Widget build(BuildContext context) {
    if (widget.formsData == null) {
      getDocuments();
    } else {
      _formsData = widget.formsData!;
    }

    _formsData = _formsData.map((match) {
      if (match.matchType != MatchType.normal && (match.game ?? 0) < 200) {
        int addition =
            MatchType.rematch == (match.game ?? MatchType.normal) ? 200 : 300;
        return match..game = (match.game ?? 0) + addition;
      } else {
        return match;
      }
    }).toList();

    _formsData = calculateAvgs(_formsData).values.toList();

    switch (_sortBy) {
      case "total_score":
        sortByTotalScore(_formsData);
        break;
      case "game":
        sortByGame(_formsData);
        break;
      case "team":
        sortByTeam(_formsData);
        break;
      default:
        sortByPage(_formsData, _sortBy);
        break;
    }

    _pageAvgs = {};

    for (var form in _formsData) {
      for (var page in form.pages) {
        _pageAvgs[page.pageName] = (_pageAvgs[page.pageName] ?? 0) + page.score;
      }
    }

    _pageAvgs.map((pageName, score) {
      _totalAllTeamsAvg += score;
      return MapEntry(pageName, score / _formsData.length);
    });

    _totalAllTeamsAvg /= _pageAvgs.length;

    _formsData = handleSearchQuery(_formsData, _searchQueryMap);

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
          "Averages",
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
                    _searchQueryMap = evaluateSearchQuery(value);
                  });
                },
                label: "Search",
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DataTable(
                      columns: [
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
                        ...getPagesDataColumns(_formsData),
                      ],
                      rows: getDataTableRows(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Key (Precentile): "),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: getColorByScore(0, 100),
                    ),
                    child: (const Text("0-25")),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: getColorByScore(26, 100),
                    ),
                    child: (const Text("25-75")),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: getColorByScore(76, 100),
                    ),
                    child: (const Text("75-90")),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: getColorByScore(98, 100),
                    ),
                    child: (const Text("90-99")),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: getColorByScore(100, 100),
                    ),
                    child: (const Text("99-100")),
                  ),
                ],
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
              _pageAvgs = {};
              getDocuments();
            },
            tooltip: "Re-Fetch Documents",
            icon: const Icon(Icons.refresh_outlined),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScoutingEntriesPage(),
                ),
              );
            },
            tooltip: "All Entries",
            child: const Icon(Icons.pie_chart),
          ),
        ],
      ),
    );
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

  void _handleBackButton() {
    Navigator.of(context).pop();
  }

  void getDocuments() async {
    QuerySnapshot<Map<String, dynamic>>? snapshot = await DatabaseAPI
        .instance.firestore
        ?.collection("scouting_${Scouting.competitionName}")
        .get();

    if (snapshot != null) {
      List<Map<String, dynamic>> data =
          snapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        _formsData = data.map((scout) {
          return FormData.fromJson(scout);
        }).toList();
        widget.formsData = _formsData;
      });
    }
  }

  List<DataRow> getDataTableRows() {
    List<DataRow> rows = [];
    for (FormData form in _formsData) {
      rows.add(DataRow(cells: [
        DataCell(
          TextButton(
              child: Text(form.scoutedTeam ?? ""),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamOverviewPage(
                      team: extractNumber(form.scoutedTeam ?? ""),
                      forms: widget.formsData ?? [],
                      avgs: _formsData,
                    ),
                  ),
                );
              }),
        ),
        ...getPagesDataRows(pages: _formsData.first.pages, data: form.pages),
      ]));
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
                    "${page.pageName} Avg.",
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
    columns.add(
      DataColumn(
        label: Expanded(
          child: Row(
            children: [
              Text(
                "Total Avg.",
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
                  tooltip: "Sort by Avg. Score",
                  icon: const Icon(Icons.sort_outlined))
            ],
          ),
        ),
      ),
    );

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
          cells.add(
            DataCell(
              Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: getColorByScore(score, _pageAvgs[page.pageName] ?? 0),
                ),
                child: (Text(
                  getNumAsFixed(score),
                )),
              ),
            ),
          );
          totalScore += score;
        } else {
          cells.add(DataCell.empty);
        }
      }
    }

    cells.add(
      DataCell(
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: getColorByScore(totalScore, _totalAllTeamsAvg),
          ),
          child: (Text(
            getNumAsFixed(totalScore),
          )),
        ),
      ),
    );

    return cells;
  }

  void sortByTotalScore(List<FormData> data) {
    data.sort((form1, form2) => form2.score.compareTo(form1.score));
  }

  Map<String, FormData> calculateAvgs(List<FormData> formsData) {
    // Maps to accumulate total scores and counts
    Map<String, List<FormData>> teamsDatas = {};
    Map<String, Map<String, double>> pagesTotalScores = {};
    Map<String, Map<String, int>> pagesCounts = {};
    Map<String, double> totalScores = {};
    Map<String, int> formCounts = {};

    // Organize forms data by team and accumulate scores
    for (var form in formsData) {
      final team = form.scoutedTeam!;
      teamsDatas.putIfAbsent(team, () => []).add(form);
      totalScores.update(team, (total) => total + form.score,
          ifAbsent: () => form.score);
      formCounts.update(team, (count_) => count_ + 1, ifAbsent: () => 1);

      for (var page in form.pages) {
        pagesTotalScores.putIfAbsent(team, () => {});
        pagesCounts.putIfAbsent(team, () => {});

        pagesTotalScores[team]!.update(
            page.pageName, (sum_) => sum_ + page.score,
            ifAbsent: () => page.score);
        pagesCounts[team]!
            .update(page.pageName, (count_) => count_ + 1, ifAbsent: () => 1);
      }
    }

    // Calculate averages for each team
    Map<String, FormData> teamAvgs = {};
    for (var team in teamsDatas.keys) {
      final totalForms = formCounts[team]!;
      final avgTotal = totalScores[team]! / totalForms;

      // Calculate average scores for each page
      Map<String, double> pagesAvgs = {};
      pagesTotalScores[team]!.forEach((pageName, totalScore) {
        pagesAvgs[pageName] = totalScore / pagesCounts[team]![pageName]!;
      });

      // Create the list of FormPageData with average scores
      List<FormPageData> pagesAvgsList = pagesAvgs.entries.map((entry) {
        return FormPageData(
            pageName: entry.key, questions: [], score: entry.value);
      }).toList();

      teamAvgs[team] = FormData(
        pages: pagesAvgsList,
        scouter: "",
        score: avgTotal,
        scoutedTeam: team,
        matchType: MatchType.normal,
      );
    }

    return teamAvgs;
  }

  Color getColorByScore(double score, double pageAvg) {
    double precentage = score / pageAvg;
    if (precentage <= 0.25) {
      return Colors.redAccent.shade400;
    } else if (precentage <= 0.75) {
      return Colors.transparent;
    } else if (precentage <= 0.9) {
      return Colors.redAccent.shade100;
    } else if (precentage < 0.99) {
      return Colors.greenAccent.shade400;
    } else {
      return Colors.blueAccent.shade100;
    }
  }
}
