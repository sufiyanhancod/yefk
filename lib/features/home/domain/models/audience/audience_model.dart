import 'package:freezed_annotation/freezed_annotation.dart';

part 'audience_model.freezed.dart';
part 'audience_model.g.dart';

@freezed
class Audience with _$Audience {
  const factory Audience({
    @JsonKey(name: 'id', includeIfNull: false) int? id,
  }) = _Audience;

  factory Audience.fromJson(Map<String, dynamic> json) =>
      _$AudienceFromJson(json);
}
