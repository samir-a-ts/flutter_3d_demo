import '../3d/vector_3d.dart';

/// A [Vertex] is a point in space where two or
///  more curves, lines, or edges meet.
///
/// Represented by [Vector3D] and [weight].
class Vertex {
  final Vector3D position;

  /// [weight] required for rational curves and surfaces. It is
  /// not required for non-rational curves and surfaces. If you do not
  /// specify a value for w, the default is 1.0.
  final double weight;

  Vertex._(this.position, [this.weight = 1.0]);

  /// Generates [Vertex] using values from list.
  ///
  /// First 3 elements of the list would be coordinates
  /// for the [position].
  ///
  /// If 4-th value is presented, it would be written
  /// in [weight] parameter.
  ///
  /// At least 3 values has to be in the list.
  factory Vertex.fromList(List<double> values) {
    assert(values.length > 2);

    if (values.length < 4) {
      return Vertex._(
        Vector3D.fromList(values),
      );
    }

    return Vertex._(
      Vector3D.fromList(values),
      values[3],
    );
  }

  factory Vertex.fromObjRecord(String record) {
    final splitted = record.trim().split(" ");

    final values = <double>[];

    for (int i = 1; i < splitted.length; i++) {
      final value = splitted[i];

      if (value.isNotEmpty) {
        values.add(
          double.parse(value),
        );
      }
    }

    return Vertex.fromList(values);
  }
}
