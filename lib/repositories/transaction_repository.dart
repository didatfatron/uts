
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionRepository {
  final TransactionService _service = TransactionService();

  Future<List<Transaction>> getTransactions() {
    return _service.getTransactions();
  }

  Future<Transaction> addTransaction(Transaction transaction) {
    return _service.addTransaction(transaction);
  }

  Future<void> updateTransaction(Transaction transaction) {
    return _service.updateTransaction(transaction);
  }

  Future<void> deleteTransaction(String id) {
    return _service.deleteTransaction(id);
  }
}
