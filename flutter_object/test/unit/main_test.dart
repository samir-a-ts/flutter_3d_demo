import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_object/flutter_object.dart';
import 'package:flutter_object/src/core/math/matrix.dart';
import 'package:flutter_test/flutter_test.dart';

part 'loader_tests.dart';
part 'sources_test.dart';
part 'calculation_tests.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  _testMath();

  _testFileLoaders();

  _testObjectSources();
}
