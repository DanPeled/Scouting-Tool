// Project imports:
import 'package:scouting_site/services/scouting/question.dart';
import 'package:scouting_site/services/cast.dart';

class FormPageData {
  String pageName;
  final List<Question> questions;
  final double score;

  FormPageData({
    required this.pageName,
    required this.questions,
    this.score = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageName': pageName,
      'questions': questions.map((q) => q.toJson()).toList(),
      'score': evaluate(),
    };
  }

  static FormPageData fromJson(Map<String, dynamic> json) {
    return FormPageData(
      pageName: tryCast(json['pageName']) ?? "",
      questions: tryCast(json['questions'], defaultValue: [])!
          .map((item) => Question.fromJson(item))
          .toList(),
      score: tryCast(json['score']) ?? 0.0,
    );
  }

  double evaluate() {
    double res = 0;

    for (Question q in questions) {
      res += q.evaluate();
    }

    return res;
  }
}
