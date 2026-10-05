import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class GeminiService {
  Future<bool> validateKey(String apiKey) async {
    if (apiKey.trim().isEmpty) return false;
    final uri = Uri.parse('${AppConstants.geminiGenerateUrl}?key=${Uri.encodeQueryComponent(apiKey.trim())}');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {'parts': [{'text': 'Reply with OK'}]}
          ],
          'generationConfig': {'maxOutputTokens': 2}
        }),
      );
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<String> ask(String apiKey, String prompt) async {
    final uri = Uri.parse('${AppConstants.geminiGenerateUrl}?key=${Uri.encodeQueryComponent(apiKey.trim())}');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'parts': [{'text': prompt}]}
        ]
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gemini request failed (${response.statusCode}).');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>? ?? [];
    if (candidates.isEmpty) return '';
    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>? ?? [];
    return parts.map((p) => p['text'] ?? '').join();
  }
}
