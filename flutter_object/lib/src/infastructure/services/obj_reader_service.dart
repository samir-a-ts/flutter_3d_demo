// ([^\n]*)(\n)

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_object/src/infastructure/models/obj/face.dart';
import 'package:flutter_object/src/infastructure/models/obj/obj_file.dart';
import 'package:flutter_object/src/infastructure/models/obj/vertex.dart';

/// Static class that holds
/// .OBJ files parse logic.
class ObjReader {
  static Future<ObjFile> readFromString(String rawData) =>
      _parseRawData(rawData);

  static Future<ObjFile> readFromAssets(String assetsPath) async {
    final rawData = await rootBundle.loadString(assetsPath);

    return _parseRawData(rawData);
  }

  static Future<ObjFile> readFromFile(File file) async {
    final rawData = await file.readAsString();

    return _parseRawData(rawData);
  }

  static Future<ObjFile> _parseRawData(String rawData) async {
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

    return ObjFile(vertexes, faces);
  }
}

extension _StringExt on String {
  String getFirstSplittedValue(String pattern) {
    final l = pattern.length;

    for (int i = 0; i < length; i++) {
      if (substring(i, i + l + 1) == pattern) {
        return substring(0, i + 1);
      }
    }

    return "";
  }
}
