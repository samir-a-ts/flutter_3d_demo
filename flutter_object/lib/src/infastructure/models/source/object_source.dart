import 'dart:async';
import 'dart:io';

import 'package:flutter_object/src/infastructure/models/3d/mesh.dart';
import 'package:flutter_object/src/infastructure/services/file_reader_service.dart';
import 'package:flutter_object/src/infastructure/services/obj_reader_service.dart';

part 'sources/asset_obj.dart';
part 'sources/empty.dart';
part 'sources/file.dart';

abstract class ObjectSource {
  const ObjectSource();

  FutureOr<Mesh?> get data;
}
