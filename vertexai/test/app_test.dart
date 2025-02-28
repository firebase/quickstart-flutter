import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vertexai/lib/main.dart';
import 'package:vertexai/lib/image_generation_screen.dart';

void main() {
  testWidgets();
}

void testWidgets(){
  testWidgetsForNavigation();
}
void testWidgetsForNavigation(){
    testWidgetsForChatScreen();
    testWidgetsForImageGenerationScreen();
}

void testWidgetsForChatScreen(){
     testWidgetsForChatWidget();
}

void testWidgetsForChatWidget(){
    testWidgetsForTextField();
    testWidgetsForSendButton();
    final chatWidgetFinder = find.byType(ChatWidget);
    expect(chatWidgetFinder, findsOneWidget);
}

void testWidgetsForImageGenerationScreen(){
  testWidgetsForTextField();
  testWidgetsForSendButton();
  final imageGenerationScreenFinder = find.byType(ImageGenerationScreen);
    expect(imageGenerationScreenFinder, findsOneWidget);
}
void testWidgetsForTextField(){
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

}
void testWidgetsForSendButton(){
    final sendButtonFinder = find.byType(ElevatedButton);
    expect(sendButtonFinder, findsOneWidget);

}

