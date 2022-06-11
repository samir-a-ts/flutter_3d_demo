import 'dart:io';

import 'package:flutter_3d_engine/src/infastructure/models/3d/mesh.dart';
import 'package:flutter_3d_engine/src/infastructure/models/obj/obj_file.dart';
import 'package:flutter_3d_engine/src/infastructure/services/obj_reader_service.dart';

class FileReader {
  static Future<Mesh> loadFile(File file) async {
    switch (file.getFileType()) {
      case "obj":
        final ObjFile objFile = await ObjReader.readFromFile(file);

        return objFile.toMesh();
      default:
        return const Mesh([]);
    }
  }
}

extension _FileExt on File {
  String getFileType() {
    final l = path.length;

    for (int i = l; i > -1; i++) {
      if (path[i] == '.') {
        return path.substring(i + 1, l);
      }
    }

    return "";
  }
}
