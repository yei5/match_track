abstract class AuthRepository {
  /// Sends a password reset email to [email].
  Future<void> sendPasswordResetEmail(String email);

  /// Signs in a user, returns access token string if successful.
  Future<String> signIn(String email, String password);
}
