// ignore_for_file: avoid_print
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void main() async {
  print('🔎 Reading pubspec.yaml...');
  final file = File('pubspec.yaml');
  final content = await file.readAsString();
  final editor = YamlEditor(content);
  final yaml = loadYaml(content);

  // Define the paths in your melos.yaml structure
  final paths = [
    ['melos', 'command', 'bootstrap', 'dependencies'],
    ['melos', 'command', 'bootstrap', 'dev_dependencies'],
  ];

  for (final path in paths) {
    // Navigate to the section
    dynamic section = yaml;
    for (final key in path) {
      if (section is Map && section.containsKey(key)) {
        section = section[key];
      } else {
        section = null;
        break;
      }
    }

    if (section is! Map) continue;

    print('Processing ${path.last}...');

    // Iterate over packages in this section
    for (final packageName in section.keys) {
      final currentConfig = section[packageName];

      // Skip SDK dependencies (like flutter_test: sdk: flutter)
      if (currentConfig is Map || packageName == 'flutter') {
        continue;
      }

      // Fetch latest version
      final newVersion = await _fetchLatestVersion(packageName);
      if (newVersion != null) {
        final versionString = '^$newVersion';

        if (currentConfig != versionString) {
          print('   ✅ Upgrading $packageName: $currentConfig -> $versionString');
          editor.update([...path, packageName], versionString);
        }
      }
    }
  }

  await file.writeAsString(editor.toString());
  print('🎉 melos.yaml update complete!');
}

Future<String?> _fetchLatestVersion(String packageName) async {
  try {
    final url = Uri.parse('https://pub.dev/api/packages/$packageName');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['latest']['version'] as String;
    }
  } catch (e) {
    print('   ❌ Failed to fetch $packageName');
  }
  return null;
}
