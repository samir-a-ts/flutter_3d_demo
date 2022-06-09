import 'package:flutter/cupertino.dart';
import 'package:flutter_3d_engine/src/infastructure/models/3d/vector_3d.dart';

extension MatrixExt on Matrix4 {
  Vector3D multiplyByVector(Vector3D v) {
    final matrix = this;

    final vectorArray = [v.x, v.y, v.z, 1];

    final resultVectorArr = [0.0, 0.0, 0.0, 0.0];

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        resultVectorArr[i] += vectorArray[j] * matrix.entry(j, i);
      }
    }

    Vector3D resultVector = Vector3D.fromList(resultVectorArr);

    double w = resultVectorArr.last;

    if (w != 0.0) {
      resultVector /= w;
    }

    return resultVector;
  }
}
