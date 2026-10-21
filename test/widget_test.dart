import 'package:flutter_test/flutter_test.dart';
import 'package:rail_staff_helper/main.dart';

void main() {
  testWidgets('Rail Staff Helper loads successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RailStaffHelperApp());

    expect(find.text('Rail Staff Helper'), findsNWidgets(2));
  });
}