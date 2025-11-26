import 'dart:typed_data';

abstract class FileSaver {
  Future<void> saveAndOpenFile(
    Uint8List bytes,
    String fileName,
    String mimeType,
  );
}