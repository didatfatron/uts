
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions =>
      List.unmodifiable(_transactions);

  double get totalIncome {
    return _transactions
        .where((transaction) =>
            transaction.type == TransactionType.income)
        .fold(0.0, (total, transaction) => total + transaction.amount);
  }

  double get totalExpense {
    return _transactions
        .where((transaction) =>
            transaction.type == TransactionType.expense)
        .fold(0.0, (total, transaction) => total + transaction.amount);
  }

  double get balance => totalIncome - totalExpense;

  // Menambahkan transaksi baru.
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Memperbarui transaksi.
  void updateTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (transaction) => transaction.id == updatedTransaction.id,
    );

    if (index == -1) return;

    _transactions[index] = updatedTransaction;
    notifyListeners();
  }

  // Menghapus transaksi.
  void deleteTransaction(String id) {
    _transactions.removeWhere(
      (transaction) => transaction.id == id,
    );

    notifyListeners();
  }
}
