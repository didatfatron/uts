
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'add_transaction_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    _PlaceholderPage(
      title: 'Transactions',
      subtitle: 'Your transaction history will appear here.',
      icon: Icons.receipt_long_outlined,
    ),
    _PlaceholderPage(
      title: 'Statistics',
      subtitle: 'Analyze your income and expenses here.',
      icon: Icons.bar_chart_rounded,
    ),
    _PlaceholderPage(
      title: 'Profile',
      subtitle: 'Manage your profile and application settings.',
      icon: Icons.person_outline_rounded,
    ),
  ];

  Future<void> _openAddTransaction() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton:
          _selectedIndex == 0 || _selectedIndex == 1
              ? FloatingActionButton(
                  onPressed: _openAddTransaction,
                  backgroundColor: AppTheme.mint,
                  foregroundColor: AppTheme.navy,
                  child: const Icon(Icons.add),
                )
              : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PlaceholderPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 64,
                color: AppTheme.navy,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
