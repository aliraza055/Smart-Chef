import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploadService {
  Future<String?> uploadImage(File image) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/dhob4di7g/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = 'upload_preset_file';
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      return jsonDecode(resBody)['secure_url'];
    }
    return null;
  }
}

