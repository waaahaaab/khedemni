import 'package:flutter/material.dart';
import 'offers.dart';
class PostOfferPage extends StatefulWidget {
  const PostOfferPage({super.key});

  @override
  State<PostOfferPage> createState() => _PostOfferPageState();
}

class _PostOfferPageState extends State<PostOfferPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  final List<String> _categories = [
    'Design',
    'Translation',
    'Tutoring',
    'Delivery',
    'Cleaning',
    'Programming',
  ];

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
            text: 'Post an offer!',
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

   
      body:
          SingleChildScrollView(
           child:
           Container(
             child:
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right:20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          
                                      width: 124,
                                      height: 34,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF11224E),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Save draft',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          const Text(
                            'Job Title',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: _inputDecoration('Enter job title'),
                          ),
                          const SizedBox(height: 20),
                               
                          // Category dropdown
                          const Text(
                            'Category',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            hint: const Text('Select category'),
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                            decoration: _inputDecoration(''),
                          ),
                          const SizedBox(height: 20),
                               
                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            maxLines: 4,
                            decoration: _inputDecoration('Enter job description'),
                          ),
                          const SizedBox(height: 20),
                               
                          const Text(
                            'Location',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: _inputDecoration('Enter location'),
                          ),
                          const SizedBox(height: 20),
                               
                          const Text(
                            'Salary (optional)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('Enter salary amount'),
                          ),
                          const SizedBox(height: 20),
                               
                          const Text(
                            'Schedule',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: _inputDecoration('Ex: 4h/day, weekends, etc.'),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                 ),
                  Container(
                    margin: EdgeInsets.all(25),
                    child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  // margin:EdgeInsets.only(left:10),
                                  width: 100,
                                  height: 46,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Color(0xFFFF7A00)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Color(0xFFFF7A00),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                 
                                SizedBox(
                                  width: 127,
                                  height: 46,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Show a snackbar message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Offer posted successfully!'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                
                                      // Navigate to Offers page after short delay
                                      Future.delayed(const Duration(seconds: 1), () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const Offers()),
                                        );
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF7A00),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Post',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ],
                
              ),
           ),
          ),
       );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F8FC),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );


    
  }
}