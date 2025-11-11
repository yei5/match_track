import 'package:match_track/features/auth/data/repository/auth_repository_impl.dart';
import 'package:match_track/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository = AuthRepositoryImpl();
  GetCurrentUserUsecase();

  Future<User?> call() async {
    return await repository.currentUser();
  }
}