import 'package:flutter/material.dart';

import '../utils.dart';

typedef EmptyListActionButtonCallback = void Function();

class EmptyListView extends StatelessWidget {
  const EmptyListView({
    super.key,
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final EmptyListActionButtonCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var imageSize = 600.0;
    if (screenWidth < 640 || screenHeight < 820) {
      imageSize = 300;
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Image.asset(
              imagePath('friendlyeater.png'),
            ),
          ),
          child,
          MaterialButton(
            onPressed: onPressed,
            child: const Text('ADD SOME'),
          ),
        ],
      ),
    );
  }
}
