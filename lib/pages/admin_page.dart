// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:scouting_site/services/firebase/firebase_api.dart';
import 'package:scouting_site/services/formatters/text_formatter_builder.dart';
import 'package:scouting_site/services/scouting/form_page_data.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/services/scouting/scouting.dart';
import 'package:scouting_site/theme.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_text_input.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FormPageData> _matchPages = [];
  List<FormPageData> _pitPages = [];
  int _currentTab = 0;
  String eventKey = "2024isos2";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Adding listener to call a method when the tab is switched
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });

    _matchPages = Scouting.getMatchPages();
    _pitPages = Scouting.getPitPages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _currentTab,
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
            "Edit Questions",
            style: TextStyle(
              color: GlobalColors.teamColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: SizedBox(
                              width: 300,
                              height: 300,
                              child: Column(
                                children: [
                                  DialogTextInput(
                                    onSubmit: (value) {},
                                    onChanged: (value) {},
                                    label: "Event Key",
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          ));
                },
                icon: const Icon(Icons.settings_outlined)),
          ],
          bottom: TabBar(
            indicatorWeight: 4.0,
            controller: _tabController,
            tabs: const [Tab(text: "Match"), Tab(text: "Pit")],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            getPageView(_matchPages),
            getPageView(_pitPages),
          ],
        ),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "Add Page",
            onPressed: () {
              setState(() {
                if (_currentTab == 0) {
                  _matchPages
                      .add(FormPageData(pageName: "New Page", questions: []));
                } else if (_currentTab == 1) {
                  _pitPages
                      .add(FormPageData(pageName: "New Page", questions: []));
                }
              });
            },
            tooltip: "Add Page",
            child: const Icon(Icons.add_outlined),
          ),
          const SizedBox(width: 5),
          FloatingActionButton(
            heroTag: "save",
            onPressed: () async {
              // String eventKey = "2024isde1";

              Map<String, dynamic> matchesQuestionsJson =
                  Scouting.toJson(_matchPages, null);

              Map<String, dynamic> pitQuestionsJson =
                  Scouting.toJson(_pitPages, null);
              DatabaseAPI.instance.uploadJson({
                "data": [
                  matchesQuestionsJson,
                  pitQuestionsJson,
                ]
              }, "form_questions", "${eventKey}_questions");
            },
            tooltip: "Save To Cloud",
            child: const Icon(Icons.save_outlined),
          )
        ]),
      ),
    );
  }

  Widget getPageView(List<FormPageData> pages) {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final FormPageData page = pages.removeAt(oldIndex);
          pages.insert(newIndex, page);
        });
      },
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 400),
      children: [
        for (int i = 0; i < pages.length; i++)
          Padding(
            key: Key("Padding for editor $i"),
            padding: const EdgeInsets.all(10),
            child: getPageEditorView(pages[i], pages, i),
          ),
      ],
    );
  }

  Widget getPageEditorView(
      FormPageData page, List<FormPageData> parentList, int index) {
    return Container(
      key: ValueKey(index),
      width: 1000,
      color: GlobalColors.primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 5),
          DialogTextInput(
            label: "Page Name",
            initialText: page.pageName,
            onSubmit: (value) {
              setState(() {
                page.pageName = value;
              });
            },
            onChanged: (value) {
              if (value != null) {
                page.pageName = value;
              }
            },
          ),
          const SizedBox(height: 8),
          ReorderableListView(
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final Question question = page.questions.removeAt(oldIndex);
                page.questions.insert(newIndex, question);
              });
            },
            children: [
              for (int i = 0; i < page.questions.length; i++)
                getQuestionEditorView(page.questions[i], page.questions, i),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_outlined),
            tooltip: "Add Question",
            onPressed: () {
              setState(() {
                page.questions.add(
                  Question(
                      type: AnswerType.number, questionText: "New Question"),
                );
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            onPressed: () {
              setState(() {
                parentList.remove(page);
              });
            },
            tooltip: "Remove Page (${page.pageName})",
          ),
        ],
      ),
    );
  }

  Widget getQuestionEditorView(
      Question question, List<Question> parentList, int index) {
    return Container(
      key: ValueKey(index),
      width: 1000,
      color: GlobalColors.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 5),
          DialogTextInput(
            label: "Question Text",
            initialText: question.questionText,
            onChanged: (value) {
              if (value != null) {
                question.questionText = value;
              }
            },
            onSubmit: (value) {
              question.questionText = value;
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              DropdownMenu<AnswerType>(
                label: const Text("Answer Type"),
                initialSelection: question.type,
                dropdownMenuEntries: AnswerType.values
                    .map((type) => DropdownMenuEntry(
                          value: type,
                          label: type.name,
                        ))
                    .toList(),
                onSelected: (answerType) {
                  setState(() {
                    question.type = answerType ?? AnswerType.number;
                    question.options = null;
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              getQuestionPropertiesEditor(question),
            ],
          ),
          const SizedBox(height: 10),
          getQuestionEvaluateEditor(question),
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            onPressed: () {
              setState(() {
                parentList.remove(question);
              });
            },
            tooltip: "Remove Question",
          ),
        ],
      ),
    );
  }

  Widget getQuestionEvaluateEditor(Question question) {
    switch (question.type) {
      case AnswerType.text:
        break; // No evaluation
      case AnswerType.multipleChoice:
      case AnswerType.dropdown:
        if (question.evaluation.runtimeType.toString() !=
            "IdentityMap<String, double>") {
          question.evaluation = <String, double>{};
          for (var option in question.options ?? []) {
            question.evaluation[option.toString()] = 0;
          }
        }

        return Column(
          children: question.options?.map((option) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.toString(),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                    SizedBox(
                      width: 300,
                      height: 70,
                      child: DialogTextInput(
                        formatter: TextFormatterBuilder.decimalTextFormatter(
                            allowNegative: true),
                        label: "Evaluation",
                        initialText:
                            question.evaluation[option.toString()].toString(),
                        onSubmit: (value) {
                          setState(() {
                            double doubleValue = double.tryParse(value) ?? 0;
                            question.evaluation[option.toString()] =
                                doubleValue;
                          });
                        },
                      ),
                    ),
                  ],
                );
              }).toList() ??
              [],
        );
      default:
        return DialogTextInput(
          formatter:
              TextFormatterBuilder.decimalTextFormatter(allowNegative: true),
          label: "Evaluation",
          initialText: question.evaluation.toString(),
          onSubmit: (value) {
            setState(() {
              question.evaluation = double.tryParse(value) ?? 0.0;
            });
          },
        );
    }
    return Container();
  }

  Widget getQuestionPropertiesEditor(Question question) {
    List<Widget> propertyEditors = [];

    switch (question.type) {
      case AnswerType.multipleChoice:
      case AnswerType.dropdown:
        if (question.options?.isEmpty ?? true) {
          question.options = ["New Option"];
        }

        propertyEditors.add(
          SizedBox(
            width: 400,
            height: question.options!.length * 70,
            child: ReorderableListView(
              children: List.generate(question.options!.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  key: Key(index.toString()),
                  child: DialogTextInput(
                    label: "Option",
                    initialText: question.options![index].toString(),
                    onSubmit: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          question.options!.removeAt(index);
                        } else {
                          question.options![index] = value;
                        }
                      });
                    },
                    onChanged: (value) {
                      if (value?.isEmpty ?? true) {
                        setState(() {
                          question.options!.removeAt(index);
                        });
                      }
                    },
                  ),
                );
              }),
              onReorder: (from, to) {
                if (from < to) {
                  // This fixes an unexpected null issue, unsure why it happens,
                  // probably because the listview tries to add it at the end which
                  // results in a higher by 1 index than whats logical
                  to--;
                }
                if (question.options == null) return;

                setState(() {
                  final item = question.options!.removeAt(from);
                  question.options!.insert(to, item);
                });
              },
            ),
          ),
        );

        propertyEditors.add(
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () {
              setState(() {
                question.options?.add("Another option");
              });
            },
            tooltip: "Add option",
          ),
        );

        break;
      case AnswerType.counter:
        if ((question.options?.length ?? 1) < 3) {
          question.options = [0, 0, 10];
        }

        propertyEditors.addAll([
          SizedBox(
            width: 100,
            height: 70,
            child: DialogTextInput(
              onSubmit: (value) {
                question.options?[1] = int.tryParse(value) ?? 0;
              },
              label: "Min",
              initialText: question.options![1].toString(),
              formatter: TextFormatterBuilder.integerTextFormatter(),
            ),
          ),
          SizedBox(
            width: 100,
            height: 70,
            child: DialogTextInput(
              onSubmit: (value) {
                question.options?[2] = int.tryParse(value) ?? 0;
              },
              label: "Max",
              initialText: question.options![2].toString(),
              formatter: TextFormatterBuilder.integerTextFormatter(),
            ),
          ),
          SizedBox(
            width: 100,
            height: 70,
            child: DialogTextInput(
              onSubmit: (value) {
                question.options?[0] = int.tryParse(value) ?? 0;
              },
              label: "Default",
              initialText: question.options![0].toString(),
              formatter: TextFormatterBuilder.integerTextFormatter(),
            ),
          ),
        ]);
        break;
      default:
        break;
    }

    return Flexible(
        child: Row(
      children: propertyEditors,
    ));
  }

  void _handleBackButton() {
    Navigator.of(context).pop();
  }
}
