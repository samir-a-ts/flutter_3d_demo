/// A convex polygon in space represented
/// by 3 or more [FaceVertex]'s.
class Face {
  /// Polygon vertexes the [Face]
  /// is representing.
  final List<FaceVertex> vertexes;

  Face._(this.vertexes);

  /// Creates [Face] from `f` node in
  /// .OBJ file
  ///
  /// Example: f 1/1 2//1 3/2/1 ...
  ///
  /// There have to be at least 3
  /// vertexes for this polygon.
  factory Face.fromString(String data) {
    final List<String> rawData = data.split(' ');

    /// "f" letter may be ignored.
    rawData.removeAt(0);

    assert(rawData.length > 2);

    final List<FaceVertex> resultVertexes = [];

    for (final data in rawData) {
      resultVertexes.add(
        FaceVertex.fromString(data),
      );
    }

    return Face._(resultVertexes);
  }
}

/// Polygon vertex data.
///
/// Holds geometric vertex index,
/// texture vertex index and
/// vertex normals index.
///
/// All indexes must be greater than 0.
class FaceVertex {
  final int vertexIndex;

  final int? textureVertexIndex;

  final int? vertexNormalIndex;

  FaceVertex._(this.vertexIndex,
      [this.textureVertexIndex, this.vertexNormalIndex]);

  /// Creates [FaceVertex] from 3 numbers
  /// divided by slashes.
  ///
  /// Examples of string: 1, 1/1, 1/1/1, 1//1
  ///
  /// First - geometric vertex, second -
  /// texture vertex and third - vertex normal.
  /// All others would be ignored.
  ///
  /// If some values are not presented in
  /// string, it defaults to null.
  factory FaceVertex.fromString(String data) {
    final List<String> rawNumbers = data.split(r'/');

    assert(rawNumbers.first.isNotEmpty);

    final List<int?> parsedNumbers = [null, null, null];

    for (int i = 0; i < 3; i++) {
      final value = rawNumbers[i];

      if (value.isEmpty) {
        parsedNumbers[i] = null;
      } else {
        parsedNumbers[i] = int.parse(value);
      }
    }

    return FaceVertex._(
      parsedNumbers[0]!,
      parsedNumbers[1],
      parsedNumbers[2],
    );
  }
}
