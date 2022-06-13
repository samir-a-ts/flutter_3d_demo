import 'dart:io';

import 'package:flutter_object/src/infastructure/models/3d/object.dart';
import 'package:flutter_object/src/infastructure/models/obj/obj_file.dart';
import 'package:flutter_object/src/infastructure/services/obj_reader_service.dart';

class FileReader {
  static Future<Object> loadFile(File file) async {
    switch (file.getFileType()) {
      case "obj":
        final ObjFile objFile = await ObjReader.readFromFile(file);

        return objFile.toObject();
      default:
        return const Object([]);
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
