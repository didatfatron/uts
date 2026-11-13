
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0);
    final result = formatted.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $result';
  }

  Widget _buildOverviewCard(
    TransactionProvider provider,
    double totalIncome,
    double totalExpense,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Balance',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _formatCurrency(provider.balance),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _overviewItem(
                  'Income',
                  totalIncome,
                  Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _overviewItem(
                  'Expense',
                  totalExpense,
                  Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewItem(
    String label,
    double amount,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 5),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            _formatCurrency(amount),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonSection(
    double totalIncome,
    double totalExpense,
    double total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Income vs Expense',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 16),
        _comparisonBar(
          label: 'Income',
          amount: totalIncome,
          total: total,
          color: Colors.green,
        ),
        const SizedBox(height: 18),
        _comparisonBar(
          label: 'Expense',
          amount: totalExpense,
          total: total,
          color: AppTheme.expense,
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    List<MapEntry<String, double>> sortedCategories,
    double totalExpense,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expenses by Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 16),
        if (sortedCategories.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No expense data available yet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textGrey),
              ),
            ),
          )
        else
          ...sortedCategories.map((entry) {
            final percentage = totalExpense == 0
                ? 0.0
                : entry.value / totalExpense;

            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _formatCurrency(entry.value),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 9,
                      backgroundColor: AppTheme.background,
                      color: AppTheme.mint,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _comparisonBar({
    required String label,
    required double amount,
    required double total,
    required Color color,
  }) {
    final percentage = total == 0 ? 0.0 : amount / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              '${(percentage * 100).toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 12,
            backgroundColor: AppTheme.background,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.transactions;

        final totalIncome = provider.totalIncome;
        final totalExpense = provider.totalExpense;
        final total = totalIncome + totalExpense;

        final expenses = transactions
            .where((t) => t.type == TransactionType.expense)
            .toList();

        final Map<String, double> categoryTotals = {};

        for (final transaction in expenses) {
          categoryTotals.update(
            transaction.category,
            (value) => value + transaction.amount,
            ifAbsent: () => transaction.amount,
          );
        }

        final sortedCategories = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Statistics',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Financial Overview',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Track your income and expenses.',
                            style: TextStyle(
                              color: AppTheme.textGrey,
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (isWideScreen)
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildOverviewCard(
                                    provider,
                                    totalIncome,
                                    totalExpense,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildComparisonSection(
                                        totalIncome,
                                        totalExpense,
                                        total,
                                      ),
                                      const SizedBox(height: 28),
                                      _buildCategorySection(
                                        sortedCategories,
                                        totalExpense,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            _buildOverviewCard(
                              provider,
                              totalIncome,
                              totalExpense,
                            ),
                            const SizedBox(height: 28),
                            _buildComparisonSection(
                              totalIncome,
                              totalExpense,
                              total,
                            ),
                            const SizedBox(height: 28),
                            _buildCategorySection(
                              sortedCategories,
                              totalExpense,
                            ),
                          ],

                          const SizedBox(height: 20),
                          Text(
                            'Total transactions: ${transactions.length}',
                            style: const TextStyle(
                              color: AppTheme.textGrey,
                              fontWeight: FontWeight.w500,
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
      },
    );
  }
}
