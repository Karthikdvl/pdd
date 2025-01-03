import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // For JSON encoding/decoding

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AIassistant(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AIassistant extends StatefulWidget {
  const AIassistant({super.key});

  @override
  State<AIassistant> createState() => _AIassistantState();
}

class _AIassistantState extends State<AIassistant> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "assets/logo1.png",
  );

  @override
  void initState() {
    super.initState();
    _loadConversationHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "AI Assistant",
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: DashChat(
              inputOptions: InputOptions(
                trailing: [
                  IconButton(
                    onPressed: _sendMediaMessage,
                    icon: const Icon(
                      Icons.image,
                    ),
                  ),
                ],
              ),
              currentUser: currentUser,
              onSend: _sendMessage,
              messages: messages,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    _saveConversationHistory();
    _generateResponse(chatMessage);
  }

  void _generateResponse(ChatMessage chatMessage) {
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini.streamGenerateContent(
        question,
        images: images,
      ).listen((event) {
        String response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.text}") ??
            "";
        ChatMessage message = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        setState(() {
          messages = [message, ...messages];
        });
        _saveConversationHistory();
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          ),
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  Future<void> _saveConversationHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonMessages =
        messages.map((message) => message.toJson()).toList();
    prefs.setString("conversation", json.encode(jsonMessages));
  }

  Future<void> _loadConversationHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessages = prefs.getString("conversation");
    if (savedMessages != null) {
      List<dynamic> jsonMessages = json.decode(savedMessages);
      setState(() {
        messages = jsonMessages
            .map((jsonMessage) =>
                ChatMessageExtensions.fromJson(jsonMessage as Map<String, dynamic>))
            .toList();
      });
    }
  }
}

// Extensions for serializing and deserializing ChatMessage
extension ChatMessageExtensions on ChatMessage {
  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': user.id,
        'firstName': user.firstName,
        'profileImage': user.profileImage,
      },
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      user: ChatUser(
        id: json['user']['id'],
        firstName: json['user']['firstName'],
        profileImage: json['user']['profileImage'],
      ),
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
