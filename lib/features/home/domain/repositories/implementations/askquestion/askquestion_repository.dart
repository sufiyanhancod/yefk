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
  Future<void> askQuestion(String question, String email, String name) async {
    try {
      final response = await _supabaseClient.from('questions').insert({
        'question': question,
        'email': email,
        'name': name,
      });
      return response;
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
