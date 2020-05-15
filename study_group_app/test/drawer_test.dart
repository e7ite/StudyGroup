import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/screens/home/drawer.dart';
import 'mock/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:study_group_app/services/auth.dart';

class MockAuth extends Mock implements Auth {}

void main () {
  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(
        home: child,
      );
  }

  group('Main Drawer UI Testing:', () {
    testWidgets('Displays correct amount of labels', (WidgetTester tester) async {
      var testWidget = MainDrawer(user: user);
      await tester.pumpWidget(makeTestableWidget(child: testWidget));

      expect(find.byType(Text), findsNWidgets(5));
    });

    testWidgets('Displays correct amount of drawer buttons', (WidgetTester tester) async {
      var testWidget = MainDrawer(user: user);
      await tester.pumpWidget(makeTestableWidget(child: testWidget));

      expect(find.byType(ListTile) , findsNWidgets(4));
    });
  });
}