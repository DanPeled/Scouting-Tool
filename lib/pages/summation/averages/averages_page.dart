// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:scouting_site/pages/summation/averages/comaprasion_page.dart';
import 'package:scouting_site/pages/summation/averages/insights_page.dart';
import 'package:scouting_site/pages/summation/scouting_entries_page.dart';
import 'package:scouting_site/services/firebase/firebase_api.dart';
import 'package:scouting_site/services/scouting/form_data.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/services/scouting/scouting.dart';
import 'package:scouting_site/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    setupAverages();

    return DefaultTabController(
      length: 1 /* was previously 2 */,
      child: Scaffold(
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
          bottom: const TabBar(
            indicatorWeight: 4.0,
            tabs: [
              Tab(text: "Insights"), /* Tab(text: "Compare") */
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: InsightsPage(
                allTeamsAvg: _totalAllTeamsAvg,
                pagesAvg: _pageAvgs,
                originalFormsData: widget.formsData ?? [],
                calculatedFormsData: _formsData,
              ),
            ),
            /* SingleChildScrollView(
              child: ComparasionPage(
                  formsData: widget.formsData,
                  avgs: calculateAvgs(widget.formsData ?? [])),
            ) */
          ],
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
      ),
    );
  }

  void setupAverages() {
    _totalAllTeamsAvg = 0;
    if (widget.formsData == null) {
      getDocuments();
    } else {
      _formsData = widget.formsData!;
    }

    _formsData = _formsData.map((match) {
      _totalAllTeamsAvg += match.score;

      if (match.matchType != MatchType.normal && (match.game ?? 0) < 200) {
        int addition =
            MatchType.rematch == (match.game ?? MatchType.normal) ? 200 : 300;
        match.game = (match.game ?? 0) + addition;
        return match;
      } else {
        return match;
      }
    }).toList();

    _totalAllTeamsAvg /= _formsData.length;

    _formsData = calculateAvgs(_formsData).values.toList();
    _pageAvgs = {};

    for (var form in _formsData) {
      for (var page in form.pages) {
        _pageAvgs[page.pageName] = (_pageAvgs[page.pageName] ?? 0) + page.score;
      }
    }

    _pageAvgs = _pageAvgs.map((pageName, score) {
      return MapEntry(pageName, score / _formsData.length);
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
}
