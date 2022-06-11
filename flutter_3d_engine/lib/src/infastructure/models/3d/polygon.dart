import 'package:flutter/material.dart';
import 'package:flutter_3d_engine/src/infastructure/models/3d/vector_3d.dart';

/// A surface in 3D space
/// represented by a set of [Vector3D]'s.
///
class Polygon extends Iterable<Vector3D> {
  final List<Vector3D> points;

  final Color color;

  const Polygon(this.points, [this.color = Colors.grey]);

  @override
  Iterator<Vector3D> get iterator => points.iterator;

  Vector3D operator [](int index) => points[index];

  Path toPath() {
    final offsets = <Offset>[];

    for (final point in points) {
      offsets.add(Offset(point.x, point.y));
    }

    return Path()..addPolygon(offsets, true);
  }

  Vector3D calculateNormal() {
    Vector3D line1 = this[1] - this[0], line2 = this[2] - this[0];

    // Use Cross-Product to get surface normal

    Vector3D normal = Vector3D(
      line1.y * line2.z - line1.z * line2.y,
      line1.z * line2.x - line1.x * line2.z,
      line1.x * line2.y - line1.y * line2.x,
    );

    return normal.normalize();
  }
}
