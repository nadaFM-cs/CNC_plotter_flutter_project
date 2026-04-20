import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<File> sendPrompt(String prompt) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/generate"),
    );

    request.fields['text'] = prompt;

    var response = await request.send();

    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/generated.png');

      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception("Failed to generate image");
    }
  }

  Future<File> sendEdits(File imageFile, String edits) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/edit"),
    );

    request.fields['edits'] = edits;

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final bytes = await response.stream.toBytes();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/edited.png');

      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception("Edit failed");
    }
  }

  Future<void> sendFinalImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/final"),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to send final image");
    }
  }

  Future<void> sendSketch(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/sketch"),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Failed to send sketch");
    }
  }
}