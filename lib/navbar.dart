import 'package:flutter/material.dart';
import 'offers.dart';
import 'postofferpage.dart';
import 'home.dart';
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
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => Home())),
            iconSize: 35,
            icon: const Icon(Icons.home, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => Offers())),
            iconSize: 35,
            icon: const Icon(Icons.work_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => PostOfferPage())),
            iconSize: 35,
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => Messages())),
            iconSize: 35,
            icon: const Icon(Icons.message_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => Profile())),
            iconSize: 35,
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
