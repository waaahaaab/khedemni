import 'package:flutter/material.dart';
import 'package:flutter_application_1/account/login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      
        appBar: AppBar(
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // returns to previous screen
          },
        ),
        title: const Text('Profile'),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Profile Header
          Center(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   const CircleAvatar(
                     radius: 45,
                     backgroundImage: AssetImage('assets/images/profile.jpg'),
                   ),
                   const SizedBox(width: 15),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: const [
                       Text(
                         'rania mahani',
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                         ),
                       ),
                       SizedBox(height: 5),
                       Text(
                         '@rania_mahani', // 👈 pseudo (you can replace with real one)
                         style: TextStyle(
                           fontSize: 14,
                           color: Colors.grey,
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
               const SizedBox(height: 15),
      const Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 13,
          color: Colors.black54,
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 25),

            // 🧾 Role
            _infoBox('Role: Service seeker'),

            const SizedBox(height: 10),

            // 🧠 Skills
            _infoBox('Skills: Logo design, front-end web dev, translation'),

            const SizedBox(height: 10),

            // 🪄 Projects
            _infoBox('Khedemni projects: none yet'),

            const SizedBox(height: 25),

            // ⚙️ Account Section
            const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            _iconOption(Icons.person_outline, 'Edit profile information'),
            _iconOption(Icons.lock_outline, 'Change password'),
            _iconOption(Icons.verified_user_outlined, 'Verify identity'),

            const SizedBox(height: 25),

            // 📱 App Settings
            const Text(
              'App Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            _infoBox('Language\nDark mode'),

            const SizedBox(height: 25),

            // 🆘 Help & Support
            const Text(
              'Help & Support',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            _iconOption(Icons.help_outline, 'Contact support'),
            _iconOption(Icons.report_problem_outlined, 'Report a problem'),

            const SizedBox(height: 40),

            // 🔸 Logout Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push(context,
               MaterialPageRoute(builder:
               (context) => Login()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for info boxes
  Widget _infoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  // Helper for icon + text options
  Widget _iconOption(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
