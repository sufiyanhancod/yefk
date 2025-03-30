import 'package:app/features/home/domain/models/home_models.dart';

abstract class IAudiencehomeRepository {
  Future<List<EventSchedule>> eventSchedule();
  // Future<List<EventSchedule>> moderatorEventSchedule(String userId);
}
