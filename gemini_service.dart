import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  Future<String> sendMessage({
    required String provider,
    required String apiKey,
    required String apiUrl,
    required String model,
    required String prompt,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception('API Key is missing. Please configure it in settings.');
    }

    final uri = Uri.parse(apiUrl);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Object body;

    if (provider == 'gemini') {
      headers['x-goog-api-key'] = apiKey;
      body = {
        'contents': [
          {
            'parts': [{'text': prompt}]
          }
        ]
      };
    } else {
      headers['Authorization'] = 'Bearer $apiKey';
      body = {
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt}
        ]
      };
    }

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      
      if (provider == 'gemini') {
        final candidates = data['candidates'] as List<dynamic>?;
        if (candidates == null || candidates.isEmpty) return '';
        final content = candidates.first['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List<dynamic>?;
        if (parts == null || parts.isEmpty) return '';
        return parts.first['text']?.toString() ?? '';
      } else {
        final choices = data['choices'] as List<dynamic>?;
        if (choices == null || choices.isEmpty) return '';
        final message = choices.first['message'] as Map<String, dynamic>?;
        return message?['content']?.toString() ?? '';
      }
    } else {
      throw Exception('Failed: ${response.statusCode} - ${response.body}');
    }
  }
}
