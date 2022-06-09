import 'dart:math';

import 'package:flutter/cupertino.dart';

/// [Vector3D] is a primitive notion that models an exact
/// location/direction in the three-dimensional space.
class Vector3D {
  /// [Vector3D]'s location/direction at X-axis.
  double x;

  /// [Vector3D]'s location/direction at Y-axis.
  double y;

  /// [Vector3D]'s location/direction at Z-axis.
  double z;

  Vector3D._(this.x, this.y, this.z);

  factory Vector3D(double x, double y, double z) => Vector3D._(x, y, z);

  /// Generates [Vector3D] using values from list.
  ///
  /// First element of the list would be X
  /// coordinate, second - Y coordinate and third - Z.
  ///
  /// At least 3 values has to be in the list.
  factory Vector3D.fromList(List<double> values) {
    assert(values.length > 2);

    return Vector3D._(
      values[0],
      values[1],
      values[2],
    );
  }

  Vector3D operator *(double w) => Vector3D._(x * w, y * w, z * w);

  Vector3D operator /(double w) => Vector3D._(x / w, y / w, z / w);

  Vector3D operator -(Vector3D v) => Vector3D(x - v.x, y - v.y, z - v.z);

  Vector3D normalize() {
    final length = sqrt(x * x + y * y + z * z);

    return Vector3D.copy(this) / length;
  }

  Offset toOffset() => Offset(x, y);

  factory Vector3D.copy(Vector3D point) =>
      Vector3D._(point.x, point.y, point.z);

  factory Vector3D.zero() => Vector3D._(0, 0, 0);

  @override
  String toString() {
    return '($x $y $z)';
  }
}
