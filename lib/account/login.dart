import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'createAcc.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Login> {
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
                margin: EdgeInsets.only(left: 25,bottom: 25, top: 25),
                child: Text('Hi!', style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 36, 
                  fontWeight: FontWeight.bold))),
            ],
          ),



           // Email input
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 15),
              
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                   hintStyle: const TextStyle(
                   fontSize: 20,       
                   color: Color(0xFFB0B8C5),
                 ),
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

              margin: EdgeInsets.only(left: 25, right: 25, bottom: 5),
              child: TextField(
                obscureText: true, // hides password text
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                   fontSize: 20,       
                   color: Color(0xFFB0B8C5), 
                 ),
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
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(
                    builder: (context) => Home()));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 25,bottom: 5, top: 15),
                child: Text('Don’t have an account?', style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16, 
                 ))
                  ),

                  
                
                 // 🔹 "Sign up" clickable text
     GestureDetector(
       onTap: () {
        Navigator.push(
          context , MaterialPageRoute(
          builder: (context) => CreateAcc()));
       },
      
      child: Container( 
        margin: const EdgeInsets.only(left: 5, bottom: 5, top: 15),
        child: const Text(
          'Sign up',
          style: TextStyle(
            color: Color(0xFFFF7A00),
            fontSize: 16,
            fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),


        ],
      ),


      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
           onTap: () {
            Navigator.push(
              context , MaterialPageRoute(
              builder: (context) => CreateAcc()));
           },
          
          child: Container( 
            margin: const EdgeInsets.only(left: 25, bottom: 5, top: 15),
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                color: Color(0xFFFF7A00),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ),
        ],
      ),


        ],
        
        )
    );
  }
}