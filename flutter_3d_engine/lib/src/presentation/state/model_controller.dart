import 'package:flutter/cupertino.dart';

class ModelController extends ChangeNotifier {
  late double _angleX;
  late double _angleZ;
  late double _offset;

  ModelController({
    double angleX = 0,
    double angleZ = 0,
    double offset = 3.0,
  }) {
    _angleX = angleX;
    _angleZ = angleZ;
    _offset = offset;
  }

  double get angleX => _angleX;

  double get angleZ => _angleZ;

  double get offset => _offset;

  set angleX(double value) {
    if (value != _angleX) {
      _angleX = value;

      notifyListeners();
    }
  }

  set angleZ(double value) {
    if (value != _angleZ) {
      _angleZ = value;

      notifyListeners();
    }
  }

  set offset(double value) {
    if (value != _offset) {
      _offset = value;

      notifyListeners();
    }
  }
}
