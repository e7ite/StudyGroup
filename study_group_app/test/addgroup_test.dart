import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/screens/groups/add_group.dart';

import 'find_group_test.dart';

/*
import 'package:study_group_app/screens/groups/add_group.dart';
import 'package:flutter/material.dart';
*/
void main() {
  Widget makeTestableWidget({Widget child}) {
    return StreamProvider.value(
      value: MockAuth().getUser,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('Creating new group study session.', () {
    testWidgets('Simple study group input that follows all rules.',
        (WidgetTester tester) async {
      var page = CreateGroup();
      // Invokes the CreateGroup form
      await tester.pumpWidget(makeTestableWidget(child: page));

      expect(find.byWidget(page), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      // expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Imitate user input
      // await tester.enterText(
      // find.byType(TextFormField), 'MyTestGroup'); // Group Name
      // Calls build method in widget
      // await tester.pump();

      // Set Expectations
    });
  });
}
