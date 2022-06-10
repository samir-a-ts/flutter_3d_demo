import 'package:flutter/cupertino.dart';
import 'package:flutter_3d_engine/flutter_3d_engine.dart';

class ModelController extends ChangeNotifier {
  late double _angleX;
  late double _angleZ;
  late double _offset;
  late Vector3D _vCamera;

  ModelController({
    double angleX = 0,
    double angleZ = 0,
    double offset = 3.0,
    Vector3D vCamera = const Vector3D(0, 0, 0),
  }) {
    _angleX = angleX;
    _angleZ = angleZ;
    _offset = offset;
    _vCamera = vCamera;
  }

  double get angleX => _angleX;

  double get angleZ => _angleZ;

  double get offset => _offset;

  Vector3D get vCamera => _vCamera;

  set angleX(double value) {
    if (value == _angleX) return;

    _angleX = value;

    notifyListeners();
  }

  set angleZ(double value) {
    if (value == _angleZ) return;

    _angleZ = value;

    notifyListeners();
  }

  set offset(double value) {
    if (value == _offset) return;

    _offset = value;

    notifyListeners();
  }

  set vCamera(Vector3D value) {
    if (value == _vCamera) return;

    _vCamera = value;

    notifyListeners();
  }
}
