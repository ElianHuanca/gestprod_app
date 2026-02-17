import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/cloudinary_config.dart';

/// Sube una imagen a Cloudinary (unsigned) y devuelve la URL segura.
/// Requiere un upload preset sin firmar en el dashboard de Cloudinary.
class CloudinaryService {
  CloudinaryService([CloudinaryConfig? config])
      : _config = config ?? CloudinaryConfig.instance;

  final CloudinaryConfig _config;

  static const _uploadUrl =
      'https://api.cloudinary.com/v1_1/{cloud_name}/image/upload';

  /// Sube el archivo [file] y devuelve la [secure_url] o null si falla.
  Future<String?> uploadImage(File file) async {
    final uri = Uri.parse(
      _uploadUrl.replaceFirst('{cloud_name}', _config.cloudName),
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _config.uploadPreset
      ..fields['api_key'] = _config.apiKey;

    final filename = file.path.split(RegExp(r'[/\\]')).last;
    request.files.add(
      await http.MultipartFile.fromPath('file', file.path, filename: filename),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>?;
    return json?['secure_url'] as String?;
  }
}
