import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          secondary: Colors.lightBlue,
          tertiary: Colors.lightBlue.shade100,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.5),
        ),
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
    firstName: "GPT",
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo1.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              "AI Assistant",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: DashChat(
                currentUser: currentUser,
                onSend: _sendMessage,
                messages: messages,
                messageOptions: MessageOptions(
                  showTime: true,
                  messagePadding: const EdgeInsets.all(10),
                  messageDecorationBuilder:
                      (message, previousMessage, nextMessage) {
                    return BoxDecoration(
                      color: message.user == currentUser
                          ? Colors.lightBlue
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    );
                  },
                  messageTextBuilder: (message, previousMessage, nextMessage) {
                    return Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                inputOptions: InputOptions(
                  inputTextStyle: const TextStyle(fontSize: 16),
                  inputDecoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  trailing: [
                    IconButton(
                      onPressed: _sendMediaMessage,
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

      // Show typing indicator
      setState(() {
        messages = [
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: "Typing...",
          ),
          ...messages,
        ];
      });

      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen(
        (event) {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            // Remove typing indicator and add new message
            messages = messages.where((m) => m.text != "Typing...").toList();
            messages = [message, ...messages];
          });
          _saveConversationHistory();
        },
        onError: (error) {
          // Remove typing indicator and show error message
          setState(() {
            messages = messages.where((m) => m.text != "Typing...").toList();
            messages = [
              ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: "Sorry, I encountered an error. Please try again.",
              ),
              ...messages,
            ];
          });
        },
      );
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
        text: "Explain this ingredients usage?",
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
            .map((jsonMessage) => ChatMessageExtensions.fromJson(
                jsonMessage as Map<String, dynamic>))
            .toList();
      });
    }
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Chat"),
        content: const Text("Are you sure you want to clear all messages?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("conversation");
              setState(() {
                messages.clear();
              });
              Navigator.pop(context);
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }
}

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
