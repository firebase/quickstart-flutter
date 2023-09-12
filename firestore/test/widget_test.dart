import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyWidget displays text', (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(MyWidget(text: 'Hello, World'));

    // Verify that our widget displays the correct text
  }
}
