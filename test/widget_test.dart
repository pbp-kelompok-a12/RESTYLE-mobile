
import 'package:flutter_test/flutter_test.dart';
import 'package:restyle_mobile/app.dart';

void main() {
  testWidgets('RESTYLE app displays login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RestyleApp());

    expect(find.text('RESTYLE Login'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
