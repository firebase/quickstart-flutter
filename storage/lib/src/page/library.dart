import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<Image> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
      ),
      body: _images.isEmpty
          ? const Center(
              child: Text('No images, upload an image first'),
            )
          : Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [FlutterLogo(), FlutterLogo()],
            ),
    );
  }
}
