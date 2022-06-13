part of "main_test.dart";

void _testMath() {
  group("Math theory test:", () {
    test("Matrix multiplication", () {
      final Matrix4 matrix = Matrix4.zero();

      matrix.setEntry(0, 0, 1);

      const vector = Vector3D(1, 1, 1);

      final result = matrix.multiplyByVector(vector);

      expect(result, equals(const Vector3D(1, 0, 0)));
    });
  });
}
