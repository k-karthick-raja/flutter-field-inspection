import 'package:field_inspection/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts on the inspections placeholder', (tester) async {
    await tester.pumpWidget(const FieldInspectionApp());

    expect(find.text('Inspections'), findsOneWidget);
  });
}
