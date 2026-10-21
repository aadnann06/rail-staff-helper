import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RailStaffHelperApp());
}

class RailStaffHelperApp extends StatelessWidget {
  const RailStaffHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rail Staff Helper',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}