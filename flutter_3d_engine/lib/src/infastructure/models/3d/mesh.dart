import 'dart:math';

import 'package:flutter_3d_engine/src/core/utils/tuple.dart';
import 'package:flutter_3d_engine/src/infastructure/models/3d/polygon.dart';

class Mesh extends Iterable<Polygon> {
  final List<Polygon> sides;

  Mesh._(this.sides);

  factory Mesh(List<Polygon> sides) {
    return Mesh._(sides);
  }

  @override
  Iterator<Polygon> get iterator => sides.iterator;

  Tuple<double, double> getMaxPointCoordinates() {
    double mWidth = 0, mHeight = 0;

    for (final polygon in this) {
      for (final point in polygon) {
        mWidth = max(point.x, mWidth.abs());
        mHeight = max(point.y, mHeight.abs());
      }
    }

    return Tuple(mWidth, mHeight);
  }
}
