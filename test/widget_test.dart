
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymate/main.dart';

void main() {
  testWidgets('MoneyMate app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MoneyMateApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
