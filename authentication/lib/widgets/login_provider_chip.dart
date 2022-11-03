import 'package:flutter/material.dart';

class LoginProviderChip extends StatelessWidget {
  String providerName;
  Icon providerIcon;
  Function? onClick;

  LoginProviderChip({
    super.key,
    required this.providerName,
    required this.providerIcon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: const Color.fromARGB(31, 0, 0, 0),
      child: Row(
        children: [
          providerIcon,
          Text(providerName),
        ],
      ),
    );
  }
}
