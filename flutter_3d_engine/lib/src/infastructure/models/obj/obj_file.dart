import 'package:flutter_3d_engine/src/infastructure/models/3d/vector_3d.dart';
import 'package:flutter_3d_engine/src/infastructure/models/obj/face.dart';
import 'package:flutter_3d_engine/src/infastructure/models/obj/vertex.dart';

/// Class with .OBJ file data.
///
/// Holds all information about faces, vertexes,
/// .MTL textures and normals.
///
class ObjFile {
  final List<Vertex> vertexes;

  final List<Face> faces;

  final bool shadingEnabled;

  // final List<ObjObject> objects;

  // final List<ObjGroup> groups;

  // final Map<String, MtlFile> textureData;

  final List<Vector3D> vertexNormals;

  ObjFile._(
    this.vertexes,
    this.faces,
    this.shadingEnabled,
    // this.objects,
    // this.groups,
    // this.textureData,
    this.vertexNormals,
  );
}
