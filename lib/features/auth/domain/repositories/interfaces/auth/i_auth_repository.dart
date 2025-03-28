abstract class IAuthRepository {
  Future<void> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
    required String userType, // Should be 'MODERATOR' or 'SPEAKER'
  });
}
