import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/screens/groups/group_card.dart';
import 'package:study_group_app/utilities/loading.dart';
import 'mock/mock_data.dart';

void main() {
  Widget makeTestableWidget({Widget child, StreamController<User> sc}) {
    return StreamProvider.value(
      value: sc.stream,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Construction of GroupCard', (WidgetTester tester) async {
    // Create fake stream of User
    final controller = StreamController<User>(sync: true);
    // GroupCard widget to test
    var groupCard = GroupCard(group: testGroup);

    await tester.pumpWidget(
      makeTestableWidget(child: groupCard, sc: controller),
    );

    // Since initialData is null, expect the Loading widget
    expect(find.byType(Loading), findsOneWidget);

    // Add the user to the stream
    controller.add(user);
    await tester.pump();
    // Make sure after user returns data the widget loads
    expect(find.byType(Container).first, findsOneWidget);
  });

  testWidgets('Test GroupCard, display of group name', (WidgetTester tester) async {
    // Create fake stream of User
    final controller = StreamController<User>(sync: true);
    // GroupCard widget to test
    var groupCard = GroupCard(group: testGroup);
    await tester.pumpWidget(
      makeTestableWidget(child: groupCard, sc: controller),
    );

    // Set up GroupCard
    controller.add(user);
    await tester.pump();

    expect(find.text(testGroup.name), findsOneWidget);
  });

  testWidgets('Test GroupCard, display of group day', (WidgetTester tester) async {
    // Create fake stream of User
    final controller = StreamController<User>(sync: true);
    // GroupCard widget to test
    var groupCard = GroupCard(group: testGroup);
    await tester.pumpWidget(
      makeTestableWidget(child: groupCard, sc: controller),
    );

    // Set up GroupCard
    controller.add(user);
    await tester.pump();

    expect(find.text(testGroup.day), findsOneWidget);
  });

  testWidgets('Test GroupCard, display of group maxMembers', (WidgetTester tester) async {
    // Create fake stream of User
    final controller = StreamController<User>(sync: true);
    // GroupCard widget to test
    var groupCard = GroupCard(group: testGroup);
    await tester.pumpWidget(
      makeTestableWidget(child: groupCard, sc: controller),
    );

    // Set up GroupCard
    controller.add(user);
    await tester.pump();

    expect(find.text('Members: ${testGroup.maxMembers}'), findsOneWidget);
  });
}
