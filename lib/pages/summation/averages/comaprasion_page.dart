import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:scouting_site/services/scouting/form_data.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_text_figures.dart';

class ComparasionPage extends StatefulWidget {
  final List<FormData>? formsData;
  final Map<String, FormData> avgs;
  const ComparasionPage(
      {super.key, required this.formsData, required this.avgs});

  @override
  State<ComparasionPage> createState() => _ComparasionPageState();
}

class _ComparasionPageState extends State<ComparasionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        DialogTagTextInput(
          title: "Teams",
          tags: widget.formsData
                  ?.map((form) => form.scoutedTeam ?? "N/A")
                  .toSet()
                  .toList() ??
              [],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
