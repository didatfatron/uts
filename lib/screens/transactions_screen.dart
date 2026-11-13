
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';
  bool _isDeleting = false;

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(0);
    final result = formatted.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $result';
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Transaction transaction,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: Text(
          'Are you sure you want to delete "${transaction.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.expense),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted || _isDeleting) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await context.read<TransactionProvider>().deleteTransaction(
            transaction.id,
          );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction deleted successfully!'),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete transaction: $error'),
          backgroundColor: AppTheme.expense,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  void _openDetail(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailScreen(
          transaction: transaction,
        ),
      ),
    );
  }

  void _editTransaction(Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(
          transaction: transaction,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncome =
        transaction.type == TransactionType.income;

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () => _openDetail(transaction),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: AppTheme.background,
          child: Icon(
            isIncome
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: isIncome ? Colors.green : AppTheme.expense,
          ),
        ),
        title: Text(
          transaction.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.navy,
          ),
        ),
        subtitle: Text(
          '${transaction.category} • '
          '${transaction.date.day}/'
          '${transaction.date.month}/'
          '${transaction.date.year}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textGrey,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'}'
              '${_formatCurrency(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isIncome ? Colors.green : AppTheme.expense,
              ),
            ),
            PopupMenuButton<String>(
              enabled: !_isDeleting,
              onSelected: (value) {
                if (value == 'edit') {
                  _editTransaction(transaction);
                } else if (value == 'delete') {
                  _confirmDelete(context, transaction);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: AppTheme.expense,
                      ),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(TransactionProvider provider) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
              color: AppTheme.expense,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textGrey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: provider.loadTransactions,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(List<Transaction> allTransactions) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppTheme.textGrey,
          ),
          const SizedBox(height: 16),
          Text(
            allTransactions.isEmpty
                ? 'No transactions yet'
                : 'No $_selectedFilter transactions',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your transactions will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final allTransactions = provider.transactions;

        final filteredTransactions = allTransactions.where((transaction) {
          if (_selectedFilter == 'Income') {
            return transaction.type == TransactionType.income;
          }

          if (_selectedFilter == 'Expense') {
            return transaction.type == TransactionType.expense;
          }

          return true;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.navy,
              ),
            ),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manage your transactions',
                      style: TextStyle(
                        color: AppTheme.textGrey,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Transaction Filters
                    Wrap(
                      spacing: 10,
                      children: ['All', 'Income', 'Expense'].map((filter) {
                        final selected = _selectedFilter == filter;

                        return ChoiceChip(
                          label: Text(filter),
                          selected: selected,
                          selectedColor: AppTheme.navy,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppTheme.navy,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      '${filteredTransactions.length} transaction(s)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: provider.isLoading &&
                              allTransactions.isEmpty
                          ? _buildLoadingState()
                          : provider.errorMessage != null &&
                                  allTransactions.isEmpty
                              ? _buildErrorState(provider)
                              : filteredTransactions.isEmpty
                                  ? _buildEmptyState(allTransactions)
                                  : LayoutBuilder(
                                      builder: (context, constraints) {
                                        final crossAxisCount =
                                            constraints.maxWidth >= 900
                                                ? 2
                                                : 1;

                                        if (crossAxisCount == 1) {
                                          return ListView.builder(
                                            itemCount:
                                                filteredTransactions.length,
                                            itemBuilder: (context, index) {
                                              return _buildTransactionCard(
                                                filteredTransactions[index],
                                              );
                                            },
                                          );
                                        }

                                        return GridView.builder(
                                          itemCount:
                                              filteredTransactions.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 0,
                                            mainAxisExtent: 100,
                                          ),
                                          itemBuilder: (context, index) {
                                            return _buildTransactionCard(
                                              filteredTransactions[index],
                                            );
                                          },
                                        );
                                      },
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
