part of '../object_source.dart';

class _EmptyObjectSource extends ObjectSource {
  const _EmptyObjectSource();

  @override
  FutureOr<Object?> get data => null;
}
