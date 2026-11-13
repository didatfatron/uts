
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/exchange_rate_provider.dart';
import '../theme/app_theme.dart';

class ExchangeRateWidget extends StatelessWidget {
  const ExchangeRateWidget({super.key});

  String _formatRate(double rate) {
    final formatted = rate.toStringAsFixed(0);

    return formatted.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExchangeRateProvider>(
      builder: (context, provider, child) {
        final exchangeRate = provider.exchangeRate;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.currency_exchange,
                    color: AppTheme.navy,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Exchange Rate',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Refresh exchange rate',
                    onPressed: provider.isLoading
                        ? null
                        : provider.loadExchangeRate,
                    icon: const Icon(
                      Icons.refresh,
                      color: AppTheme.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (provider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (provider.errorMessage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unable to load exchange rate.',
                      style: TextStyle(
                        color: AppTheme.expense,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: provider.loadExchangeRate,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                )
              else if (exchangeRate != null) ...[
                Text(
                  '1 USD = Rp ${_formatRate(exchangeRate.rate)}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Last updated: ${exchangeRate.date}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
