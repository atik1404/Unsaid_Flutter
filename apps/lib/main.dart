import 'package:app/app_entry.dart';
import 'package:di/di.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerAppDiModule();
  runApp(const AppEntry());
}
