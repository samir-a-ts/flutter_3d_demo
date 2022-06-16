import 'dart:isolate';

import 'package:flutter_object/src/infastructure/models/3d/object.dart';
import 'package:flutter_object/src/infastructure/projection/projection.dart';
import 'package:flutter_object/src/infastructure/projection/projection_data.dart';

void isolateScope(SendPort port) async {
  final isolatePort = ReceivePort();

  port.send(isolatePort.sendPort);

  await for (final event in isolatePort) {
    final model = event.value1 as ObjectModel;
    final data = event.value2 as ProjectionData;

    final result = await projectObject(
      object: model,
      widgetSize: data.widgetSize,
      angleX: data.angleX,
      angleY: data.angleY,
      angleZ: data.angleZ,
      lightDirection: data.lightDirection,
      offset: data.offset,
      vCamera: data.vCamera,
    );

    port.send(result);
  }
}
