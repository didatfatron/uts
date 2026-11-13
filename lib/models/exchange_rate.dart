
class ExchangeRate {
  final String base;
  final String date;
  final double rate;

  const ExchangeRate({
    required this.base,
    required this.date,
    required this.rate,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    final rates = json['rates'] as Map<String, dynamic>;

    return ExchangeRate(
      base: json['base'] as String,
      date: json['date'] as String,
      rate: (rates['IDR'] as num).toDouble(),
    );
  }
}
