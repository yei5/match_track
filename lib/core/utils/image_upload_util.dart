import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ImageUploadUtil {
  static Future<String?> uploadImageToSupabase({
    required Uint8List bytes,
    required String bucketName,
    required String folderPath,
    String? fileExtension,
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('User not logged in. Cannot upload image.');
        return null;
      }

      final Uuid uuid = const Uuid();
      final String fileName = '${uuid.v4()}.${fileExtension ?? 'jpg'}';
      final String filePath = '$folderPath/$fileName';

      await Supabase.instance.client.storage.from(bucketName).uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: 'image/${fileExtension ?? 'jpeg'}'),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(Uri.encodeFull(filePath));;
      return publicUrl;
    } catch (e) {
      debugPrint('Error uploading image to Supabase: $e');
      return null;
    }
  }
}
