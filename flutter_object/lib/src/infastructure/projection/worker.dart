import 'dart:async';
import 'dart:isolate';

import 'package:flutter_object/flutter_object.dart';
import 'package:flutter_object/src/core/utils/tuple.dart';
import 'package:flutter_object/src/infastructure/projection/projection_data.dart';

import 'isolate_scope.dart';

class ProjectionWorker {
  ProjectionWorker._internal();

  static final _singleton = ProjectionWorker._internal();

  factory ProjectionWorker() => _singleton;

  Isolate? _isolate;

  ReceivePort? _workerPort;

  StreamController? _workerResultStreamController;

  SendPort? _isolatePort;

  Future<void> project(
    ObjectModel model,
    ProjectionData projectionData,
  ) async {
    _workerPort ??= ReceivePort();

    _isolate ??= await Isolate.spawn<SendPort>(
      isolateScope,
      _workerPort!.sendPort,
      debugName: "flutter_object calculations",
    );

    _workerResultStreamController ??= StreamController.broadcast()
      ..addStream(_workerPort!);

    _isolatePort ??= await _workerResultStreamController!.stream.first;

    _isolatePort!.send(
      Tuple(
        model,
        projectionData,
      ),
    );
  }

  Stream<ObjectModel> get results => _workerResultStreamController!.stream
      .where((event) => event is ObjectModel)
      .cast<ObjectModel>();

  void dispose() {
    _isolate?.kill();
    _workerResultStreamController?.close();

    _isolatePort = null;
    _workerPort = null;
    _isolate = null;
  }
}
