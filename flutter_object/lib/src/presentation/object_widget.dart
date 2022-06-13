import 'dart:async';
import 'dart:math';

import 'package:flutter_object/src/core/math/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_object/src/infastructure/models/3d/object.dart';
import 'package:flutter_object/src/infastructure/models/3d/polygon.dart';
import 'package:flutter_object/src/infastructure/models/3d/vector_3d.dart';
import 'package:flutter_object/src/infastructure/models/source/object_source.dart';
import 'package:flutter_object/src/presentation/core/empty.dart';
import 'package:flutter_object/src/presentation/state/object_view_controller.dart';

class ObjectWidget extends StatefulWidget {
  final ObjectSource? source;
  final ObjectViewController? controller;
  final Widget? loadingPlaceholder;

  const ObjectWidget({
    Key? key,
    this.source = const ObjectSource.empty(),
    this.controller,
    this.loadingPlaceholder,
  }) : super(key: key);

  @override
  State<ObjectWidget> createState() => _ObjectWidgetState();
}

class _ObjectWidgetState extends State<ObjectWidget> {
  late ObjectViewController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? ObjectViewController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object?>(
      future: _loadObjectFromSource(widget.source),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return ObjectRenderWidget(
                object: snapshot.data,
                angleX: _controller.angleX,
                angleZ: _controller.angleZ,
                offset: _controller.offset,
                vCamera: _controller.vCamera,
                lightDirection: _controller.lightDirection,
              );
            },
          );
        }

        return widget.loadingPlaceholder ?? const Empty();
      },
    );
  }

  Future<Object?> _loadObjectFromSource(ObjectSource? source) async {
    final object = await source?.data;

    return object;
  }
}

class ObjectRenderWidget extends LeafRenderObjectWidget {
  final Object? object;
  final double angleX;
  final double angleZ;
  final double offset;
  final Vector3D vCamera;
  final Vector3D lightDirection;

  const ObjectRenderWidget({
    required this.object,
    required this.vCamera,
    required this.angleX,
    required this.angleZ,
    required this.offset,
    required this.lightDirection,
    Key? key,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderObject(
      object,
      angleX,
      angleZ,
      offset,
      vCamera,
      lightDirection,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    renderObject
      ..object = object
      ..angleX = angleX
      ..angleZ = angleZ
      ..vCamera = vCamera
      ..offset = offset
      ..lightDirection = lightDirection;
  }
}

class RenderObject extends RenderBox {
  Object? _object;
  double _angleX;
  double _angleZ;
  double _offset;
  Vector3D _vCamera;
  Vector3D _lightDirection;

  RenderObject(
    this._object,
    this._angleX,
    this._angleZ,
    this._offset,
    this._vCamera,
    this._lightDirection,
  );

  set object(Object? object) {
    _object = object;

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

  set vCamera(Vector3D value) {
    _vCamera = value;

    markNeedsPaint();
  }

  set lightDirection(Vector3D value) {
    _lightDirection = value;

    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer ??= ContainerLayer();

    _drawObject(context, _object);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    /// Widget cannot build itself on infinite plane
    /// and with dimension null.
    if (constraints.hasInfiniteMaxHeight && constraints.hasInfiniteMaxWidth) {
      throw FlutterError(
          "ObjectWidget cannot be drawn without dimension in infinite plane.\nTry adding dimension parameter, or removing this widget.");
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

  void _drawObject(PaintingContext context, Object? object) {
    if (object == null) return;

    final rotatedObject = _rotateObject(
      object: object,
      angleX: _angleX,
      angleZ: _angleZ,
      offset: _offset,
    );

    final paint = Paint()..style = PaintingStyle.fill;

    final canvas = context.canvas;

    final global = localToGlobal(Offset.zero);

    final dx = global.dx + (size.width / 2);

    final dy = global.dy + (size.height / 2);

    canvas.translate(dx, dy);

    const focusFar = 1000.0, focusNear = 0.1;

    final Matrix4 projectionMatrix = Matrix4.zero();

    const _fFov = 90.0;

    final _fFovRad = 1.0 / tan(_fFov * .5 / 180 * pi);

    projectionMatrix.setEntry(0, 0, (size.height / size.width) * _fFovRad);
    projectionMatrix.setEntry(1, 1, _fFovRad);
    projectionMatrix.setEntry(2, 2, focusFar / (focusFar - focusNear));
    projectionMatrix.setEntry(
        3, 2, (-focusFar * focusNear) / (focusFar - focusNear));
    projectionMatrix.setEntry(2, 3, 1.0);
    projectionMatrix.setEntry(3, 3, 0.0);

    /// Changes size of object by
    /// screen size

    final Matrix4 sizingMatrix = Matrix4.zero();

    sizingMatrix.setEntry(0, 0, (size.width * .5));
    sizingMatrix.setEntry(1, 1, (size.height * .5));
    sizingMatrix.setEntry(2, 2, 1);
    sizingMatrix.setEntry(3, 3, 1);

    for (final rotatedPolygon in rotatedObject) {
      final normal = rotatedPolygon.calculateNormal();

      final point = rotatedPolygon.first;

      if (normal.x * (point.x - _vCamera.x) +
              normal.y * (point.y - _vCamera.y) +
              normal.z * (point.z - _vCamera.z) <
          0) {
        final normalizedLight = _lightDirection.normalize();

        final dotProduct = normal.x * normalizedLight.x +
            normal.y * normalizedLight.y +
            normal.z * normalizedLight.z;

        final projectedPoints = <Vector3D>[];

        for (final rotatedPoint in rotatedPolygon) {
          final projectedVector =
              projectionMatrix.multiplyByVector(rotatedPoint);

          final sizedPoint = sizingMatrix.multiplyByVector(projectedVector);

          projectedPoints.add(sizedPoint);
        }

        paint.color = Color.fromRGBO(
          (rotatedPolygon.color.red * (dotProduct)).floor(),
          (rotatedPolygon.color.green * (dotProduct)).floor(),
          (rotatedPolygon.color.blue * (dotProduct)).floor(),
          rotatedPolygon.color.opacity,
        );

        canvas.drawPath(
          Polygon(projectedPoints).toPath(),
          paint,
        );
      }
    }
  }

  Object _rotateObject({
    required Object object,
    double offset = 3.0,
    double angleX = 0,
    double angleZ = 0,
  }) {
    final result = <Polygon>[];

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

        /// Creating some perspective

        rotatedXVector = rotatedXVector.copy(
          z: rotatedXVector.z + offset,
        );

        rotatedPoints.add(rotatedXVector);
      }

      result.add(
        Polygon(rotatedPoints),
      );
    }

    return Object(result);
  }
}

/// HasInfiniteHeight and HasInfiniteWidth properties
/// is not suitable for performing widget's layout.
extension _ConstraintsExt on BoxConstraints {
  bool get hasInfiniteMaxHeight => maxHeight == double.infinity;

  bool get hasInfiniteMaxWidth => maxWidth == double.infinity;
}
