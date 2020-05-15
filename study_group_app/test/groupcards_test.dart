import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/screens/groups/group_card.dart';
import 'package:study_group_app/utilities/loading.dart';
import 'mock/mock_data.dart';
import 'mock/firebase_mock.dart';
import 'package:mockito/mockito.dart';

void main() {
  Widget makeTestableWidget({Widget child}) {
    return StreamProvider<User>.value(
      value: MockUserService().userData,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Construction of GroupCard', (WidgetTester tester) async {
    final userService = MockUserService();
    var groupCard = GroupCard(group: testGroup);
    when(userService.userData).thenAnswer((_) => Stream.value(user));
    await tester.pumpWidget(makeTestableWidget(child: groupCard));

    expect(find.byType(Loading), findsOneWidget);
    // await tester.pump();
    // expect(find.byType(Text), findsNWidgets(3));
  });
}
