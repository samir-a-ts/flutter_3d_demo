import 'dart:math';

import 'package:vector_math/vector_math_64.dart';
import 'package:flutter_object/src/core/math/matrix.dart';
import 'package:flutter_object/src/infastructure/models/3d/object.dart';
import 'package:flutter_object/src/infastructure/models/3d/polygon.dart';
import 'package:flutter_object/src/infastructure/models/3d/vector_3d.dart';

Future<ObjectModel> projectObject({
  required ObjectModel object,
  required double width,
  required double height,
  Vector3D vCamera = Vector3D.zero,
  Vector3D lightDirection = const Vector3D(0, 0, -1),
  double offset = 3.0,
  double angleX = 0,
  double angleZ = 0,
  double angleY = 0,
}) async {
  final rotatedPolygons = <Polygon>[];

  final cosAngleZ = cos(angleZ);
  final sinAngleZ = sin(angleZ);

  final Matrix4 rotationMatrixZ = Matrix4.zero();

  rotationMatrixZ.setEntry(0, 0, cosAngleZ);
  rotationMatrixZ.setEntry(0, 1, sinAngleZ);
  rotationMatrixZ.setEntry(1, 0, -sinAngleZ);
  rotationMatrixZ.setEntry(1, 1, cosAngleZ);
  rotationMatrixZ.setEntry(2, 2, 1);
  rotationMatrixZ.setEntry(3, 3, 1);

  final cosAngleY = cos(angleY);
  final sinAngleY = sin(angleY);

  final Matrix4 rotationMatrixY = Matrix4.zero();

  rotationMatrixY.setEntry(0, 0, cosAngleY);
  rotationMatrixY.setEntry(0, 2, sinAngleY);
  rotationMatrixY.setEntry(1, 1, 1);
  rotationMatrixY.setEntry(2, 0, -sinAngleY);
  rotationMatrixY.setEntry(2, 2, cosAngleY);
  rotationMatrixY.setEntry(3, 3, 1);

  final Matrix4 rotationMatrixX = Matrix4.zero();

  final halfCosAngle = cos(angleX / 2);
  final halfSinAngle = sin(angleX / 2);

  rotationMatrixX.setEntry(0, 0, 1);
  rotationMatrixX.setEntry(1, 1, halfCosAngle);
  rotationMatrixX.setEntry(1, 2, halfSinAngle);
  rotationMatrixX.setEntry(2, 1, -halfSinAngle);
  rotationMatrixX.setEntry(2, 2, halfCosAngle);
  rotationMatrixX.setEntry(3, 3, 1);

  for (final polygon in object) {
    final rotatedPoints = <Vector3D>[];

    for (final point in polygon) {
      final p = Vector3D.copy(point);

      /// Rotating polygons

      /// By Z axis
      Vector3D rotatedZVector = rotationMatrixZ.multiplyByVector(p);

      /// By X axis
      Vector3D rotatedXVector =
          rotationMatrixX.multiplyByVector(rotatedZVector);

      /// By Y axis
      Vector3D rotatedYVector =
          rotationMatrixY.multiplyByVector(rotatedXVector);

      /// Creating some perspective

      rotatedYVector = rotatedYVector.copy(
        z: rotatedYVector.z + offset,
      );

      rotatedPoints.add(rotatedYVector);
    }

    rotatedPolygons.add(
      Polygon(rotatedPoints),
    );
  }

  const focusFar = 1000.0, focusNear = 0.1;

  final Matrix4 projectionMatrix = Matrix4.zero();

  const _fFov = 90.0;

  final _fFovRad = 1.0 / tan(_fFov * .5 / 180 * pi);

  projectionMatrix.setEntry(0, 0, (height / width) * _fFovRad);
  projectionMatrix.setEntry(1, 1, _fFovRad);
  projectionMatrix.setEntry(2, 2, focusFar / (focusFar - focusNear));
  projectionMatrix.setEntry(
      3, 2, (-focusFar * focusNear) / (focusFar - focusNear));
  projectionMatrix.setEntry(2, 3, 1.0);
  projectionMatrix.setEntry(3, 3, 0.0);

  /// Changes size of object by
  /// screen size

  final Matrix4 sizingMatrix = Matrix4.zero();

  sizingMatrix.setEntry(0, 0, (width * .5));
  sizingMatrix.setEntry(1, 1, (height * .5));
  sizingMatrix.setEntry(2, 2, 1);
  sizingMatrix.setEntry(3, 3, 1);

  final projectedPolygons = <Polygon>[];

  for (final rotatedPolygon in rotatedPolygons) {
    final normal = rotatedPolygon.calculateNormal();

    final point = rotatedPolygon.first;

    if (normal.x * (point.x - vCamera.x) +
            normal.y * (point.y - vCamera.y) +
            normal.z * (point.z - vCamera.z) <
        0) {
      final normalizedLight = lightDirection.normalize();

      final dotProduct = normal.x * normalizedLight.x +
          normal.y * normalizedLight.y +
          normal.z * normalizedLight.z;

      final projectedPoints = <Vector3D>[];

      for (final rotatedPoint in rotatedPolygon) {
        final projectedVector = projectionMatrix.multiplyByVector(rotatedPoint);

        final sizedPoint = sizingMatrix.multiplyByVector(projectedVector);

        projectedPoints.add(sizedPoint);
      }

      projectedPolygons.add(
        Polygon(
          projectedPoints,
          [
            (rotatedPolygon.rgbo[0] * (dotProduct)),
            (rotatedPolygon.rgbo[1] * (dotProduct)),
            (rotatedPolygon.rgbo[2] * (dotProduct)),
            rotatedPolygon.rgbo[3],
          ],
        ),
      );
    }
  }

  return ObjectModel(projectedPolygons);
}
