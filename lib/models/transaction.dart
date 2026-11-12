
enum TransactionType {
  income,
  expense,
}

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? description;

  const Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.description,
  });

  // Mengubah data JSON dari database menjadi objek Dart
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      title: json['title'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );
  }

  // Mengubah objek Dart menjadi JSON untuk database
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
      'description': description,
    };
  }
}
