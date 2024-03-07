import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

/// Retrieving files from Firebase Storage is done in this widget
class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final Reference storageRef = FirebaseStorage.instance.ref();
  List<Uint8List>? _images;

  @override
  void initState() {
    super.initState();
    _downloadImageFiles();
  }

  void _downloadImageFiles() async {
    final imagesRef = storageRef.child("images");

    try {
      final allImages = await imagesRef.listAll();
      final images = <Uint8List>[];
      for (var image in allImages.items) {
        final Uint8List? data = await image.getData();
        images.add(data!);
      }

      setState(() {
        _images = images;
      });
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
      ),
      body: Center(
        child: _images == null
            ? const CircularProgressIndicator()
            : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  for (var image in _images!)
                    Image.memory(
                      image,
                      width: 150,
                    )
                ],
              ),
      ),
    );
  }
}
