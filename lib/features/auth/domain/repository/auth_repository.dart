import 'package:match_track/core/domain/model/profile.dart';

abstract class AuthRepository {
  Future<void> registerUser(Profile profile, String password);
}