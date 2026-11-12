
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'providers/transaction_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: const MoneyMateApp(),
    ),
  );
}

class MoneyMateApp extends StatelessWidget {
  const MoneyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneyMate',
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
