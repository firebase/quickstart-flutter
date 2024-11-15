import 'package:flutter/material.dart';

class Route {
  Route({
    required this.path,
    required this.label,
    required this.iconData,
  });
  final String path;
  final String label;
  final IconData iconData;
}

final homePath = Route(
  path: '/home',
  label: 'Home',
  iconData: Icons.home,
);
final searchPath = Route(
  path: '/search',
  label: 'Search',
  iconData: Icons.search,
);
final profilePath = Route(
  path: '/profile',
  label: 'Profile',
  iconData: Icons.person,
);

final paths = [homePath, searchPath, profilePath];
