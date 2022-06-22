import 'package:flutter_object/src/infastructure/models/3d/vector_3d.dart';

class ProjectionData {
  final double width;
  final double height;
  final double angleX;
  final double angleZ;
  final double angleY;
  final double offset;
  final Vector3D vCamera;
  final Vector3D lightDirection;

  ProjectionData(
    this.width,
    this.height,
    this.angleX,
    this.angleY,
    this.angleZ,
    this.offset,
    this.vCamera,
    this.lightDirection,
  );
}
