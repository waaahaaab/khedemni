import 'package:flutter/material.dart';
import 'offers.dart';
import 'PostOfferPage.dart';
import 'home.dart';
import 'messages.dart';
import 'profile.dart';
class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF11224E), // dark blue background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(context, 
              MaterialPageRoute(
              builder:( context) => Home()));
            },
            iconSize: 35,
            icon: const Icon(
              Icons.home,
              color: Colors.white,
              ), // orange active icon
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, 
              MaterialPageRoute(
              builder:( context) => Offers()));
            },
             iconSize: 35,
            icon: const Icon(Icons.work_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
               MaterialPageRoute(builder:
               (context) => PostOfferPage()));
            },
             iconSize: 35,
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
             Navigator.push(context,
               MaterialPageRoute(builder:
               (context) => messages()));
            },
             iconSize: 35,
            icon: const Icon(Icons.message_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
               MaterialPageRoute(builder:
               (context) => Profile()));
            },
             iconSize: 35,
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
