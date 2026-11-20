import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restyle_mobile/features/auth/screens/login_screen.dart';

void main() {
  testWidgets('RESTYLE app displays login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('RESTYLE Login'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
