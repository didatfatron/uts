
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();

  final List<Transaction> _transactions = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Transaction> get transactions =>
      List.unmodifiable(_transactions);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

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

  Future<void> loadTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.getTransactions();

      _transactions
        ..clear()
        ..addAll(data);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final savedTransaction =
          await _repository.addTransaction(transaction);

      _transactions.add(savedTransaction);
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _repository.updateTransaction(transaction);

      final index = _transactions.indexWhere(
        (item) => item.id == transaction.id,
      );

      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);

      _transactions.removeWhere(
        (transaction) => transaction.id == id,
      );

      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
      rethrow;
    }
  }
}
