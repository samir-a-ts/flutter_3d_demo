import 'dart:math';

import 'package:flutter_3d_engine/src/core/math/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_3d_engine/src/infastructure/models/3d/mesh.dart';
import 'package:flutter_3d_engine/src/infastructure/models/3d/polygon.dart';
import 'package:flutter_3d_engine/src/infastructure/models/3d/vector_3d.dart';
import 'package:flutter_3d_engine/src/presentation/state/model_controller.dart';

class ModelWidget extends StatefulWidget {
  final Mesh mesh;
  final ModelController? controller;

  const ModelWidget({
    Key? key,
    this.controller,
    required this.mesh,
  }) : super(key: key);

  @override
  State<ModelWidget> createState() => _ModelWidgetState();
}

class _ModelWidgetState extends State<ModelWidget> {
  late ModelController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? ModelController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ModelRenderObjectWidget(
          mesh: widget.mesh,
          angleX: _controller.angleX,
          angleZ: _controller.angleZ,
          offset: _controller.offset,
        );
      },
    );
  }
}

/// Cube render demo
class ModelRenderObjectWidget extends LeafRenderObjectWidget {
  final Mesh mesh;
  final double angleX;
  final double angleZ;
  final double offset;

  const ModelRenderObjectWidget({
    required this.angleX,
    required this.angleZ,
    required this.offset,
    required this.mesh,
    Key? key,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return ModelRenderObject(
      mesh,
      angleX,
      angleZ,
      offset,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant ModelRenderObject renderObject) {
    renderObject
      ..mesh = mesh
      ..angleX = angleX
      ..angleZ = angleZ
      ..offset = offset;
  }
}

class ModelRenderObject extends RenderBox {
  Mesh _mesh;
  double _angleX;
  double _angleZ;
  double _offset;

  ModelRenderObject(
    this._mesh,
    this._angleX,
    this._angleZ,
    this._offset,
  );

  set mesh(Mesh mesh) {
    _mesh = mesh;

    markNeedsPaint();
  }

  set angleX(double angleX) {
    _angleX = angleX;

    markNeedsPaint();
  }

  set angleZ(double angleZ) {
    _angleZ = angleZ;

    markNeedsPaint();
  }

  set offset(double offset) {
    _offset = offset;

    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer ??= ContainerLayer();

    _drawMesh(context, _mesh);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    /// Widget cannot build itself on infinite plane
    /// and with dimension null.
    if (constraints.hasInfiniteMaxHeight && constraints.hasInfiniteMaxWidth) {
      throw FlutterError(
          "ReichWidget cannot be built without dimension in infinite plane.\nTry adding dimension parameter, or removing this widget.");
    }

    if (constraints.hasInfiniteMaxWidth) {
      return Size.square(constraints.maxHeight);
    }

    if (constraints.hasInfiniteMaxHeight) {
      return Size.square(constraints.maxWidth);
    }

    return constraints.biggest;
  }

  @override
  void performLayout() {
    size = getDryLayout(constraints);
  }

  void _drawMesh(PaintingContext context, Mesh mesh) {
    final projectedMesh = _projectMesh(
      mesh: mesh,
      widgetSize: size,
      angleX: _angleX,
      angleZ: _angleZ,
      offset: _offset,
    );

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final canvas = context.canvas;

    final global = localToGlobal(Offset.zero);

    final dx = global.dx + (size.width / 2);

    final dy = global.dy + (size.height / 2);

    canvas.translate(dx, dy);

    for (final polygon in projectedMesh) {
      for (int i = 0; i < polygon.length - 1; i++) {
        Offset current = polygon[i].toOffset();

        Offset next = polygon[i + 1].toOffset();

        canvas.drawLine(
          current,
          next,
          paint,
        );
      }

      canvas.drawLine(
        polygon.last.toOffset(),
        polygon.first.toOffset(),
        paint,
      );
    }
  }
}

Mesh _projectMesh({
  required Mesh mesh,
  required Size widgetSize,
  double offset = 3.0,
  double angleX = 0,
  double angleZ = 0,
}) {
  const focusFar = 1000.0, focusNear = 0.1;

  final Matrix4 projectionMatrix = Matrix4.zero();

  const _fFov = 90.0;

  final _fFovRad = 1.0 / tan(_fFov * .5 / 180 * pi);

  projectionMatrix.setEntry(
      0, 0, (widgetSize.height / widgetSize.width) * _fFovRad);
  projectionMatrix.setEntry(1, 1, _fFovRad);
  projectionMatrix.setEntry(2, 2, focusFar / (focusFar - focusNear));
  projectionMatrix.setEntry(
      3, 2, (-focusFar * focusNear) / (focusFar - focusNear));
  projectionMatrix.setEntry(2, 3, 1.0);
  projectionMatrix.setEntry(3, 3, 0.0);

  final projectedPolygons = <Polygon>[];

  final Matrix4 rotationMatrixZ = Matrix4.zero();

  final cosAngle = cos(angleZ);
  final sinAngle = sin(angleZ);

  rotationMatrixZ.setEntry(0, 0, cosAngle);
  rotationMatrixZ.setEntry(0, 1, sinAngle);
  rotationMatrixZ.setEntry(1, 0, -sinAngle);
  rotationMatrixZ.setEntry(1, 1, cosAngle);
  rotationMatrixZ.setEntry(2, 2, 1);
  rotationMatrixZ.setEntry(3, 3, 1);

  final Matrix4 rotationMatrixX = Matrix4.zero();

  final halfCosAngle = cos(angleX / 2);
  final halfSinAngle = sin(angleX / 2);

  rotationMatrixX.setEntry(0, 0, 1);
  rotationMatrixX.setEntry(1, 1, halfCosAngle);
  rotationMatrixX.setEntry(1, 2, halfSinAngle);
  rotationMatrixX.setEntry(2, 1, -halfSinAngle);
  rotationMatrixX.setEntry(2, 2, halfCosAngle);
  rotationMatrixX.setEntry(3, 3, 1);

  /// Changes size of object by
  /// screen size

  final Matrix4 sizingMatrix = Matrix4.zero();

  sizingMatrix.setEntry(0, 0, (widgetSize.width));
  sizingMatrix.setEntry(1, 1, (widgetSize.height));
  sizingMatrix.setEntry(2, 2, 1);
  sizingMatrix.setEntry(3, 3, 1);

  for (final polygon in mesh) {
    final rotatedPoints = <Vector3D>[];

    for (final point in polygon) {
      final p = Vector3D.copy(point);

      /// Rotating polygons

      /// By Z axis
      final rotatedZVector = rotationMatrixZ.multiplyByVector(p);

      /// By X axis
      final rotatedXVector = rotationMatrixX.multiplyByVector(rotatedZVector);

      /// Creating some perspective

      rotatedXVector.z += offset;

      rotatedPoints.add(rotatedXVector);
    }

    final rotatedPolygon = Polygon(rotatedPoints);

    if (rotatedPolygon.calculateNormal().z < 0) {
      final projectedPoints = <Vector3D>[];

      for (final rotatedPoint in rotatedPolygon) {
        final projectedVector = projectionMatrix.multiplyByVector(rotatedPoint);

        final sizedPoint = sizingMatrix.multiplyByVector(projectedVector);

        projectedPoints.add(sizedPoint);
      }

      projectedPolygons.add(
        Polygon(projectedPoints),
      );
    }
  }

  return Mesh(projectedPolygons);
}

/// HasInfiniteHeight and HasInfiniteWidth properties
/// is not suitable for performing widget's layout.
extension _ConstraintsExt on BoxConstraints {
  bool get hasInfiniteMaxHeight => maxHeight == double.infinity;

  bool get hasInfiniteMaxWidth => maxWidth == double.infinity;
}
