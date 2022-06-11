import 'package:flutter_object/flutter_object.dart';
import 'package:flutter_object/src/infastructure/models/obj/face.dart';
import 'package:flutter_object/src/infastructure/models/obj/vertex.dart';

/// Class with .OBJ file data.
///
/// Holds all information about faces, vertexes,
/// .MTL textures and normals.
///
class ObjFile {
  final List<Vertex> vertexes;

  final List<Face> faces;

  ObjFile(
    this.vertexes,
    this.faces,
  );

  Mesh toMesh() {
    final polygons = <Polygon>[];

    for (final face in faces) {
      final faceVertexes = face.vertexes;

      final vectors = <Vector3D>[];

      for (final v in faceVertexes) {
        final vertex = vertexes[v.vertexIndex];

        vectors.add(vertex.position);
      }

      polygons.add(
        Polygon(vectors),
      );
    }

    return Mesh(polygons);
  }
}
