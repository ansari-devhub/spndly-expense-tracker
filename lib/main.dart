import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spndly_original/pages/main_nav.dart';
import 'package:spndly_original/theme/app_theme.dart';

void main() {
  runApp(
    // ProviderScope is required — it's the root of all Riverpod providers
    const ProviderScope(child: SpndlyApp()),
  );
}

class SpndlyApp extends StatelessWidget {
  const SpndlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spndly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainNav(),
    );
  }
}
