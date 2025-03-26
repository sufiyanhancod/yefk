import 'package:app/shared/providers/supabase_provider/supabase_provider.dart';
import 'package:app/shared/utils/app_exectpion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/features/home/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'audiencehome_repository.g.dart';

@Riverpod(keepAlive: true)
IAudiencehomeRepository audiencehomeRepo(AudiencehomeRepoRef ref) => AudiencehomeRepository(ref);

class AudiencehomeRepository implements IAudiencehomeRepository {
  AudiencehomeRepository(this.ref) : _supabaseClient = ref.watch(supabaseProvider);
  final AudiencehomeRepoRef ref;
  final SupabaseClient _supabaseClient;

  @override
  Future<List<EventSchedule>> eventSchedule() async {
    try {
      final response = await _supabaseClient.from('event_schedule_view').select();
      return response.map((e) => EventSchedule.fromJson(e)).toList();
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
