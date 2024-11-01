// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:statbotics/statbotics.dart';

// Project imports:
import 'package:scouting_site/pages/summation/team_overview.dart';
import 'package:scouting_site/services/localstorage.dart';
import 'package:scouting_site/services/scouting/form_data.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/helper_methods.dart';
import 'package:scouting_site/theme.dart';

class InsightsPage extends StatefulWidget {
  final double allTeamsAvg;
  final Map<String, double> pagesAvg;
  final List<FormData> originalFormsData;
  final List<FormData> calculatedFormsData;

  const InsightsPage({
    super.key,
    required this.allTeamsAvg,
    required this.pagesAvg,
    required this.originalFormsData,
    required this.calculatedFormsData,
  });

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  String _sortBy = "total_score";
  bool _showTeamNames = true;

  @override
  Widget build(BuildContext context) {
    switch (_sortBy) {
      // BUG: sorting breaks team names
      case "total_score":
        sortByTotalScore(widget.calculatedFormsData);
        break;
      case "game":
        sortByGame(widget.calculatedFormsData);
        break;
      case "team":
        sortByTeam(widget.calculatedFormsData);
        break;
      default:
        sortByPage(widget.calculatedFormsData, _sortBy);
        break;
    }

    return Container(
      color: GlobalColors.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          TextButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_showTeamNames
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                const SizedBox(
                  width: 5,
                ),
                Text("${_showTeamNames ? "Hide" : "Show"} team names"),
              ],
            ),
            onPressed: () {
              setState(() {
                _showTeamNames = !_showTeamNames;
              });
            },
          ),
          const SizedBox(height: 5),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
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
                    ...getPagesDataColumns(widget.calculatedFormsData),
                  ],
                  rows: getDataTableRows(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          getPrecentileKeysWidget()
        ],
      ),
    );
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

  void sortByTotalScore(List<FormData> data) {
    data.sort((form1, form2) => form2.score.compareTo(form1.score));
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

  Future<Team> _getTeamData(String? number) async {
    return (await Statbotics.getTeamData(extractNumber(number ?? "N/A")));
  }

  List<DataRow> getDataTableRows() {
    List<DataRow> rows = [];
    for (FormData form in widget.calculatedFormsData) {
      rows.add(DataRow(cells: [
        DataCell(FutureBuilder<Team>(
            future: _getTeamData(form.scoutedTeam),
            builder: (BuildContext context, AsyncSnapshot<Team> snapshot) {
              Team? team = snapshot.data;

              String? localStorageTeamName =
                  localStorage?.getString("${form.scoutedTeam}_teamName");

              String? teamName = localStorageTeamName;

              if (team != null && localStorageTeamName != team.name) {
                // cache name
                localStorage?.setString(
                    "${form.scoutedTeam}_teamName", team.name);
              }

              if (team == null) {
                // Handle cached names
                teamName =
                    localStorage?.getString("${form.scoutedTeam}_teamName");
              } else if (team.team == form.scoutedTeam) {
                teamName = team.name;
              }

              String fullDisplayName =
                  getTeamDisplayName(form.scoutedTeam, teamName);

              return getTeamOverivewPageNavigateButton(
                  form.scoutedTeam, teamName, fullDisplayName);
            })),
        ...getPagesDataRows(
            pages: widget.calculatedFormsData.first.pages, data: form.pages),
      ]));
    }

    return rows;
  }

  String getTeamDisplayName(String? teamNum, String? teamName) {
    String fullDisplayName = "#${teamNum ?? "N/A"}";

    if (_showTeamNames) {
      fullDisplayName = "${teamName ?? ""} $fullDisplayName";
    }

    return fullDisplayName;
  }

  Widget getTeamOverivewPageNavigateButton(
      String? team, String? teamName, String displayName) {
    return TextButton(
        child: Text(displayName),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamOverviewPage(
                team: extractNumber(team ?? ""),
                forms: widget.originalFormsData,
                avgs: widget.calculatedFormsData,
                teamName: teamName ?? "",
              ),
            ),
          );
        });
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
                  color: getColorByScore(
                      score, widget.pagesAvg[page.pageName] ?? 0),
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
            color: getColorByScore(totalScore, widget.allTeamsAvg),
          ),
          child: (Text(
            getNumAsFixed(totalScore),
          )),
        ),
      ),
    );

    return cells;
  }

  Widget getPrecentileKeysWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Key (Precentile): "),
        const SizedBox(width: 10),
        getPrecentileContainer("0-25", 0, 100),
        const SizedBox(width: 10),
        getPrecentileContainer("25-75", 26, 100),
        const SizedBox(width: 10),
        getPrecentileContainer("75-90", 76, 100),
        const SizedBox(width: 10),
        getPrecentileContainer("90-99", 91, 100),
        const SizedBox(width: 10),
        getPrecentileContainer("99-100", 100, 100)
      ],
    );
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

  Widget getPrecentileContainer(String text, double value, double avg) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: getColorByScore(value, avg),
      ),
      child: (Text(text)),
    );
  }
}
