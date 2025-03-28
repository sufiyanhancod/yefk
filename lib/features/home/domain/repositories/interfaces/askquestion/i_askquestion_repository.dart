abstract class IAskquestionRepository {
  Future<void> askQuestion(String question, String email, String name);
}
