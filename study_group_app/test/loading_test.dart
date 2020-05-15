import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/utilities/loading.dart';
import 'package:flutter/material.dart';

import 'find_group_test.dart';

void main() {
  Widget makeTestableWidget({Widget child}) {
    return StreamProvider.value(
      value: MockAuth().getUser,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Test Loading widget', (WidgetTester tester) async {
    // Test construction of the Loading widget
    var testWidget = Loading();
    await tester.pumpWidget(makeTestableWidget(child: testWidget));

    expect(find.byWidget(testWidget), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(SpinKitThreeBounce), findsOneWidget);
  });
}
