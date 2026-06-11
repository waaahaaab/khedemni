import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat.dart';
import 'navbar.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        "name": "Sofia Ahmed",
        "message": "Hey! How's your project going?",
        "time": "2h ago",
        "image": "https://i.pravatar.cc/150?img=1",
      },
      {
        "name": "Youssef Karim",
        "message": "Can we meet tomorrow?",
        "time": "3h ago",
        "image": "https://i.pravatar.cc/150?img=2",
      },
      {
        "name": "Rania B.",
        "message": "Thank you for the offer!",
        "time": "5h ago",
        "image": "https://i.pravatar.cc/150?img=3",
      },
      {
        "name": "Ali Ben",
        "message": "I'll send the files soon.",
        "time": "1d ago",
        "image": "https://i.pravatar.cc/150?img=4",
      },
      {
        "name": "Meriem",
        "message": "Great! See you later 😊",
        "time": "2d ago",
        "image": "https://i.pravatar.cc/150?img=5",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Chats',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {},
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 25,
              right: 25,
              bottom: 5,
              top: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: const Icon(
                        Icons.search,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            height: 650,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chat(
                          userName: chat["name"]!,
                          profileImage: chat["image"]!,
                          userId: (index + 1).toString(), // ✅ CORRIGÉ
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        bottom: BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(chat["image"]!),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat["name"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                chat["message"]!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF7A00),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              chat["time"]!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
