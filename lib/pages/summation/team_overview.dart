// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:scouting_site/services/cast.dart';

// Project imports:
import 'package:scouting_site/services/scouting/form_data.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/helper_methods.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/theme.dart';
import 'package:scouting_site/widgets/avgs_graph.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_toggle_switch.dart';

class TeamOverviewPage extends StatefulWidget {
  final int team;
  final List<FormData> forms;
  final List<FormData> avgs;

  const TeamOverviewPage(
      {super.key, required this.team, required this.forms, required this.avgs});

  @override
  State<TeamOverviewPage> createState() => _TeamOverviewPageState();
}

class _TeamOverviewPageState extends State<TeamOverviewPage> {
  Map<String, double> questionAverages = {};
  Map<String, double> selectedTeamQuestionAverages = {};
  Map<String, dynamic> selectedTeamQuestionAnswerAverages = {};
  Map<String, Map<String, bool>> questionSwitchesMap = {};
  double screenWidth = 0;
  Map<String, bool> pagesActive = {};

  @override
  void initState() {
    super.initState();

    calculateQuestionAverages();

    for (var page in widget.forms.last.pages) {
      questionSwitchesMap[page.pageName] = {};

      for (var question in page.questions) {
        questionSwitchesMap[page.pageName]?[question.questionText] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _handleBackButton,
          icon: const Icon(Icons.arrow_back),
          tooltip: "Back",
          color: GlobalColors.backButtonColor,
        ),
        backgroundColor: GlobalColors.appBarColor,
        title: Text(
          "#${widget.team} Overview",
          style: const TextStyle(
            color: GlobalColors.teamColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: GlobalColors.backgroundColor,
          child: Column(
            children: [
              const SizedBox(height: 100),
              Row(
                children: [
                  SizedBox(
                    height: 600,
                    width: screenWidth / 3 * 2,
                    child: getTotalScoreGraph(questionSwitchesMap),
                  ),
                  SizedBox(
                    height: 600,
                    width: screenWidth / 3,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        width: 40.0,
                        height: 60.0,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(30, 30, 30, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: getQuestionAveragesWidgets(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 20,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 2),
                  Text("${widget.team}# Score"),
                  const SizedBox(width: 20),
                  Container(
                    height: 10,
                    width: 20,
                    color: Colors.blue.shade200,
                  ),
                  const SizedBox(width: 2),
                  const Text("Avg Global Score"),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Edit Graph Settings"),
              scrollable: true,
              content: SizedBox(
                width: 700,
                height: 700,
                child: Column(
                  children: getQuestionSwitches(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                )
              ],
            ),
          );
        },
        child: const Icon(Icons.settings_outlined),
      ),
    );
  }

  Widget getQuestionAveragesWidgets() {
    Column averages = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Averages: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: GlobalColors.teamColor,
          ),
        ),
        const Divider(),
        ...selectedTeamQuestionAnswerAverages.entries.map((entry) {
          String questionName =
              entry.key; // Extract the question text from the key
          double averageValue = entry.value;
          if (questionName.startsWith("__page")) {
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    questionName,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    averageValue
                        .toStringAsFixed(2), // Display the average value
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }
        })
      ],
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: averages,
      ),
    );
  }

  void _handleBackButton() {
    Navigator.of(context).pop();
  }

  List<Widget> getQuestionSwitches() {
    List<Widget> questionsToggles = [];

    List<FormData> teamForms = widget.forms
        .where((form) => extractNumber(form.scoutedTeam ?? "") == widget.team)
        .toList();
    double switchesSize = (screenWidth > 500) ? 500 : screenWidth;

    for (var page in teamForms.last.pages) {
      questionsToggles.add(
        Text(
          page.pageName,
          textScaler: const TextScaler.linear(1.6),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      questionsToggles.add(const SizedBox(height: 5));
      for (var question in page.questions) {
        questionsToggles.add(
          SizedBox(
            width: switchesSize,
            height: 40,
            child: DialogToggleSwitch(
              onToggle: (value) {
                setState(() {
                  questionSwitchesMap[page.pageName]?[question.questionText] =
                      value;
                });
              },
              label: question.questionText,
              initialValue: questionSwitchesMap[page.pageName]
                      ?[question.questionText] ??
                  false,
            ),
          ),
        );

        questionsToggles.add(const SizedBox(height: 5));
      }

      questionsToggles.add(const Divider());
    }

    return questionsToggles;
  }

  Widget getTotalScoreGraph(
      Map<String, Map<String, bool>> questionSwitchesMap) {
    Map<int, List<FormData>> gameForms = {};

    for (var form in widget.forms) {
      if (form.game != null) {
        gameForms.putIfAbsent(form.game!, () => []).add(form);
      }
    }

    Map<int, double> avgs = {};
    Map<int, double> teamScores = {};

    for (int game in gameForms.keys) {
      double currentGameSum = 0;
      int numberOfForms = gameForms[game]?.length ?? 0;

      if (numberOfForms > 0) {
        double sameGameScoreSum = 0;
        int sameGameAmount = 0;
        bool addTeamScore = false;
        for (FormData gameForm in gameForms[game] ?? []) {
          double score = 0;
          for (FormPageData page in gameForm.pages) {
            for (Question question in page.questions) {
              if ((questionSwitchesMap[page.pageName]
                      ?[question.questionText]) ??
                  true) {
                score += question.score;
              }
            }
          }

          currentGameSum += score;

          if (extractNumber(gameForm.scoutedTeam ?? "") == widget.team) {
            sameGameScoreSum += score;
            sameGameAmount++;
            addTeamScore = true;
          }
        }

        if (addTeamScore) {
          teamScores[game] =
              (teamScores[game] ?? 0) + sameGameScoreSum / sameGameAmount;
        }

        avgs[game] = currentGameSum / numberOfForms;
      } else {
        avgs[game] = 0;
      }
    }
    double totalAvg = 0;

    avgs.forEach((game, avg) {
      totalAvg += avg;
    });

    totalAvg /= avgs.length;

    List<FlSpot> avgSpots = avgs.entries
        .map((entry) => FlSpot(
            entry.key.toDouble(), double.parse(totalAvg.toStringAsFixed(2))))
        .toList();

    List<FlSpot> teamSpots = teamScores.entries
        .map((entry) => FlSpot(
            entry.key.toDouble(), double.parse(entry.value.toStringAsFixed(2))))
        .toList();

    // List<FlSpot> zeroSpots = teamScores.entries
    //     .map((entry) => FlSpot(entry.key.toDouble(), 0.0))
    //     .toList();

    return AvgsGraph(
      avgSpots: avgSpots,
      teamSpots: teamSpots,
    );
  }

  void calculateQuestionAverages() {
    Map<String, List<double>> questionScores = {};
    Map<String, List<double>> selectedTeamQuestionScores = {};
    Map<String, List<dynamic>> selectedTeamQuestionAnswers =
        {}; // To hold the answers for averaging

    // Loop through all forms
    for (FormData form in widget.forms) {
      // Loop through each page in the form
      for (FormPageData page in form.pages) {
        if (extractNumber(form.scoutedTeam ?? "0") == widget.team) {
          selectedTeamQuestionAnswerAverages["__page${page.pageName}"] = 1;
        }
        // Loop through each question on the page
        for (Question question in page.questions) {
          String questionKey = "${page.pageName}_${question.questionText}";

          // Initialize the list for scores if it's the first time encountering the question
          if (!questionScores.containsKey(questionKey)) {
            questionScores[questionKey] = [];
          }
          // Add the score and answer to their respective lists
          questionScores[questionKey]!.add(question.score);

          // Filter for the selected team
          if (extractNumber(form.scoutedTeam ?? "0") == widget.team) {
            if (!selectedTeamQuestionAnswers.containsKey(questionKey)) {
              selectedTeamQuestionAnswers[questionKey] = [];
            }
            if (!selectedTeamQuestionScores.containsKey(questionKey)) {
              selectedTeamQuestionScores[questionKey] = [];
            }
            selectedTeamQuestionScores[questionKey]!.add(question.score);
            selectedTeamQuestionAnswers[questionKey]!.add(question.answer);
          }
        }
      }
    }

    // Calculate the average score for each question
    questionScores.forEach((questionText, scores) {
      double average = scores.reduce((a, b) => a + b) / scores.length;
      questionAverages[questionText] = average;
    });

    // Calculate the average score for each question for the selected team
    selectedTeamQuestionScores.forEach((questionText, scores) {
      double average = scores.reduce((a, b) => a + b) / scores.length;
      selectedTeamQuestionAverages[questionText] = average;
    });

    // Calculate the average answer for each question for the selected team
    selectedTeamQuestionAnswers.forEach((questionText, answers) {
      double averageAnswer = answers.map((answer) {
            if (answer is num) {
              return tryCast(answer, 0.0);
            } else {
              if (answer is bool) {
                return answer ? 1 : 0;
              } else {
                return 0;
              }
            }
          }).reduce((a, b) => a! + b!)! /
          answers.length;

      selectedTeamQuestionAnswerAverages[questionText] = averageAnswer;
    });
  }
}
