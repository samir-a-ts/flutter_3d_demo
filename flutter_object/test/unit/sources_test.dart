import 'dart:io';

import 'package:flutter_object/src/infastructure/models/source/object_source.dart';
import 'package:flutter_test/flutter_test.dart';

void sourcesTest() {
  group("Getting Object via ObjectSource model:", () {
    test("From file", () async {
      final file = File("test_resources/cube.obj");

      final source = ObjectSource.fromFile(file);

      final result = await source.data;

      expect(result?.length, greaterThan(0));
    });

    test("File not existed", () async {
      final file = File("test_resources/unknown.obj");

      final source = ObjectSource.fromFile(file);

      final result = await source.data;

      expect(result, equals(null));
    });

    test("From assets", () async {
      final source = ObjectSource.fromAssets("assets/cube.obj");

      final result = await source.data;

      expect(result?.length, greaterThan(0));
    });

    test("Assets file not existed", () async {
      final source = ObjectSource.fromAssets("assets/unknown.obj");

      final result = await source.data;

      expect(result, equals(null));
    });
  });
}
