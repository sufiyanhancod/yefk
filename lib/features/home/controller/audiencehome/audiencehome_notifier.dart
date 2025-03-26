import 'package:app/features/home/domain/repositories/interfaces/audiencehome/i_audiencehome_repository.dart';
import 'package:app/features/home/home.dart';
import 'package:app/shared/utils/alerts.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audiencehome_notifier.freezed.dart';
part 'audiencehome_notifier.g.dart';
part 'audiencehome_state.dart';

@Riverpod(keepAlive: false)
class AudiencehomeNotifier extends _$AudiencehomeNotifier {
  late final IAudiencehomeRepository _audiencehomeRepository;
  @override
  AudiencehomeState build() {
    _audiencehomeRepository = ref.read(audiencehomeRepoProvider);
    return AudiencehomeState.initial();
  }

  Future<void> getEventSchedule() async {
    state = state.copyWith(status: AudiencehomeStatus.loading);
    try {
      final eventSchedule = await _audiencehomeRepository.eventSchedule();
      state = state.copyWith(status: AudiencehomeStatus.success, eventSchedule: eventSchedule);
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(status: AudiencehomeStatus.error);
    }
  }
}
