import 'package:match_track/core/domain/model/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileDataSource {
  Future<void> createProfile(Profile profile);
}

class ProfileDataSourceImpl extends ProfileDataSource {
  @override
  Future<void> createProfile(Profile profile) async {
    await Supabase.instance.client.from("profiles").insert(profile.toJson());
  }
}