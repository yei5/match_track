import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('minimal', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Text('hello')));
    expect(find.text('hello'), findsOneWidget);
  });
}
