import 'dart:async';

import 'package:app/features/home/home.dart';
import 'package:app/shared/utils/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'askquestion_notifier.freezed.dart';
part 'askquestion_notifier.g.dart';
part 'askquestion_state.dart';

@Riverpod(keepAlive: false)
class AskquestionNotifier extends _$AskquestionNotifier {
  late final IAskquestionRepository _askquestionRepository;
  @override
  AskquestionState build() {
    _askquestionRepository = ref.read(askquestionRepoProvider);
    return AskquestionState.initial();
  }

  Future<void> askQuestion({
    required String question,
    required String email,
    required String name,
    required int eventId,
    required String questionStatus,
  }) async {
    try {
      state = state.copyWith(status: AskquestionStatus.loading);
      await _askquestionRepository.askQuestion(question, email, name, eventId, questionStatus);
      state = state.copyWith(status: AskquestionStatus.success);
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(status: AskquestionStatus.error);
    }
  }

  Future<void> getQuestionbyModerator(int eventId, String questionStatus) async {
    try {
      state = state.copyWith(status: AskquestionStatus.loading);
      final question = await _askquestionRepository.getQuestionbyModerator(eventId, questionStatus);
      state = state.copyWith(status: AskquestionStatus.success, question: question);
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(status: AskquestionStatus.error);
    }
  }

  Future<void> updateQuestionStatus(int questionId, String questionStatus, int eventId) async {
    try {
      state = state.copyWith(status: AskquestionStatus.loading);
      await _askquestionRepository.updateQuestionStatus(questionId, questionStatus);
      unawaited(getQuestionbyModerator(eventId, 'PENDING'));
      state = state.copyWith(status: AskquestionStatus.success);
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(status: AskquestionStatus.error);
    }
  }
}
