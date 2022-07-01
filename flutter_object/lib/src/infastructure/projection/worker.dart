import 'dart:async';
import 'dart:isolate';

import 'package:flutter_object/flutter_object.dart';
import 'package:flutter_object/src/core/utils/tuple.dart';
import 'package:flutter_object/src/infastructure/projection/projection_data.dart';

import 'isolate_scope.dart';

class ProjectionWorker {
  ProjectionWorker();

  Isolate? _isolate;

  ReceivePort? _workerPort;

  StreamController _workerResultStreamController = StreamController.broadcast();

  SendPort? _isolatePort;

  Future<void> warmUp() async {
    _workerPort ??= ReceivePort();

    _isolate ??= await Isolate.spawn<SendPort>(
      isolateScope,
      _workerPort!.sendPort,
      debugName: "flutter_object calculations $hashCode",
    );

    _workerResultStreamController.addStream(_workerPort!);

    _isolatePort ??= await _workerResultStreamController.stream.first;
  }

  void project(
    ObjectModel model,
    ProjectionData projectionData,
  ) =>
      _isolatePort?.send(
        Tuple(
          model,
          projectionData,
        ),
      );

  Stream<ObjectModel> get results => _workerResultStreamController.stream
      .where((event) => event is ObjectModel)
      .cast<ObjectModel>();

  void dispose() {
    _isolate?.kill(
      priority: Isolate.immediate,
    );

    _isolate = null;

    _isolatePort = null;
    _workerPort = null;

    _workerResultStreamController = StreamController.broadcast();
  }
}
