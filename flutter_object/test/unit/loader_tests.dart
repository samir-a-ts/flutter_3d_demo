import 'dart:io';

import 'package:flutter_object/src/infastructure/services/file_reader_service.dart';
import 'package:flutter_test/flutter_test.dart';

void loaderTest() {
  group("Reading ObjectModel via source:", () {
    test("From file", () async {
      final file = File("test_resources/cube.obj");

      final result = await FileReader.loadFromFile(file);

      expect(result.length, greaterThan(0));
    });

    test("From assets", () async {
      final result = await FileReader.loadFromAssets("assets/cube.obj");

      expect(result.length, greaterThan(0));
    });
  });
}
