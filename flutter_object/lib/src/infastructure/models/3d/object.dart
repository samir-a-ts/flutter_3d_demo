import 'package:flutter_object/src/infastructure/models/3d/polygon.dart';

class Object extends Iterable<Polygon> {
  final List<Polygon> sides;

  const Object(this.sides);

  @override
  Iterator<Polygon> get iterator => sides.iterator;
}
