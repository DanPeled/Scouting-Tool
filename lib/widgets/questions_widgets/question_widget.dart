// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:scouting_site/services/cast.dart';
import 'package:scouting_site/services/formatters/text_formatter_builder.dart';
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_text_input.dart';
import 'package:scouting_site/widgets/dialog_widgets/dialog_toggle_switch.dart';
import 'package:scouting_site/widgets/questions_widgets/camera_widget.dart';
import 'package:scouting_site/widgets/questions_widgets/counter_widget.dart';
import 'package:scouting_site/widgets/questions_widgets/multiplechoice_widget.dart';

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
        for (Object? option in widget._question.options!) {
          optionsValues[option.toString()] = false;
        }
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

    for (Object? option in question.options!) {
      entries.add(
          DropdownMenuEntry(value: option, label: option?.toString() ?? ""));
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
      case AnswerType.counter:
        return generateCounter(question);
      case AnswerType.photo:
        return generatePhotoWidget(question);
    }
  }

  Widget generatePhotoWidget(Question question) {
    return CameraCaptureWidget(
      onImageCaptured: (Uint8List image) async {
        question.answer = base64Encode(image);
      },
    );
  }

  Widget generateMultipleChoice(Question question) {
    return MultiplechoiceWidget(
      options:
          question.options!.map((option) => option?.toString() ?? "").toList(),
      label: question.questionText,
      onValueChanged: (values) {
        Map<String, bool> answers = {};
        for (int i = 0; i < values.length; i++) {
          answers.addEntries(
              [MapEntry(question.options?[i].toString() ?? "", values[i])]);
        }

        question.answer = answers;
      },
    );
  }

  DialogTextInput generateNumberInput(Question question) {
    FilteringTextInputFormatter formatter = question.type == AnswerType.integer
        ? TextFormatterBuilder.integerTextFormatter()
        : TextFormatterBuilder.decimalTextFormatter();

    return DialogTextInput(
      onSubmit: (value) {
        if (question.type == AnswerType.integer) {
          question.answer = int.parse(value);
        } else if (question.type == AnswerType.number) {
          question.answer = num.parse(value);
        }
      },
      label: question.questionText,
      initialText: question.answer?.toString(),
      formatter: formatter,
      keyboard: question.type == AnswerType.integer
          ? TextInputType.number
          : const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
    );
  }

  Widget generateTextInput(Question question) => DialogTextInput(
        onSubmit: (value) {
          question.answer = value;
        },
        initialText: question.answer?.toString(),
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

  Widget generateCheckbox(Question question,
          {Function(bool)? customFallback}) =>
      SizedBox(
        height: 40,
        width: 500,
        child: DialogToggleSwitch(
          onToggle: (value) {
            setState(() {
              question.answer = value;
            });
          },
          textScaler: const TextScaler.linear(1.2),
          label: question.questionText,
          initialValue: (question.answer ?? false) as bool,
        ),
      );

  Widget generateCounter(Question question) {
    String maxString = question.options?[2]?.toString() ?? "";
    String minString = question.options?[1]?.toString() ?? "";

    int getCurrentValue() => int.parse(question.answer?.toString() ?? "0");

    int? max;
    int? min;

    int currentValue = getCurrentValue();

    if (maxString != "") {
      max = int.parse(maxString);
      if (currentValue > max) {
        question.answer = max;
      }
    }
    if (minString != "") {
      min = int.parse(minString);
      if (currentValue < min) {
        question.answer = min;
      }
    }

    question.answer ??= question.options?[0] ?? min;

    currentValue = getCurrentValue();

    return CounterWidget(
      min: min,
      max: max,
      intialValue: currentValue,
      label: question.questionText,
      onValueChanged: (value) {
        question.answer = value;
      },
    );
  }
}
