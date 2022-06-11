part of '../object_source.dart';

class _AssetObjectSource extends ObjectSource {
  final String assetPath;

  _AssetObjectSource(this.assetPath);

  @override
  FutureOr<Mesh?> get data => _loadAsset(assetPath);

  Future<Mesh?> _loadAsset(String path) async {
    try {
      final objFile = await ObjReader.readFromAssets(path);

      return objFile.toMesh();
    } catch (e) {
      return null;
    }
  }
}
