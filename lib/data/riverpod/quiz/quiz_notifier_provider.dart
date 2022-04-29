import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/repository/quiz_repository.dart';

import 'package:iba/data/riverpod/quiz/quiz_notifier.dart';
import 'package:iba/data/riverpod/quiz/quiz_state.dart';

final quizRepositoryProvider = Provider((ref) => QuizRepository());

final quizNotifierProvider =
    StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.watch(quizRepositoryProvider));
});
