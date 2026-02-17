/// Configuración de Cloudinary para subida de imágenes.
///
/// Usamos subida **no firmada** (unsigned), por lo que el [secretKey] no se
/// usa en la app. Crea un "Upload preset" sin firmar en el dashboard de
/// Cloudinary (Settings → Upload → Add upload preset → Unsigned) y pon su
/// nombre en [uploadPreset].
class CloudinaryConfig {
  CloudinaryConfig({
    required this.cloudName,
    required this.apiKey,
    required this.uploadPreset,
  });

  final String cloudName;
  final String apiKey;
  /// Nombre del upload preset sin firmar creado en Cloudinary.
  final String uploadPreset;

  static final CloudinaryConfig instance = CloudinaryConfig(
    cloudName: 'puesokoelian',
    apiKey: '548499382843859',
    uploadPreset: 'productos',
  );
}
