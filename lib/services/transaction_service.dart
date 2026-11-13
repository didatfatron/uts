
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/transaction.dart';

class TransactionService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Transaction>> getTransactions() async {
    final response = await _client
        .from('transactions')
        .select()
        .order('date', ascending: false);

    return response
        .map((json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> addTransaction(Transaction transaction) async {
    final response = await _client
        .from('transactions')
        .insert(transaction.toJson())
        .select()
        .single();

    return Transaction.fromJson(response);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _client
        .from('transactions')
        .update(transaction.toJson())
        .eq('id', transaction.id);
  }

  Future<void> deleteTransaction(String id) async {
    await _client
        .from('transactions')
        .delete()
        .eq('id', id);
  }
}
