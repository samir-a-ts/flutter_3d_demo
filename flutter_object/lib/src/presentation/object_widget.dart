import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_object/src/infastructure/models/3d/object.dart';
import 'package:flutter_object/src/infastructure/models/3d/polygon.dart';
import 'package:flutter_object/src/infastructure/models/3d/vector_3d.dart';
import 'package:flutter_object/src/infastructure/models/source/object_source.dart';
import 'package:flutter_object/src/infastructure/projection/projection_data.dart';
import 'package:flutter_object/src/infastructure/projection/worker.dart';
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
  late ProjectionWorker _worker;

  @override
  void initState() {
    RendererBinding.instance.scheduleWarmUpFrame();

    _controller = widget.controller ?? ObjectViewController();

    _worker = ProjectionWorker();

    _worker.warmUp();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ObjectModel?>(
      future: _loadObjectFromSource(widget.source),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return ObjectRenderWidget(
                object: snapshot.data,
                angleX: _controller.angleX,
                angleY: _controller.angleY,
                angleZ: _controller.angleZ,
                offset: _controller.offset,
                vCamera: _controller.vCamera,
                lightDirection: _controller.lightDirection,
                translation: _controller.translation,
                worker: _worker,
              );
            },
          );
        }

        return widget.loadingPlaceholder ?? const Empty();
      },
    );
  }

  Future<ObjectModel?> _loadObjectFromSource(ObjectSource? source) async {
    final object = await source?.data;

    return object;
  }
}

class ObjectRenderWidget extends LeafRenderObjectWidget {
  final ObjectModel? object;
  final double angleX;
  final double angleY;
  final double angleZ;
  final double offset;
  final Vector3D vCamera;
  final Vector3D lightDirection;
  final Offset translation;
  final ProjectionWorker worker;

  const ObjectRenderWidget({
    required this.worker,
    required this.translation,
    required this.object,
    required this.vCamera,
    required this.angleX,
    required this.angleY,
    required this.angleZ,
    required this.offset,
    required this.lightDirection,
    Key? key,
  }) : super(key: key);

  @override
  _RenderObject createRenderObject(BuildContext context) {
    return _RenderObject(
      object!,
      angleX,
      angleY,
      angleZ,
      offset,
      vCamera,
      lightDirection,
      translation,
      worker,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderObject renderObject) {
    renderObject
      ..object = object!
      ..angleX = angleX
      ..angleY = angleY
      ..angleZ = angleZ
      ..vCamera = vCamera
      ..offset = offset
      ..lightDirection = lightDirection
      ..translation = translation;
  }
}

class _RenderObject extends RenderBox {
  ObjectModel _object;
  double _angleX;
  double _angleY;
  double _angleZ;
  double _offset;
  Vector3D _vCamera;
  Vector3D _lightDirection;
  Offset _translation;
  final ProjectionWorker _worker;

  _RenderObject(
    this._object,
    this._angleX,
    this._angleY,
    this._angleZ,
    this._offset,
    this._vCamera,
    this._lightDirection,
    this._translation,
    this._worker,
  );

  ObjectModel? _projObject;

  set _projectedObject(ObjectModel object) {
    _projObject = object;

    if (!(debugDisposed ?? false)) {
      markNeedsPaint();
    }
  }

  set object(ObjectModel object) {
    _object = object;

    _project();
  }

  set angleX(double angleX) {
    _angleX = angleX;

    _project();
  }

  set angleY(double angleY) {
    _angleY = angleY;

    _project();
  }

  set angleZ(double angleZ) {
    _angleZ = angleZ;

    _project();
  }

  set offset(double offset) {
    _offset = offset;

    _project();
  }

  set vCamera(Vector3D value) {
    _vCamera = value;

    _project();
  }

  set lightDirection(Vector3D value) {
    _lightDirection = value;

    _project();
  }

  set translation(Offset value) {
    _translation = value;

    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer ??= ContainerLayer();

    _drawObject(context, _object);
  }

  void _drawObject(PaintingContext context, ObjectModel? object) {
    if (_projObject != null) {
      final global = localToGlobal(Offset.zero);

      final dx = global.dx + (size.width / 2);

      final dy = global.dy + (size.height / 2);

      final paint = Paint()..style = PaintingStyle.fill;

      final canvas = context.canvas;

      canvas.translate(
        dx + _translation.dx,
        dy + _translation.dy,
      );

      for (final polygon in _projObject!) {
        canvas.drawPath(
          polygon.toPath(),
          paint
            ..color = Color.fromRGBO(
              polygon.rgbo[0].toInt(),
              polygon.rgbo[1].toInt(),
              polygon.rgbo[2].toInt(),
              polygon.rgbo[3],
            ),
        );
      }

      return;
    }

    _worker.results.listen((event) {
      _projectedObject = event;
    });

    _project();
  }

  void _project() => _worker.project(
        _object,
        ProjectionData(
          size.width,
          size.height,
          _angleX,
          _angleY,
          _angleZ,
          _offset,
          _vCamera,
          _lightDirection,
        ),
      );

  @override
  void dispose() {
    _worker.dispose();

    super.dispose();
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
}

/// HasInfiniteHeight and HasInfiniteWidth properties
/// is not suitable for performing widget's layout.
extension _ConstraintsExt on BoxConstraints {
  bool get hasInfiniteMaxHeight => maxHeight == double.infinity;

  bool get hasInfiniteMaxWidth => maxWidth == double.infinity;
}

extension on Polygon {
  Path toPath() {
    final offsets = <Offset>[];

    for (final point in points) {
      offsets.add(Offset(point.x, point.y));
    }

    return Path()..addPolygon(offsets, true);
  }
}
