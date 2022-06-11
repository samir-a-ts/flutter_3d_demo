import 'package:flutter/cupertino.dart';
import 'package:flutter_3d_engine/flutter_3d_engine.dart';

class ModelController extends ChangeNotifier {
  Mesh? _mesh;
  double? _angleX;
  double? _angleZ;
  double? _offset;
  Vector3D? _vCamera;
  Vector3D? _lightDirection;

  ModelController({
    Mesh? mesh,
    double angleX = 0,
    double angleZ = 0,
    double offset = 3.0,
    Vector3D vCamera = const Vector3D(0, 0, 0),
    Vector3D lightDirection = const Vector3D(0, 0, -1),
  }) {
    _angleX = angleX;
    _angleZ = angleZ;
    _offset = offset;
    _vCamera = vCamera;
    _lightDirection = lightDirection;
    _mesh = mesh;
  }

  Mesh? get mesh => _mesh;

  double get angleX => _angleX!;

  double get angleZ => _angleZ!;

  double get offset => _offset!;

  Vector3D get vCamera => _vCamera!;

  Vector3D get lightDirection => _lightDirection!;

  set mesh(Mesh? mesh) {
    _mesh = mesh;

    notifyListeners();
  }

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

  set lightDirection(Vector3D value) {
    if (value == _lightDirection) return;

    _lightDirection = value;

    notifyListeners();
  }
}
