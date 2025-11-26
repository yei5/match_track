import 'dart:io';
import 'dart:typed_data';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:match_track/utils/file_saver_interface.dart';

class FileSaverPlatformImpl implements FileSaver {
  @override
  Future<void> saveAndOpenFile(
      Uint8List bytes, String fileName, String mimeType) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(bytes);

    await OpenFilex.open(file.path);
  }
}
