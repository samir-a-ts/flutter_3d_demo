import 'dart:math';

/// [Vector3D] is a primitive notion that models an exact
/// location/direction in the three-dimensional space.
class Vector3D {
  /// [Vector3D]'s location/direction at X-axis.
  final double x;

  /// [Vector3D]'s location/direction at Y-axis.
  final double y;

  /// [Vector3D]'s location/direction at Z-axis.
  final double z;

  const Vector3D(this.x, this.y, this.z);

  /// Generates [Vector3D] using values from list.
  ///
  /// First element of the list would be X
  /// coordinate, second - Y coordinate and third - Z.
  ///
  /// At least 3 values has to be in the list.
  factory Vector3D.fromList(List<double> values) {
    assert(values.length > 2);

    return Vector3D(
      values[0],
      values[1],
      values[2],
    );
  }

  Vector3D operator *(double w) => Vector3D(x * w, y * w, z * w);

  Vector3D operator /(double w) => Vector3D(x / w, y / w, z / w);

  Vector3D operator -(Vector3D v) => Vector3D(x - v.x, y - v.y, z - v.z);

  Vector3D normalize() {
    final length = sqrt(x * x + y * y + z * z);

    return Vector3D.copy(this) / length;
  }

  factory Vector3D.copy(Vector3D point) => Vector3D(point.x, point.y, point.z);

  static const zero = Vector3D(0, 0, 0);

  Vector3D copy({
    double? x,
    double? y,
    double? z,
  }) =>
      Vector3D(
        x ?? this.x,
        y ?? this.y,
        z ?? this.x,
      );

  @override
  String toString() {
    return '($x $y $z)';
  }

  @override
  bool operator ==(Object other) =>
      other is Vector3D && other.x == x && other.y == y && other.z == z;

  @override
  int get hashCode => ((x + y + z) * 10000).floor();
}
