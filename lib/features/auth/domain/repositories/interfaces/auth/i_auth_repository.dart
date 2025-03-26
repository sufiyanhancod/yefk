abstract class IAuthRepository {
  Future<void> signInWithPhone(String phoneNumber, String name, String email);
  Future<void> signOut();
}
