import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  String _selectedProvider = 'gemini'; 
  String _apiKey = '';
  String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  String _model = 'gemini-1.5-flash';

  String get selectedProvider => _selectedProvider;
  String get apiKey => _apiKey;
  String get apiUrl => _apiUrl;
  String get model => _model;

  void setProvider(String provider) {
    _selectedProvider = provider;
    if (provider == 'gemini') {
      _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
      _model = 'gemini-1.5-flash';
    } else if (provider == 'openrouter') {
      _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
      _model = 'deepseek/deepseek-chat'; 
    }
    notifyListeners();
  }

  void updateSettings({required String apiKey, required String apiUrl, required String model}) {
    _apiKey = apiKey;
    _apiUrl = apiUrl;
    _model = model;
    notifyListeners();
  }
}
