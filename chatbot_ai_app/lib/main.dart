import 'package:flutter/material.dart';

void main() {
  runApp(AIChatBotApp());
}

class AIChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Bot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];  // Store chat messages
  final TextEditingController _textController = TextEditingController();  // Controller for the input field

  // Simulating AI responses for demo purposes
  List<String> _aiResponses = [
    "Hello! How can I assist you today?",
    "I'm just a simple AI bot!",
    "That's interesting. Can you tell me more?",
    "I'm here to help with anything you need.",
    "Let me think about that for a second...",
  ];

  // Function to handle sending user messages and getting AI response
  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();  // Clear input field after sending the message

    ChatMessage message = ChatMessage(text: text, isSentByMe: true);
    setState(() {
      _messages.insert(0, message);  // Add user's message to the list
    });

    // Simulating AI response with a delay
    Future.delayed(Duration(seconds: 1), () {
      _generateAIResponse();
    });
  }

  // Generate a simple AI response (simulated)
  void _generateAIResponse() {
    String aiResponse = _aiResponses[_messages.length % _aiResponses.length];  // Pick response cyclically
    ChatMessage message = ChatMessage(text: aiResponse, isSentByMe: false);
    setState(() {
      _messages.insert(0, message);  // Add AI response to the list
    });
  }

  // Widget to build the input field and send button
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
                onSubmitted: _handleSubmitted,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chat Bot")),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,  // Display new messages at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],  // Build each chat message
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;  // Message text
  final bool isSentByMe;  // Whether the message was sent by the user

  ChatMessage({required this.text, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!isSentByMe) ...[
            CircleAvatar(child: Text("AI")),  // Avatar for AI bot
          ],
          Container(
            padding: EdgeInsets.all(10.0),
            margin: isSentByMe
                ? EdgeInsets.only(left: 40.0)
                : EdgeInsets.only(right: 40.0),
            decoration: BoxDecoration(
              color: isSentByMe ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(text, style: TextStyle(color: isSentByMe ? Colors.white : Colors.black)),
          ),
          if (isSentByMe) ...[
            CircleAvatar(child: Text("Me")),  // Avatar for user messages
          ],
        ],
      ),
    );
  }
}
