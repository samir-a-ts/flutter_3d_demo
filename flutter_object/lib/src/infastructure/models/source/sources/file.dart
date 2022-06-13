part of '../object_source.dart';

class _FileObjectSource extends ObjectSource {
  final File file;

  _FileObjectSource(this.file);

  @override
  FutureOr<Object?> get data => _loadFile(file);

  Future<Object?> _loadFile(File file) async {
    try {
      final result = await FileReader.loadFile(file);

      return result;
    } catch (e) {
      return null;
    }
  }
}
