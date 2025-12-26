import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_sivi/main.dart';
import 'package:my_sivi/features/chat/presentation/widgets/word_meaning_bottom_sheet.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Chat flow + dictionary bottom sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Open chat
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Send message
      await tester.enterText(
        find.byType(TextField),
        'Hello, Hardik Lakhani',
      );
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // ---- VALID WORD ----
      await tester.longPress(find.textContaining('Hello'));
      await tester.pumpAndSettle();

      expect(find.byType(WordMeaningBottomSheet), findsOneWidget);

      // Close sheet
      Navigator.of(
        tester.element(find.byType(BottomSheet)),
      ).pop();
      await tester.pumpAndSettle();

      // ---- INVALID WORD ----
      await tester.longPress(find.textContaining('Hardik'));
      await tester.pumpAndSettle();

      // ✅ Assert bottom sheet exists (error state)
      expect(find.byType(WordMeaningBottomSheet), findsOneWidget);
    },
  );
}