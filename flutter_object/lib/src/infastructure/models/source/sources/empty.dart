part of '../object_source.dart';

class _EmptyObjectSource extends ObjectSource {
  const _EmptyObjectSource();

  @override
  FutureOr<Mesh?> get data => null;
}
