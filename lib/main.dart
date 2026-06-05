import 'package:flutter/material.dart';
import 'package:nubank_clone/app.dart';
import 'package:nubank_clone/core/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();
  runApp(const App());
}
