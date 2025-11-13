import 'package:flutter/material.dart';
import 'navbar.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F8FC), 
       appBar: AppBar(
       automaticallyImplyLeading: false, 
       toolbarHeight: 90,
       title: 
       RichText(
       text: TextSpan(
            children: [
              TextSpan(
            text: 'Search offers',
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            
          ),
        ),
        
       
      ],
    ),
  ),


         actions: [
         IconButton(
           onPressed: () {
          },
        icon: const Icon(Icons.notifications), 
        ),


        // 👤 Profile picture
       Padding(
         padding: const EdgeInsets.only(right: 12),
         child: GestureDetector(
           onTap: () {
             
           },
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
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 5, top: 15),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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

          const SizedBox(width: 10),

          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_alt_outlined,
                  color: Color(0xFF11224E), size: 28),
              onPressed: () {
                print('Filter clicked');
                
              },
            ),
          ),
        ],
      ),
    ),



    Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
              const CircleAvatar(
                radius: 20,
              ),
              const SizedBox(width: 10),
             
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
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

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, color: Color(0xFFFF7A00), size: 18),
              SizedBox(width: 5),
              Text(
                'Algiers, Algeria',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message_outlined),
            color: Color(0xFF11224E),
          ),
        ],
      ),
    ],
  ),
)
  ],

  
),



  bottomNavigationBar: const Navbar(),
    );
  }
}