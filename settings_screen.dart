import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _urlController = TextEditingController();
  final _modelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _apiKeyController.text = settings.apiKey;
    _urlController.text = settings.apiUrl;
    _modelController.text = settings.model;
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API & Model Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: settingsProvider.selectedProvider,
              decoration: const InputDecoration(labelText: 'Select Provider'),
              items: const [
                DropdownMenuItem(value: 'gemini', child: Text('Google Gemini')),
                DropdownMenuItem(value: 'openrouter', child: Text('OpenRouter')),
              ],
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setProvider(value);
                  _urlController.text = settingsProvider.apiUrl;
                  _modelController.text = settingsProvider.model;
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'API Endpoint URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                settingsProvider.updateSettings(
                  apiKey: _apiKeyController.text.trim(),
                  apiUrl: _urlController.text.trim(),
                  model: _modelController.text.trim(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved successfully!')),
                );
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
