part of '../object_source.dart';

class _FileObjectSource extends ObjectSource {
  final File file;

  _FileObjectSource(this.file);

  @override
  FutureOr<ObjectModel?> get data => _loadFile(file);

  Future<ObjectModel?> _loadFile(File file) async {
    try {
      final result = await FileReader.loadFromFile(file);

      return result;
    } catch (e) {
      return null;
    }
  }
}
