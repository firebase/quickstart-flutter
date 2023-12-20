import 'package:flutter/material.dart';

import 'home_page.dart';
import 'restaurant_page.dart';

class FriendlyEatsApp extends StatelessWidget {
  const FriendlyEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyEats',
      initialRoute: '/',
      home: const HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RestaurantPage.route:
            final RestaurantPageArguments arguments =
                settings.arguments as RestaurantPageArguments;
            return MaterialPageRoute(
              builder: (context) => RestaurantPage(
                restaurant: arguments.restaurant,
              ),
            );

          default:
            return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
    );
  }
}
