
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About MoneyMate'),
        content: const Text(
          'MoneyMate is a personal finance tracker '
          'that helps you record income, expenses, '
          'and monitor your financial activity.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Preferred Currency'),
        content: const ListTile(
          leading: Icon(
            Icons.currency_exchange,
            color: AppTheme.navy,
          ),
          title: Text('Indonesian Rupiah'),
          subtitle: Text('IDR (Rp)'),
          trailing: Icon(
            Icons.check_circle,
            color: AppTheme.mint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPersonalInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Personal Information'),
        content: const Text(
          'Your profile is currently stored locally. '
          'Account management will be available '
          'when authentication is integrated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVersionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Application Version'),
        content: const ListTile(
          leading: Icon(
            Icons.verified_outlined,
            color: AppTheme.navy,
          ),
          title: Text('MoneyMate'),
          subtitle: Text('Version 1.0.0'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppTheme.navy,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 55,
              color: AppTheme.mint,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'MoneyMate User',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Personal Finance Tracker',
            style: TextStyle(
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.navy,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 32),

                      _buildSectionTitle('Account'),

                      _ProfileMenuTile(
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        subtitle: 'Local application profile',
                        onTap: () =>
                            _showPersonalInformationDialog(context),
                      ),

                      const SizedBox(height: 28),

                      _buildSectionTitle('Preferences'),

                      _ProfileMenuTile(
                        icon: Icons.payments_outlined,
                        title: 'Currency',
                        subtitle: 'Indonesian Rupiah (IDR)',
                        onTap: () => _showCurrencyDialog(context),
                      ),

                      const SizedBox(height: 28),

                      _buildSectionTitle('Application'),

                      _ProfileMenuTile(
                        icon: Icons.info_outline,
                        title: 'About MoneyMate',
                        subtitle: 'Learn more about this application',
                        onTap: () => _showAboutDialog(context),
                      ),

                      _ProfileMenuTile(
                        icon: Icons.verified_outlined,
                        title: 'Application Version',
                        subtitle: 'Version 1.0.0',
                        onTap: () => _showVersionDialog(context),
                      ),

                      const SizedBox(height: 30),

                      const Center(
                        child: Text(
                          'MoneyMate © 2026',
                          style: TextStyle(
                            color: AppTheme.textGrey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.navy,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textGrey,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.textGrey,
        ),
        onTap: onTap,
      ),
    );
  }
}
