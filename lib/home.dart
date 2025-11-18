import 'package:flutter/material.dart';
import 'navbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hello Rania!\n',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Welcome to Khedemni.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 15),
            padding: EdgeInsets.only(right: 10),
            child: TextField(
              obscureText: true, // hides password text
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

          Container(
            margin: EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Choose your intrest',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryCard('Design'),
                        _buildCategoryCard('Translation'),
                        _buildCategoryCard('Cooking'),
                        _buildCategoryCard('Photography'),
                        _buildCategoryCard('babysitting'),
                        _buildCategoryCard('coding'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFE0E0E0)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // 🔹 pushes text left & arrow right
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Recent offers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF11224E),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Discover the most recent offers',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF11224E),
                  size: 20,
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Profile image
                        const CircleAvatar(radius: 20),
                        const SizedBox(width: 10),
                        // Name + time
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Amel B.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF11224E),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Posted 2h ago',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Looking for a delivery person for short errands around town.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Category: Delivery',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF11224E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 🔹 Row 3 — location + message button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFFFF7A00),
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Algiers, Algeria',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),

                    // Message icon
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_outlined),
                      color: Color(0xFF11224E),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: const Navbar(),
    );
  }

  Widget _buildCategoryCard(String title) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ), // keep some padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF11224E),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
