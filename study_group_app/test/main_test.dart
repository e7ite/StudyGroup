import 'package:flutter_test/flutter_test.dart';
import 'package:study_group_app/main.dart';
import 'package:study_group_app/screens/wrapper.dart';

void main() {
  testWidgets('Main function Test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(Wrapper), findsOneWidget);
  });
}
