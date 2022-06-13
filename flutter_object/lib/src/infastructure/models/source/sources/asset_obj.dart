part of '../object_source.dart';

class _AssetObjectSource extends ObjectSource {
  final String assetPath;

  _AssetObjectSource(this.assetPath);

  @override
  FutureOr<ObjectModel?> get data => _loadAsset(assetPath);

  Future<ObjectModel?> _loadAsset(String path) async {
    try {
      final objFile = await FileReader.loadFromAssets(path);

      return objFile;
    } catch (e) {
      return null;
    }
  }
}
