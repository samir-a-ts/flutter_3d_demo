part of '../object_source.dart';

class _AssetObjectSource extends ObjectSource {
  final String assetPath;

  _AssetObjectSource(this.assetPath);

  @override
  FutureOr<Object?> get data => _loadAsset(assetPath);

  Future<Object?> _loadAsset(String path) async {
    try {
      final objFile = await ObjReader.readFromAssets(path);

      return objFile.toObject();
    } catch (e) {
      return null;
    }
  }
}
