
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme/app_theme.dart';
import 'providers/transaction_provider.dart';
import 'providers/exchange_rate_provider.dart';
import 'screens/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await Supabase.initialize(
    url: 'https://ucatbzmtbwjrhyncnvie.supabase.co',
    publishableKey: 'sb_publishable_Tet_w2DY6QB52RCanorZcw_e6JLP-Mg',
  );

  try {
    if (Supabase.instance.client.auth.currentSession == null) {
      await Supabase.instance.client.auth.signInAnonymously();
      debugPrint('Supabase Anonymous Auth berhasil.');
    } else {
      debugPrint('Supabase session tersedia.');
    }
  } catch (error) {
    debugPrint('Supabase Auth error: $error');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TransactionProvider()..loadTransactions(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExchangeRateProvider()..loadExchangeRate(),
        ),
      ],
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
      home: const MainNavigationScreen(),
    );
  }
}
