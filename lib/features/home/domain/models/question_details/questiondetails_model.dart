import 'package:freezed_annotation/freezed_annotation.dart';

part 'questiondetails_model.freezed.dart';
part 'questiondetails_model.g.dart';

@freezed
class Questiondetails with _$Questiondetails {
  const factory Questiondetails({
    @JsonKey(name: 'question_id') int? questionId,
    @JsonKey(name: 'question_text') String? questionText,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'user_email') String? userEmail,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'question_status') String? questionStatus,
    @JsonKey(name: 'event_id') int? eventId,
    @JsonKey(name: 'event_name') String? eventName,
    @JsonKey(name: 'speaker_id') String? speakerId,
    @JsonKey(name: 'speaker_name') String? speakerName,
  }) = _Questiondetails;

  factory Questiondetails.fromJson(Map<String, dynamic> json) => _$QuestiondetailsFromJson(json);
}
