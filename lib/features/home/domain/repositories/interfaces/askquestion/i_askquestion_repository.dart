import 'package:app/features/home/domain/models/question_details/questiondetails_model.dart';

abstract class IAskquestionRepository {
  Future<void> askQuestion(String question, String email, String name, int eventId, String questionStatus);
  Future<List<Questiondetails>> getQuestionbyModerator(int eventId, String questionStatus);
  Future<void> updateQuestionStatus(int questionId, String questionStatus);
}
