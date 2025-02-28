import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:firebase_vertexai/src/generative_model.dart';
import 'package:firebase_vertexai/src/data_part.dart';
import 'package:firebase_vertexai/src/content.dart';
import 'dart:typed_data';
import 'package:firebase_vertexai/src/file_data.dart';

class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({super.key});

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  final TextEditingController _promptController = TextEditingController();
  Uint8List? _generatedImage;
  bool _loading = false;
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
     _initFirebase().then((value) {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-pro',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Generation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                hintText: 'Enter your prompt here',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _generateImage,
              child: const Text('Generate Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _generateImage,
              child: const Text('Generate Image'),
            ),
            if (_generatedImage case final generatedImage?) Image.memory(_generatedImage!),
            if(_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

    Future<void> _generateImage() async {
    setState(() {
      _loading = true;
    });

    try {
        // Simulate an error
        throw Exception('Failed to generate image');
    } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
        setState(() {
            _loading = false;
        });
        _promptController.clear();
    }
}
}
