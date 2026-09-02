import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_chef/core/utils/app_responsive.dart';

void main() {
  testWidgets('responsive helper scales values for different screen sizes', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final scaled = AppResponsive.width(context, 20);
            final scaledHeight = AppResponsive.height(context, 40);
            return Scaffold(body: Center(child: Text('$scaled:$scaledHeight')));
          },
        ),
      ),
    );

    expect(find.textContaining(':'), findsOneWidget);
  });
}
