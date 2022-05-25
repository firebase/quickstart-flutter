import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Uploading images to Firestore is done in this widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Reference _storage = FirebaseStorage.instance.ref();
  final _imagePicker = ImagePicker();

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/library');
            },
            icon: const Icon(Icons.photo_library),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null) Image.file(_image!),
              if (_image != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final _imageName = _image!.path.split('/').last;

                        // create a new reference in your Firebase Cloud Storage
                        final newImageRef =
                            _storage.child('images/$_imageName');

                        try {
                          // put a file at this references location
                          await newImageRef.putFile(_image!);
                        } on FirebaseException catch (error) {
                          // ignore: avoid_print
                          print(error);
                        }
                      },
                      child: const Text('Upload to Firebase'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: const Text('Remove Image'),
                    ),
                  ],
                ),
              const Text('Choose a photo to upload to Firestore'),
              // This button will bring up the native Image Library
              // The button is disabled if there is already an image picked.
              ElevatedButton(
                onPressed: _image == null
                    ? () async {
                        final XFile? image = await _imagePicker.pickImage(
                            source: ImageSource.gallery);

                        setState(() {
                          _image = File(image!.path);
                        });
                      }
                    : null,
                child: const Text('Choose Image'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
