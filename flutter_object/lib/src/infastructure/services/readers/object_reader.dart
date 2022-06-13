import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_object/flutter_object.dart';

abstract class ObjectReader {
  Future<ObjectModel> readFromAssets(String assetsPath) async {
    final rawData = await rootBundle.loadString(assetsPath);

    return parseRawData(rawData);
  }

  Future<ObjectModel> readFromFile(File file) async {
    final rawData = await file.readAsString();

    return parseRawData(rawData);
  }

  @protected
  Future<ObjectModel> parseRawData(String rawData);
}
