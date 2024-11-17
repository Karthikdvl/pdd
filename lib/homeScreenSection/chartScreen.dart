import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Bot AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.chat, color: Colors.white),
            ),
            SizedBox(width: 8),
            Text(
              'Chat Bot AI 4.5',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _buildUserMessage(
                  "Give me some more details about the product and ingredients used",
                ),
                const SizedBox(height: 16),
                _buildBotMessage(),
              ],
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message),
      ),
    );
  }

  Widget _buildBotMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductSection(),
            const Divider(),
            _buildBenefitsSection(),
            const Divider(),
            _buildIngredientsSection(),
            const Divider(),
            _buildHowToUseSection(),
            const Divider(),
            _buildAdditionalInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Product Name: ABC Sunscreen Cream',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Type: Daily Sunscreen'),
        Text('SPF: 20'),
        Text('PA: +(Provides protection against UVA rays)'),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Benefits:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _buildBulletPoints([
          'Protects skin from harmful UVA and UVB rays',
          'Helps prevent sunburn and premature aging',
          'Non-comedogenic (won\'t clog pores)',
          'Suitable for all skin types',
        ]),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Ingredients:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _buildBulletPoints([
          'Strawberry Extract: Provides antioxidants and moisturizes the skin',
          'Sunscreen Agents: Protect the skin from harmful UV rays',
        ]),
      ],
    );
  }

  Widget _buildHowToUseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How to Use:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _buildBulletPoints([
          'Apply a generous amount to your face and neck 30 minutes before sun exposure',
          'Reapply every 2-3 hours or more frequently if sweating or swimming',
        ]),
      ],
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Information:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _buildBulletPoints([
          'The product is available in different sizes and formulations',
          'It is recommended to patch test the product before full use to check for any allergies or sensitivities',
          'Store the product in a cool, dry place away from direct sunlight',
        ]),
      ],
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points
          .map((point) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(point)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Ask me anything...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              // Implement voice input
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Implement message sending
              if (_messageController.text.isNotEmpty) {
                // Add message sending logic here
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}