import 'package:flutter/material.dart';
import 'home.dart';
import 'offers.dart';
import 'postofferpage.dart';
import 'messages.dart';
import 'profile.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF11224E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Home()),
            ),
            icon: const Icon(Icons.home, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Offers()),
            ),
            icon: const Icon(Icons.work_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostOfferPage()),
            ),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Messages()),
            ),
            icon: const Icon(Icons.message_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Profile()),
            ),
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
