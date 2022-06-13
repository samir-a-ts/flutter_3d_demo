import 'dart:io';

import 'package:flutter_object/src/infastructure/models/3d/object.dart';
import 'package:flutter_object/src/infastructure/services/readers/obj_reader_service.dart';
import 'package:flutter_object/src/infastructure/services/readers/object_reader.dart';

class FileReader {
  static final Map<String, ObjectReader> _readers = {
    "obj": ObjReader(),
  };

  static Future<ObjectModel> loadFromFile(File file) async {
    final type = file.path.getFileType();

    if (_readers.containsKey(type)) return _readers[type]!.readFromFile(file);

    return const ObjectModel([]);
  }

  static Future<ObjectModel> loadFromAssets(String assetsPath) async {
    final type = assetsPath.getFileType();

    if (_readers.containsKey(type)) {
      return _readers[type]!.readFromAssets(assetsPath);
    }

    return const ObjectModel([]);
  }
}

extension _StringExt on String {
  String getFileType() {
    final l = length;

    for (int i = l - 1; i > -1; i--) {
      if (this[i] == '.') {
        return substring(i + 1, l);
      }
    }

    return "";
  }
}
