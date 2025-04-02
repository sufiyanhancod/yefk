import 'package:app/features/auth/auth.dart';
import 'package:app/shared/shared.dart';
import 'package:app/shared/utils/app_exectpion.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
IAuthRepository authRepo(AuthRepoRef ref) => AuthRepository(ref);

class AuthRepository implements IAuthRepository {
  AuthRepository(this.ref) : _supabaseClient = ref.watch(supabaseProvider);
  final AuthRepoRef ref;
  final SupabaseClient _supabaseClient;

  // @override
  // Future<void> signInWithPhone(String phoneNumber, String name, String email) async {
  //   debugPrint('signInWithPhone: $phoneNumber, $name, $email');
  //   try {
  //     // First check if user exists
  //     final existingUsers = await _supabaseClient.from('users').select().eq('email', email).maybeSingle();

  //     debugPrint('existingUser: $existingUsers');

  //     if (existingUsers != null) {
  //       // User exists, sign in without verification
  //       await _supabaseClient.auth.signInWithPassword(
  //         email: email,
  //         password: 'default_password',
  //       );
  //       return;
  //     }

  //     // If user doesn't exist, create new user with auto-confirm
  //     final authResponse = await _supabaseClient.auth.signUp(
  //       email: email,
  //       password: 'default_password',
  //       emailRedirectTo: null,
  //       data: {
  //         'email_confirmed_at': DateTime.now().toIso8601String(),
  //       },
  //     );

  //     // Get the user ID from the auth response
  //     final userId = authResponse.user?.id;
  //     if (userId == null) throw AppException('Failed to create user');

  //     // Store user details in users table with the auth user ID
  //     await _supabaseClient.from('users').insert({
  //       'id': userId,
  //       'phone': phoneNumber,
  //       'name': name,
  //       'email': email,
  //       'created_at': DateTime.now().toIso8601String(),
  //     });
  //     debugPrint('user created');
  //   } on PostgrestException catch (e) {
  //     debugPrint('PostgrestException: $e');
  //     throw AppException(e.message);
  //   } on AuthException catch (e) {
  //     debugPrint('AuthException: $e');
  //     throw AppException(e.message, code: e.statusCode);
  //   }
  // }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _supabaseClient.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AppException(e.message, code: e.statusCode);
    }
  }

  @override
  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required String userType, // Should be 'MODERATOR' or 'SPEAKER'
  }) async {
    try {
      // Sign up user with auto-confirmation (no email verification)
      final authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'user_type': userType,
          'email_confirmed_at': DateTime.now().toIso8601String(), // Auto-confirm email
          'name': name,
        },
      );

      // Get the user ID from the auth response
      final userId = authResponse.user?.id;
      if (userId == null) throw AppException('Failed to create user');

      // Insert user into the public users table
      await _supabaseClient.from('users').insert({
        'id': userId, // Use the auth user ID
        'name': name,
        'email': email,
        'user_type': userType,
        'created_at': DateTime.now().toIso8601String(),
      });

      // If user is a SPEAKER, add them to the speakers table
      // if (userType == 'SPEAKER') {
      //   // First get the numeric ID from the users table
      //   final userResult = await _supabaseClient.from('users').select('id').eq('id', userId).single();

      //   // Add to speakers table
      //   await _supabaseClient.from('speakers').insert({
      //     'user_id': userResult['id'],
      //     'name': name,
      //   });
      // }

      debugPrint('User created successfully with type: $userType');
    } on PostgrestException catch (e) {
      debugPrint('PostgrestException: $e');
      throw AppException(e.message);
    } on AuthException catch (e) {
      debugPrint('AuthException: $e');
      throw AppException(e.message, code: e.statusCode);
    }
  }
}
