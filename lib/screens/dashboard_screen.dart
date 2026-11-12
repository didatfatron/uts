
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0);
    final result = formatted.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp $result';
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'bills':
        return Icons.receipt_long;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'salary':
        return Icons.account_balance_wallet;
      default:
        return Icons.payments_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.transactions;
        final recentTransactions = transactions.reversed.take(3).toList();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.mint,
                        child: Icon(
                          Icons.person,
                          color: AppTheme.navy,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(
                                color: AppTheme.textGrey,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'MoneyMate User 👋',
                              style: TextStyle(
                                color: AppTheme.navy,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppTheme.navy,
                          size: 28,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'My Balance',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textGrey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.navy,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppTheme.mint,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Total Balance',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _formatCurrency(provider.balance),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: AppTheme.mint,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Your finances at a glance',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Income and Expense
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: 'Income',
                              amount: _formatCurrency(provider.totalIncome),
                              icon: Icons.arrow_downward_rounded,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryCard(
                              title: 'Expense',
                              amount: _formatCurrency(provider.totalExpense),
                              icon: Icons.arrow_upward_rounded,
                              color: AppTheme.expense,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // Recent Transactions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (recentTransactions.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 42,
                            color: AppTheme.textGrey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No transactions yet',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.navy,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your recent transactions will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...recentTransactions.map(
                      (transaction) => _TransactionTile(
                        transaction: transaction,
                        icon: _categoryIcon(transaction.category),
                        formatCurrency: _formatCurrency,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textGrey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: const TextStyle(
                color: AppTheme.navy,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final IconData icon;
  final String Function(double) formatCurrency;

  const _TransactionTile({
    required this.transaction,
    required this.icon,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.background,
            child: Icon(icon, color: AppTheme.navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.category} • '
                  '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isIncome ? Colors.green : AppTheme.expense,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
