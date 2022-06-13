import 'dart:async';
import 'dart:io';

import 'package:flutter_object/src/infastructure/models/3d/object.dart';
import 'package:flutter_object/src/infastructure/services/file_reader_service.dart';
import 'package:flutter_object/src/infastructure/services/obj_reader_service.dart';

part 'sources/asset_obj.dart';
part 'sources/empty.dart';
part 'sources/file.dart';

abstract class ObjectSource {
  const ObjectSource();

  FutureOr<Object?> get data;

  factory ObjectSource.fromAssets(String assetsPath) =>
      _AssetObjectSource(assetsPath);

  factory ObjectSource.fromFile(File file) => _FileObjectSource(file);

  const factory ObjectSource.empty() = _EmptyObjectSource;
}
