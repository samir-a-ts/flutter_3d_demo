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

  Future<ObjectModel> project(
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
      ..addStream(
        _workerPort!.asBroadcastStream(),
      );

    _isolatePort ??= await _workerResultStreamController!.stream.first;

    final Completer<ObjectModel> completer = Completer();

    if (!_workerResultStreamController!.hasListener) {
      _workerResultStreamController?.stream.listen(
        (result) {
          if (result is ObjectModel) completer.complete(result);
        },
      );
    }

    _isolatePort!.send(
      Tuple(
        model,
        projectionData,
      ),
    );

    return completer.future;
  }

  void dispose() {
    _isolate?.kill();
    _workerResultStreamController?.close();

    _isolatePort = null;
    _workerPort = null;
    _isolate = null;
  }
}
