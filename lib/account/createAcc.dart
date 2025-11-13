import 'package:flutter/material.dart';

class CreateAcc extends StatefulWidget {
  const CreateAcc({super.key});

  @override
  State<CreateAcc> createState() => _CreateAccState();
}

class _CreateAccState extends State<CreateAcc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF11224E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // items go from top
        crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset('assets/logowhite.png',
            width: 192,
            height: 158,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 25,bottom: 25, top: 25,right:25),
                child: Text('Looks like you dont have an account.\nlet’s create one for you.', style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18, 
                  ))),
            ],
          ),



           // Email input
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 27, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Password input
            Container(

              margin: EdgeInsets.only(left: 25, right: 25, bottom: 15),
              child: TextField(
                obscureText: true, // hides password text
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 27, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

           Container(
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 5),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 27, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),


 // Login button
            Container(
              margin: EdgeInsets.all(25),
              child: SizedBox(
                width: double.infinity,
                height: 66,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),


        ],
        
        )
    );
  }
}