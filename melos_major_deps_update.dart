// ignore_for_file: avoid_print
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void main() async {
  print('🚀 Checking for MAJOR version updates in melos.yaml...');

  final file = File('pubspec.yaml');
  if (!file.existsSync()) {
    print('❌ melos.yaml not found!');
    exit(1);
  }

  final content = await file.readAsString();
  final editor = YamlEditor(content);
  final yaml = loadYaml(content);

  // The sections we want to update
  final sectionsToCheck = [
    ['melos', 'command', 'bootstrap', 'dependencies'],
    ['melos', 'command', 'bootstrap', 'dev_dependencies'],
  ];

  bool hasChanges = false;

  for (final path in sectionsToCheck) {
    // Navigate safely to the section
    dynamic currentNode = yaml;
    bool foundSection = true;
    for (final key in path) {
      if (currentNode is Map && currentNode.containsKey(key)) {
        currentNode = currentNode[key];
      } else {
        foundSection = false;
        break;
      }
    }

    if (!foundSection || currentNode is! Map) continue;

    print('📂 Processing section: ${path.last}...');

    for (final entry in currentNode.entries) {
      final packageName = entry.key as String;
      final currentConstraint = entry.value;

      // Skip complex definitions (like git or sdk)
      if (currentConstraint is! String) continue;

      // 1. Fetch Latest from Pub
      final latestVersion = await _getLatestVersion(packageName);

      if (latestVersion == null) continue;

      // 2. Compare and Update
      // We force update to the latest version found (just like --major-versions)
      final newConstraint = '^$latestVersion';

      if (currentConstraint != newConstraint) {
        print('✨ Upgrading $packageName: $currentConstraint -> $newConstraint');

        // Update the YAML in place
        final nodePath = [...path, packageName];
        editor.update(nodePath, newConstraint);
        hasChanges = true;
      }
    }
  }

  if (hasChanges) {
    await file.writeAsString(editor.toString());
    print('✅ melos.yaml successfully updated to latest major versions!');
  } else {
    print('👍 Everything is already up to date.');
  }
}

// Helper to fetch from pub.dev
Future<String?> _getLatestVersion(String packageName) async {
  try {
    final url = Uri.parse('https://pub.dev/api/packages/$packageName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // 'latest' tag in pub.dev always points to the latest stable release (includes Major bumps)
      return data['latest']['version'] as String;
    }
  } catch (e) {
    print('⚠️ Error fetching $packageName: $e');
  }
  return null;
}
