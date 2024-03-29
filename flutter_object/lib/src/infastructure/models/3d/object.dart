import 'package:flutter_object/src/infastructure/models/3d/polygon.dart';

class ObjectModel extends Iterable<Polygon> {
  final List<Polygon> sides;

  const ObjectModel(this.sides);

  @override
  Iterator<Polygon> get iterator => sides.iterator;
}
