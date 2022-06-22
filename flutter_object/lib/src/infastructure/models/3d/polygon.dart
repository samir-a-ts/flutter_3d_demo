import 'package:flutter_object/src/infastructure/models/3d/vector_3d.dart';

/// A surface in 3D space
/// represented by a set of [Vector3D]'s.
///
class Polygon extends Iterable<Vector3D> {
  final List<Vector3D> points;

  final List<double> rgbo;

  const Polygon(
    this.points, [
    this.rgbo = const [158, 158, 158, 1],
  ]);

  @override
  Iterator<Vector3D> get iterator => points.iterator;

  Vector3D operator [](int index) => points[index];

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

  Polygon copyWith({
    List<Vector3D>? points,
    List<double>? rgbo,
  }) {
    return Polygon(
      points ?? this.points,
      rgbo ?? this.rgbo,
    );
  }
}
