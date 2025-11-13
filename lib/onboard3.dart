import 'package:flutter/material.dart';
import 'account/login.dart';
class Onboard3 extends StatelessWidget {
  const Onboard3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11224E),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset('assets/on1.png',
               width: 400,
               height: 500,),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Connect and start',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF11224E),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Join Khedemni and start connecting today',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(false),
                      _buildDot(false),
                      _buildDot(true),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 87,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => Login()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7A00),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          ),
                          child: const Text('Create account', style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                             fontSize: 20,
                            fontWeight: FontWeight.bold)),
                        ),
                      ),

                      SizedBox(
                        height: 87,
                        width: 130,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => Login()));
                          },
                          style: OutlinedButton.styleFrom(
                            side:  BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          ),
                          child: const Text('Login', style: TextStyle(
                            color: Color(0xFFFF7A00),
                             fontSize: 24,
                            fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF11224E) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
