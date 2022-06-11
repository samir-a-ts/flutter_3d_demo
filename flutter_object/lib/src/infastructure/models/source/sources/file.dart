part of '../object_source.dart';

class FileObjectSource extends ObjectSource {
  final File file;

  FileObjectSource(this.file);

  @override
  FutureOr<Mesh?> get data => _loadFile(file);

  Future<Mesh?> _loadFile(File file) async {
    try {
      final result = await FileReader.loadFile(file);

      return result;
    } catch (e) {
      return null;
    }
  }
}
