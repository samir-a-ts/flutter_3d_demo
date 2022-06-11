import 'dart:ui';

/// Classs that holds .MTL texture data.
///
/// It holds texture name, color, diffuse?, specular?, density?,
/// and transparecy.
///
class MtlFile {
  final String name;

  final Color ambientColor;

  final Color diffuseColor;

  final Color specularColor;

  MtlFile._(
      this.name, this.ambientColor, this.diffuseColor, this.specularColor);
}
