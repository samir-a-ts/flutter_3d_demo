import 'package:flutter_object/src/infastructure/models/3d/polygon.dart';

class Mesh extends Iterable<Polygon> {
  final List<Polygon> sides;

  const Mesh(this.sides);

  @override
  Iterator<Polygon> get iterator => sides.iterator;
}
