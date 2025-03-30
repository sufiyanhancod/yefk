import 'package:app/shared/providers/supabase_provider/supabase_provider.dart';
import 'package:app/shared/utils/app_exectpion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/home/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'askquestion_repository.g.dart';

@Riverpod(keepAlive: true)
IAskquestionRepository askquestionRepo(AskquestionRepoRef ref) => AskquestionRepository(ref);

class AskquestionRepository implements IAskquestionRepository {
  AskquestionRepository(this.ref) : _supabaseClient = ref.watch(supabaseProvider);
  final SupabaseClient _supabaseClient;
  final AskquestionRepoRef ref;

  @override
  Future<void> askQuestion(String question, String email, String name, int eventId, String questionStatus) async {
    try {
      final response = await _supabaseClient.from('questions').insert({
        'event_id': eventId,
        'question_text': question,
        'user_email': email,
        'name': name,
        'question_status': questionStatus,
      });
      return response;
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<Questiondetails>> getQuestionbyModerator(int eventId, String questionStatus) async {
    try {
      final response = await _supabaseClient.from('question_details_view').select('*').eq('event_id', eventId).eq('question_status', questionStatus);
      return response.map(Questiondetails.fromJson).toList();
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> updateQuestionStatus(int questionId, String questionStatus) async {
    try {
      final response = await _supabaseClient.from('questions').update({'question_status': questionStatus}).eq('id', questionId);
      return response;
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
