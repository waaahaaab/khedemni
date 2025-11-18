import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String userName;
  final String profileImage;

  const Chat({super.key, required this.userName, required this.profileImage});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hey, how are you?', 'isMe': false},
    {'text': 'I’m good, what about you?', 'isMe': true},
    {'text': 'Doing great! Working on the new project.', 'isMe': false},
    {'text': 'Oh nice! Can’t wait to see it.', 'isMe': true},
  ];

  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({'text': _controller.text, 'isMe': true});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        toolbarHeight: 90,

        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.profileImage),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(
              widget.userName,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.call,
              color: Color(0xFFFF7A00), // orange accent color
              size: 28,
            ),
            onPressed: () {
              // You can later add call logic here
              debugPrint('Call button pressed');
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // 🗨️ Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['isMe'] as bool;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0xFF94A4F1)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ✏️ Message input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF3F3F3),
                  child: IconButton(
                    icon: const Icon(
                      Icons.attach_file,
                      color: Colors.black87,
                      size: 22,
                    ),
                    onPressed: () {
                      debugPrint('File attach button pressed');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFFF7A00),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
