import 'package:flutter/material.dart';

class LoginProviderChip extends StatelessWidget {
  String providerName;
  Icon providerIcon;
  VoidCallback? onClick;

  LoginProviderChip({
    super.key,
    required this.providerName,
    required this.providerIcon,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    var loginButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.all(8.0),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(
        left: 32.0,
        top: 4.0,
        right: 32.0,
        bottom: 0.0,
      ),
      child: ElevatedButton(
        style: loginButtonStyle,
        onPressed: onClick,
        child: Row(
          children: [
            providerIcon,
            Text(providerName),
          ],
        ),
      ),
    );
  }
}
