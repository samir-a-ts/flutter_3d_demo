part of '../object_source.dart';

class EmptyObjectSource extends ObjectSource {
  const EmptyObjectSource();

  @override
  FutureOr<Mesh?> get data => null;
}
