import 'package:app/features/home/domain/models/question_details/questiondetails_model.dart';

abstract class IAskquestionRepository {
  Future<void> askQuestion(String question, String email, String name, int eventId, String questionStatus);
  Future<List<Questiondetails>> getQuestionbyModerator(int eventId, String questionStatus);
  Future<void> updateQuestionStatus(int questionId, String questionStatus);
  Future<List<Questiondetails>> getQuestionbySpeaker(String userId, String questionStatus);
  Future<void> updateEventStatus(int eventId, String eventStatus);
  Future<List<Questiondetails>> getPreviousQuestions(String email, int eventId);
  Stream<List<Questiondetails>> subscribeToQuestions(String userId);
  Stream<List<Questiondetails>> subscribeToModeratorQuestions(int eventId, String questionStatus);
  void disposeSubscription();
}
