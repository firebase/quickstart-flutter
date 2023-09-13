import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test fails', (WidgetTester tester) async {
    // autopass
  });
  testWidgets('Test passes', (WidgetTester tester) async {
    fail("nope");
  });
}
