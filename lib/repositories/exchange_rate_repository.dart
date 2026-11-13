
import '../models/exchange_rate.dart';
import '../services/exchange_rate_service.dart';

class ExchangeRateRepository {
  final ExchangeRateService _service = ExchangeRateService();

  Future<ExchangeRate> getExchangeRate() {
    return _service.fetchExchangeRate();
  }
}
