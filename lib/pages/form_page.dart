// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/services/scouting/scouting.dart';
import 'package:scouting_site/theme.dart';
import 'package:scouting_site/widgets/questions_widgets/question_widget.dart';

class FormPage extends StatefulWidget {
  final FormPageData data;

  const FormPage({super.key, required this.data});
  @override
  State<StatefulWidget> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackButton,
          tooltip: "Back",
          color: GlobalColors.backButtonColor,
        ),
        backgroundColor: GlobalColors.appBarColor,
        title: Text(
          widget.data.pageName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: GlobalColors.teamColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: GlobalColors.backgroundColor,
          child: Column(
            children: getQuestionWidgets(),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!Scouting.isOnLastPage())
            FloatingActionButton(
              tooltip: Scouting.getNextPageName(),
              onPressed: () {
                Scouting.advance(context);
              },
              heroTag: 2 + Scouting.getCurrentPageNumber(),
              child: GlobalIcons.nextPageIcon,
            )
          else
            FloatingActionButton(
              onPressed: () {
                List<FormPageData> pages = [];

                if (Scouting.data.matchType == MatchType.pit) {
                  pages = Scouting.getPitPages();
                } else {
                  pages = Scouting.getMatchPages();
                }

                Scouting.sendData(Scouting.toJson(pages, Scouting.data));
                Scouting.sendUnsentFormEntries();
              },
              tooltip: "Submit",
              child: const Icon(Icons.send_outlined),
            )
        ],
      ),
    );
  }

  void _handleBackButton() {
    Scouting.onPagePop();
    Navigator.of(context).pop();
  }

  List<Widget> getQuestionWidgets() {
    List<Widget> widgets = [];

    for (Question question in widget.data.questions) {
      widgets.add(const SizedBox(height: 5));
      widgets.add(QuestionWidget(question: question));
      widgets.add(const Divider());
    }

    return widgets;
  }
}
