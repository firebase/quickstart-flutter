// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const GenerativeAISample());
}

class GenerativeAISample extends StatelessWidget {
  const GenerativeAISample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Vertex AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 171, 222, 244),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(title: 'Flutter + Vertex AI'),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final GenerativeModel _functionCallModel;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    initFirebase().then((value) {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-2.0-flash',
      );
      _functionCallModel = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-2.0-flash',
        tools: [
          Tool(functionDeclarations: [
            FunctionDeclaration(
                'fetchCurrentWeather',
                'Returns the weather in a given location.',
                Schema(SchemaType.object, properties: {
                  'location': Schema(SchemaType.string,
                      description: 'A location name, like "London".'),
                }, requiredProperties: [
                  'location'
                ]))
          ])
        ],
      );
      _chat = _model.startChat();
    });
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Enter a prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, idx) {
                var content = _generatedContent[idx];
                return MessageWidget(
                  text: content.text,
                  image: content.image,
                  isFromUser: content.fromUser,
                );
              },
              itemCount: _generatedContent.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: textFieldDecoration,
                    controller: _textController,
                    onSubmitted: _sendChatMessage,
                  ),
                ),
                const SizedBox.square(
                  dimension: 15,
                ),
                IconButton(
                  tooltip: 'tokenCount Test',
                  onPressed: !_loading
                      ? () async {
                          await _testCountToken();
                        }
                      : null,
                  icon: Icon(
                    Icons.numbers,
                    color: _loading
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  tooltip: 'image prompt',
                  onPressed: !_loading
                      ? () async {
                          await _sendImagePrompt(_textController.text);
                        }
                      : null,
                  icon: Icon(
                    Icons.image,
                    color: _loading
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  tooltip: 'storage prompt',
                  onPressed: !_loading
                      ? () async {
                          await _sendStorageUriPrompt(_textController.text);
                        }
                      : null,
                  icon: Icon(
                    Icons.folder,
                    color: _loading
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      await _sendChatMessage(_textController.text);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendStorageUriPrompt(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      final content = [
        Content.multi([
          TextPart(message),
          FileData(
            'image/jpeg',
            'gs://vertex-ai-example-ef5a2.appspot.com/foodpic.jpg',
          ),
        ]),
      ];
      _generatedContent.add((image: null, text: message, fromUser: true));

      var response = await _model.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendImagePrompt(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      ByteData catBytes = await rootBundle.load('assets/images/cat.jpg');
      ByteData sconeBytes = await rootBundle.load('assets/images/scones.jpg');
      final content = [
        Content.multi([
          TextPart(message),
          // The only accepted mime types are image/*.
          DataPart('image/jpeg', catBytes.buffer.asUint8List()),
          DataPart('image/jpeg', sconeBytes.buffer.asUint8List()),
        ]),
      ];
      _generatedContent.add(
        (
          image: Image.asset('assets/images/cat.jpg'),
          text: message,
          fromUser: true
        ),
      );
      _generatedContent.add(
        (
          image: Image.asset('assets/images/scones.jpg'),
          text: null,
          fromUser: true
        ),
      );

      var response = await _model.generateContent(content);
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      var response = await _chat.sendMessage(
        Content.text(message),
      );
      var text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == null) {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _testCountToken() async {
    setState(() {
      _loading = true;
    });

    const prompt = 'tell a short story';
    var response = await _model.countTokens([Content.text(prompt)]);
    print(
      'token: ${response.totalTokens}, billable characters: ${response.totalBillableCharacters}',
    );

    setState(() {
      _loading = false;
    });
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Image? image;
  final String? text;
  final bool isFromUser;

  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
              color: isFromUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              children: [
                if (text case final text?) MarkdownBody(data: text),
                if (image case final image?) image,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
