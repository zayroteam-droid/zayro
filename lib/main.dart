import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'layout/main_layout.dart';

void main() {
  runApp(const ZayroApp());
}

class ZayroApp extends StatelessWidget {
  const ZayroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zayro App',
      theme: AppTheme.lightTheme(),
      home: const MainLayout(),
    );
  }
}
