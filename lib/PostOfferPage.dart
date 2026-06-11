import 'package:flutter/material.dart';
import 'offers.dart';
import '../services/api_service.dart';

class PostOfferPage extends StatefulWidget {
  const PostOfferPage({super.key});

  @override
  State<PostOfferPage> createState() => _PostOfferPageState();
}

class _PostOfferPageState extends State<PostOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _scheduleController = TextEditingController();

  String? _selectedCategory;
  String? _selectedWilaya;
  bool _isLoading = false;

  final List<String> _categories = [
    'Design',
    'Translation',
    'Cooking',
    'Photography',
    'babysitting',
    'Coding',
    'Delivery',
    'Cleaning',
    'Teaching',
    'Repair',
  ];

  final List<String> _wilayas = [
    'Adrar',
    'Chlef',
    'Laghouat',
    'Oum El Bouaghi',
    'Batna',
    'Béjaïa',
    'Biskra',
    'Béchar',
    'Blida',
    'Bouira',
    'Tamanrasset',
    'Tébessa',
    'Tlemcen',
    'Tiaret',
    'Tizi Ouzou',
    'Alger',
    'Djelfa',
    'Jijel',
    'Sétif',
    'Saïda',
    'Skikda',
    'Sidi Bel Abbès',
    'Annaba',
    'Guelma',
    'Constantine',
    'Médéa',
    'Mostaganem',
    'M\'Sila',
    'Mascara',
    'Ouargla',
    'Oran',
    'El Bayadh',
    'Illizi',
    'Bordj Bou Arréridj',
    'Boumerdès',
    'El Tarf',
    'Tindouf',
    'Tissemsilt',
    'El Oued',
    'Khenchela',
    'Souk Ahras',
    'Tipaza',
    'Mila',
    'Aïn Defla',
    'Naâma',
    'Aïn Témouchent',
    'Ghardaïa',
    'Relizane',
    'Timimoun',
    'Bordj Badji Mokhtar',
    'Ouled Djellal',
    'Béni Abbès',
    'In Salah',
    'In Guezzam',
    'Touggourt',
    'Djanet',
    'El M\'Ghair',
    'El Menia',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _salaryController.dispose();
    _scheduleController.dispose();
    super.dispose();
  }

  Future<void> _saveDraft() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final categoriesResult = await ApiService.getCategories();

        if (categoriesResult['success'] != true) {
          throw Exception('Failed to load categories');
        }

        final categories = categoriesResult['data']['categories'];
        final category = categories.firstWhere(
          (cat) => cat['name'] == _selectedCategory,
          orElse: () => null,
        );

        if (category == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a valid category')),
          );
          return;
        }

        final offerData = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category_id': category['id'],
          'location': _selectedWilaya ?? '',
          'salary': _salaryController.text.isNotEmpty
              ? double.parse(_salaryController.text)
              : null,
          'schedule': _scheduleController.text,
          'status': 'draft',
        };

        final result = await ApiService.createOffer(offerData);

        if (!mounted) return;

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Draft saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _postOffer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final categoriesResult = await ApiService.getCategories();

        if (categoriesResult['success'] != true) {
          throw Exception('Failed to load categories');
        }

        final categories = categoriesResult['data']['categories'];
        final category = categories.firstWhere(
          (cat) => cat['name'] == _selectedCategory,
          orElse: () => null,
        );

        if (category == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a valid category')),
          );
          return;
        }

        final offerData = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'category_id': category['id'],
          'location': _selectedWilaya ?? '',
          'salary': _salaryController.text.isNotEmpty
              ? double.parse(_salaryController.text)
              : null,
          'schedule': _scheduleController.text,
          'status': 'published',
        };

        final result = await ApiService.createOffer(offerData);

        if (!mounted) return;

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offer posted successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Offers()),
            (Route<dynamic> route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Post an offer!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.black),
          ),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 124,
                          height: 34,
                          child: ElevatedButton(
                            onPressed: _saveDraft,
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
                  Padding(
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _titleController,
                              decoration: _inputDecoration('Enter job title'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a job title';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Category dropdown
                            const Text(
                              'Category',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedCategory,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: _inputDecoration(
                                'Enter job description',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // ✅ WILAYA DROPDOWN (remplace le champ texte Location)
                            const Text(
                              'Location (Wilaya)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedWilaya,
                              hint: const Text('Sélectionnez une wilaya'),
                              isExpanded: true,
                              items: _wilayas.map((String wilaya) {
                                return DropdownMenuItem<String>(
                                  value: wilaya,
                                  child: Text(wilaya),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedWilaya = value;
                                });
                              },
                              decoration: _inputDecoration(''),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez sélectionner une wilaya';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              'Salary (optional)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _salaryController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(
                                'Enter salary amount',
                              ),
                            ),
                            const SizedBox(height: 20),

                            const Text(
                              'Schedule',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _scheduleController,
                              decoration: _inputDecoration(
                                'Ex: 4h/day, weekends, etc.',
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
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
                            onPressed: _isLoading ? null : _postOffer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7A00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
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
