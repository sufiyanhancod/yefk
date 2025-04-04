import 'dart:async';

import 'package:app/features/home/home.dart';
import 'package:app/shared/providers/supabase_provider/supabase_provider.dart';
import 'package:app/shared/utils/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'askquestion_notifier.freezed.dart';
part 'askquestion_notifier.g.dart';
part 'askquestion_state.dart';

@Riverpod(keepAlive: true)
class AskquestionNotifier extends _$AskquestionNotifier {
  late final IAskquestionRepository _askquestionRepository;
  StreamSubscription<List<Questiondetails>>? _subscription;

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

  Future<void> getQuestionbySpeaker(String userId, String questionStatus) async {
    try {
      state = state.copyWith(status: AskquestionStatus.loading);
      final question = await _askquestionRepository.getQuestionbySpeaker(userId, questionStatus);
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

  Future<void> updatespeackerQStatus(int questionId, String questionStatus, String userId) async {
    try {
      state = state.copyWith(status: AskquestionStatus.loading);
      await _askquestionRepository.updateQuestionStatus(questionId, questionStatus);
      unawaited(getQuestionbySpeaker(userId, 'PENDING'));
      state = state.copyWith(status: AskquestionStatus.success);
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(status: AskquestionStatus.error);
    }
  }

  Future<bool> updateEventStatus(int eventId, String eventStatus) async {
    try {
      state = state.copyWith(eventStatus: AskquestionStatus.loading);
      await _askquestionRepository.updateEventStatus(eventId, eventStatus);

      state = state.copyWith(eventStatus: AskquestionStatus.success);
      return true;
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(eventStatus: AskquestionStatus.error);
      return false;
    }
  }

  Future<void> getPreviousQuestions(String email, int eventId) async {
    try {
      state = state.copyWith(status: AskquestionStatus.loading);
      final question = await _askquestionRepository.getPreviousQuestions(email, eventId);
      state = state.copyWith(status: AskquestionStatus.success, question: question);
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(status: AskquestionStatus.error);
    }
  }

  void subscribeToQuestions(String userId) async {
    state = state.copyWith(status: AskquestionStatus.loading);

    // Fetch initial data immediately
    try {
      final initialQuestions = await _askquestionRepository.getQuestionbySpeaker(userId, 'ACCEPTED');
      state = state.copyWith(
        status: AskquestionStatus.success,
        question: initialQuestions,
      );
    } catch (e) {
      Alert.showSnackBar(e.toString());
    }

    // Set up subscription for future updates
    _subscription = _askquestionRepository.subscribeToQuestions(userId).listen(
      (questions) {
        state = state.copyWith(
          status: AskquestionStatus.subscribed,
          question: questions,
        );
      },
      onError: (error) {
        Alert.showSnackBar(error.toString());
        state = state.copyWith(status: AskquestionStatus.error);
      },
    );
  }

  Future<void> subscribeToModeratorQuestions(int eventId) async {
    state = state.copyWith(status: AskquestionStatus.loading);

    // Fetch initial data immediately
    try {
      final initialQuestions = await _askquestionRepository.getQuestionbyModerator(eventId, 'PENDING');
      state = state.copyWith(
        // Use success status initially, then subscribed upon receiving stream updates
        status: initialQuestions.isEmpty ? AskquestionStatus.success : AskquestionStatus.subscribed,
        question: initialQuestions,
      );
    } catch (e) {
      Alert.showSnackBar(e.toString());
      // Set status to error if initial fetch fails, but still attempt subscription
      state = state.copyWith(status: AskquestionStatus.error);
    }

    // Cancel any existing subscription before starting a new one
    _subscription?.cancel();
    // Set up subscription for future updates
    _subscription = _askquestionRepository.subscribeToModeratorQuestions(eventId, 'PENDING').listen(
      (questions) {
        state = state.copyWith(
          status: AskquestionStatus.subscribed, // Keep status as subscribed
          question: questions,
        );
      },
      onError: (error) {
        Alert.showSnackBar(error.toString());
        state = state.copyWith(status: AskquestionStatus.error);
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
    _askquestionRepository.disposeSubscription();
    // super.dispose(); // Call super.dispose() if AskquestionNotifier extends AutoDisposeNotifier or similar
  }
}
