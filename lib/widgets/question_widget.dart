import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scouting_site/services/cast.dart';
import 'package:scouting_site/services/formatters/text_formatter_builder.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_text_input.dart';

class QuestionWidget extends StatefulWidget {
  final Question _question;

  const QuestionWidget({super.key, required Question question})
      : _question = question;

  @override
  State<QuestionWidget> createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  late Map<String, bool> optionsValues;

  @override
  void initState() {
    super.initState();

    if (widget._question.type == AnswerType.multipleChoice) {
      optionsValues = {};
      if (widget._question.options != null) {
        optionsValues = tryCast(widget._question.answer) ?? {};
      } else {
        throw ArgumentError(
          'An enumerated question must have options provided. Options cannot be null.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateQuestionWidget();
  }

  List<DropdownMenuEntry> getDropdownOptions(Question question) {
    List<DropdownMenuEntry> entries = [];

    if (question.options == null) {
      return entries;
    }

    for (Object option in question.options!) {
      entries.add(DropdownMenuEntry(value: option, label: option.toString()));
    }

    return entries;
  }

  Widget generateQuestionWidget() {
    Question question = widget._question;
    switch (widget._question.type) {
      case AnswerType.integer:
      case AnswerType.number:
        return generateNumberInput(question);
      case AnswerType.dropdown:
        return generateDropdown(question);
      case AnswerType.text:
        return generateTextInput(question);
      case AnswerType.checkbox:
        return generateCheckbox(question);
      case AnswerType.multipleChoice:
        return generateMultipleChoice(question);
    }
  }

  Column generateMultipleChoice(Question question) {
    List<Widget> entries = [];

    entries.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          question.questionText,
          textScaler: const TextScaler.linear(1.3),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );

    const double checkboxWidth = 40.0;

    if (question.options?.isNotEmpty ?? false) {
      for (Object? option in question.options!) {
        if (option != null) {
          String optionString = option.toString();
          entries.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: checkboxWidth,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: optionsValues[optionString] ?? false,
                      onChanged: (value) {
                        setState(() {
                          optionsValues[optionString] = value ?? false;
                          question.answer = optionsValues;
                        });
                      },
                      semanticLabel: optionString,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    optionString,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaler: const TextScaler.linear(1.2),
                  ),
                ),
              ],
            ),
          );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: entries,
    );
  }

  DialogTextInput generateNumberInput(Question question) {
    FilteringTextInputFormatter formatter = question.type == AnswerType.integer
        ? TextFormatterBuilder.integerTextFormatter()
        : TextFormatterBuilder.decimalTextFormatter();

    return DialogTextInput(
      onSubmit: (value) {
        question.answer = value;
      },
      label: question.questionText,
      initialText: question.answer?.toString(),
      formatter: formatter,
    );
  }

  Widget generateTextInput(Question question) => DialogTextInput(
        onSubmit: (value) {
          question.answer = value;
        },
        initialText: question.answer.toString(),
        label: question.questionText,
      );

  DropdownMenu generateDropdown(Question question) => DropdownMenu(
        label: Text(question.questionText),
        dropdownMenuEntries: getDropdownOptions(question),
        width: MediaQuery.of(context).size.width - 5,
        onSelected: (value) {
          question.answer = value;
        },
        initialSelection: question.answer,
      );

  Row generateCheckbox(Question question, {Function(bool)? customFallback}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question.questionText,
            textScaler: const TextScaler.linear(1.2),
          ),
          const SizedBox(
            width: 5,
          ),
          Transform.scale(
            scale: 1.5,
            child: Checkbox(
              value: (tryCast(question.answer) ?? false),
              onChanged: (value) {
                setState(() {
                  value ??= false;
                  question.answer = value;
                  customFallback?.call(value!);
                });
              },
              semanticLabel: question.questionText,
            ),
          ),
        ],
      );
}
