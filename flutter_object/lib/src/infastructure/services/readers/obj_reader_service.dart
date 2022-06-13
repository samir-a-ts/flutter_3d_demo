import 'package:flutter_object/flutter_object.dart';
import 'package:flutter_object/src/infastructure/models/obj/face.dart';
import 'package:flutter_object/src/infastructure/models/obj/obj_file.dart';
import 'package:flutter_object/src/infastructure/models/obj/vertex.dart';
import 'package:flutter_object/src/infastructure/services/readers/object_reader.dart';

/// Static class that holds
/// .OBJ files parse logic.
class ObjReader extends ObjectReader {
  @override
  Future<ObjectModel> parseRawData(String rawData) {
    final List<String> records = rawData.split("\n");

    final List<Vertex> vertexes = [];

    final List<Face> faces = [];

    for (final record in records) {
      final recordType = record.getFirstSplittedValue(" ");

      switch (recordType) {
        case "v":
          vertexes.add(
            Vertex.fromObjRecord(record),
          );
          break;
        case "f":
          faces.add(
            Face.fromString(record),
          );
          break;
        default:
      }
    }

    return Future.value(ObjFile(vertexes, faces).toObject());
  }
}

extension _StringExt on String {
  String getFirstSplittedValue(String pattern) {
    final pLength = pattern.length;

    for (int i = 0; i < length; i++) {
      if (substring(i, i + pLength) == pattern) {
        return substring(0, i);
      }
    }

    return "";
  }
}
