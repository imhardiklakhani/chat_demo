import 'package:flutter/material.dart';
import 'package:my_sivi/features/home/home_page.dart';

import 'features/app_shell/app_shell_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppShellPage(),
    );
  }
}
