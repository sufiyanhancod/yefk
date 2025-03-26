import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_scedule_model.freezed.dart';
part 'event_scedule_model.g.dart';

@freezed
class EventSchedule with _$EventSchedule {
  const factory EventSchedule({
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_name') required String eventName,
    required int day,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'event_status') required bool eventStatus,
    @JsonKey(name: 'speaker_id') required int speakerId,
    @JsonKey(name: 'speaker_name') required String speakerName,
    @JsonKey(name: 'question_count') required int questionCount,
    @JsonKey(name: 'pending_questions_count') required int pendingQuestionsCount,
  }) = _EventSchedule;

  factory EventSchedule.fromJson(Map<String, dynamic> json) => _$EventScheduleFromJson(json);
}
