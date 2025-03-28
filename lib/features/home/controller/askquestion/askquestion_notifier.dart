import 'package:app/features/home/home.dart';
import 'package:app/shared/utils/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'askquestion_notifier.freezed.dart';
part 'askquestion_notifier.g.dart';
part 'askquestion_state.dart';

@Riverpod(keepAlive: false)
class AskquestionNotifier extends _$AskquestionNotifier {
  late final IAskquestionRepository _askquestionRepository;
  @override
  AskquestionState build() {
    _askquestionRepository = ref.read(askquestionRepoProvider);
    return AskquestionState.initial();
  }

  Future<void> askQuestion(String question, String email, String name) async {
    try {
      state = state.copyWith(status: AskquestionStatus.loading);
      final result = await _askquestionRepository.askQuestion(question, email, name);
      state = state.copyWith(status: AskquestionStatus.success);
    } catch (e) {
      Alert.showSnackBar(e.toString());
      state = state.copyWith(status: AskquestionStatus.error);
    }
  }
}
