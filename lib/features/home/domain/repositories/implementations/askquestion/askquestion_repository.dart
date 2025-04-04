import 'dart:async';

import 'package:app/shared/providers/supabase_provider/supabase_provider.dart';
import 'package:app/shared/utils/app_exectpion.dart';
import 'package:flutter/material.dart';
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
  RealtimeChannel? _questionSubscription;

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

  @override
  Future<List<Questiondetails>> getQuestionbySpeaker(String userId, String questionStatus) async {
    try {
      final response = await _supabaseClient.from('question_details_view').select('*').eq('speaker_id', userId).inFilter('question_status', ['ACCEPTED', 'ANSWERED']).order('question_status', ascending: false);

      return response.map(Questiondetails.fromJson).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> updateEventStatus(int eventId, String eventStatus) async {
    try {
      final response = await _supabaseClient.from('events').update({'event_status': eventStatus}).eq('id', eventId);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<Questiondetails>> getPreviousQuestions(String email, int eventId) async {
    try {
      final response = await _supabaseClient.from('question_details_view').select('*').eq('user_email', email).eq('event_id', eventId).order('created_at', ascending: false);
      return response.map(Questiondetails.fromJson).toList();
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Stream<List<Questiondetails>> subscribeToQuestions(String userId) {
    final controller = StreamController<List<Questiondetails>>();

    _questionSubscription = _supabaseClient
        .channel('public:question_details_view')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'questions',
          callback: (payload) async {
            try {
              final response = await _supabaseClient.from('question_details_view').select('*').eq('speaker_id', userId).inFilter('question_status', ['ACCEPTED', 'ANSWERED']).order('question_status', ascending: false);

              controller.add(response.map(Questiondetails.fromJson).toList());
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        )
        .subscribe();

    return controller.stream;
  }

  @override
  Stream<List<Questiondetails>> subscribeToModeratorQuestions(int eventId, String questionStatus) {
    final controller = StreamController<List<Questiondetails>>();

    _questionSubscription = _supabaseClient
        .channel('public:question_details_view')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'questions',
          callback: (payload) async {
            try {
              final response = await _supabaseClient.from('question_details_view').select('*').eq('event_id', eventId).eq('question_status', questionStatus);
              controller.add(response.map(Questiondetails.fromJson).toList());
            } catch (e) {
              debugPrint(e.toString());
            }
          },
        )
        .subscribe();

    return controller.stream;
  }

  @override
  void disposeSubscription() {
    _questionSubscription?.unsubscribe();
  }
}
