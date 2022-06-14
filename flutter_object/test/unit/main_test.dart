import 'package:flutter_test/flutter_test.dart';

import 'calculation_tests.dart';
import 'loader_tests.dart';
import 'sources_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  loaderTest();

  calculationTests();

  sourcesTest();
}
