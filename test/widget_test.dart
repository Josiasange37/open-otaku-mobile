import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_otaku/app.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: OpenOtakuApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text('OPEN'), findsOneWidget);
    expect(find.text('OTAKU'), findsOneWidget);
  });
}
