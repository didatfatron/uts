
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:moneymate/main.dart';
import 'package:moneymate/providers/transaction_provider.dart';

void main() {
  testWidgets('MoneyMate app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => TransactionProvider(),
        child: const MoneyMateApp(),
      ),
    );

    expect(find.text('My Balance'), findsOneWidget);
    expect(find.text('Recent Transactions'), findsOneWidget);
    expect(find.text('No transactions yet'), findsOneWidget);
  });
}
