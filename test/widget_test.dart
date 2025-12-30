// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Thay đổi đường dẫn import này cho đúng với tên project của bạn
// Ví dụ: import 'package:appsuckhoe_dack/main.dart';
import 'package:ungdungluyentap_suckhoe/main.dart'; 

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // SỬA LỖI Ở ĐÂY: Thêm tham số seenOnboarding: false
    await tester.pumpWidget(const MyApp(seenOnboarding: false));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}