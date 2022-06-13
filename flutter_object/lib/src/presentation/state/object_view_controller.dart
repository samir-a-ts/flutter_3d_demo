import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_object/flutter_object.dart';

class ObjectViewController extends ChangeNotifier {
  double? _angleX;
  double? _angleZ;
  double? _angleY;
  double? _offset;
  Vector3D? _vCamera;
  Vector3D? _lightDirection;
  Offset? _translation;

  ObjectViewController({
    double angleX = 0,
    double angleZ = 0,
    double angleY = 0,
    double offset = 3.0,
    Vector3D vCamera = const Vector3D(0, 0, 0),
    Vector3D lightDirection = const Vector3D(0, 0, -1),
    Offset translation = Offset.zero,
  }) {
    _angleX = angleX;
    _angleY = angleY;
    _angleZ = angleZ;
    _offset = offset;
    _vCamera = vCamera;
    _lightDirection = lightDirection;
    _translation = translation;
  }

  double get angleX => _angleX!;

  double get angleY => _angleY!;

  double get angleZ => _angleZ!;

  double get offset => _offset!;

  Vector3D get vCamera => _vCamera!;

  Vector3D get lightDirection => _lightDirection!;

  Offset get translation => _translation!;

  set angleX(double value) {
    if (value == _angleX) return;

    _angleX = value;

    notifyListeners();
  }

  set angleY(double value) {
    if (value == _angleY) return;

    _angleY = value;

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

  set translation(Offset value) {
    if (value == _translation) return;

    _translation = value;

    notifyListeners();
  }
}
