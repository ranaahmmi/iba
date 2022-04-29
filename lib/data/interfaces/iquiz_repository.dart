import 'package:iba/data/models/quiz_model.dart';

abstract class IquizRepository {
  Future<List<QuizModel>> fatchQuiz();
}
