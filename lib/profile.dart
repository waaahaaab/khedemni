import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/account/login.dart';
import '../services/api_service.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  bool _isEditing = false;
  bool _visibleOnHome = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<String> _roles = ['service_seeker', 'employee_recruiter'];
  final List<String> _categories = [
    'Design',
    'Translation',
    'Cooking',
    'Photography',
    'babysitting',
    'coding',
    'Delivery',
    'Cleaning',
    'Teaching',
    'Repair',
  ];

  String _selectedRole = 'service_seeker';
  String _selectedCategory = 'Design';
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  final ImagePicker _picker = ImagePicker();
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

  String _selectedWilaya = 'Alger'; // Valeur par défaut

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skillsController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final result = await ApiService.getProfile();

      // ⚠️ DEBUG COMPLET
      debugPrint('=== PROFILE API DEBUG ===');
      debugPrint('Full API response: $result');
      debugPrint('Success status: ${result['success']}');
      debugPrint('Data exists: ${result['data'] != null}');
      debugPrint('User exists: ${result['data']?['user'] != null}');

      if (result['data']?['user'] != null) {
        debugPrint('User keys: ${result['data']['user'].keys}');
        debugPrint('Username value: ${result['data']['user']['username']}');
        debugPrint(
          'Username type: ${result['data']['user']['username']?.runtimeType}',
        );
      }
      debugPrint('========================');

      if (mounted && result['success'] == true) {
        setState(() {
          _userData = result['data']['user'] ?? {};
          _nameController.text = _userData['name'] ?? '';
          _skillsController.text = _userData['skills'] ?? '';
          _bioController.text = _userData['bio'] ?? '';
          _selectedRole = _userData['role'] ?? 'service_seeker';
          _selectedCategory = _userData['category'] ?? 'Design';
          _selectedWilaya = _userData['wilaya'] ?? 'Alger';
          _phoneController.text = _userData['phone_number'] ?? '';
          _visibleOnHome = _userData['visible_on_home'] ?? false;
        });

        // ⚠️ DEBUG APRÈS ASSIGNATION
        debugPrint('After assignment - Username: ${_userData['username']}');
      } else {
        debugPrint('API returned success: false');
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        final bytes = await image.readAsBytes();

        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = image.name;
        });

        _showSnackbar(
          'Image sélectionnée ! Cliquez sur Sauvegarder pour uploader.',
          Colors.blue,
        );
      }
    } catch (e) {
      debugPrint('Erreur galerie: $e');
      _showSnackbar('Erreur avec la galerie', Colors.red);
    }
  }

  Future<void> _toggleVisibility() async {
    try {
      final result = await ApiService.toggleVisibility();

      if (mounted && result['success'] == true) {
        setState(() {
          _visibleOnHome = result['data']['visible_on_home'];
          _userData['visible_on_home'] = _visibleOnHome;
        });

        _showSnackbar(
          _visibleOnHome
              ? 'Vous êtes maintenant visible sur la page d\'accueil'
              : 'Vous n\'êtes plus visible sur la page d\'accueil',
          Colors.green,
        );
      } else {
        _showSnackbar(
          result['message'] ?? 'Erreur lors du changement de visibilité',
          Colors.red,
        );
      }
    } catch (e) {
      debugPrint('Error toggling visibility: $e');
      _showSnackbar('Erreur de connexion', Colors.red);
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir une photo'),
          content: const Text('Sélectionnez une image depuis votre galerie'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pickImageFromGallery();
              },
              child: const Text(
                'Ouvrir la galerie',
                style: TextStyle(color: Color(0xFFFF7A00)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProfile() async {
    if (!_isEditing) {
      setState(() {
        _isEditing = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updateData = {
        'name': _nameController.text.trim(),
        'skills': _skillsController.text.trim(),
        'bio': _bioController.text.trim(),
        'role': _selectedRole,
        'category': _selectedCategory,
        'wilaya': _selectedWilaya,
        'phone_number': _phoneController.text.trim(),
      };

      // ⚠️ AJOUTEZ CE LOG POUR VOIR CE QUI EST ENVOYÉ
      debugPrint('=== UPDATE PROFILE DATA ===');
      debugPrint('Update data: $updateData');
      debugPrint('===========================');

      Map<String, dynamic> result;

      if (_selectedImageBytes != null && _selectedImageName != null) {
        result = await ApiService.updateProfileWithImageWeb(
          updateData,
          _selectedImageBytes!,
          _selectedImageName!,
        );
      } else {
        result = await ApiService.updateProfile(updateData);
      }

      if (mounted) {
        if (result['success'] == true) {
          setState(() {
            _isEditing = false;
            _userData = {..._userData, ...updateData};
            _selectedImageBytes = null;
            _selectedImageName = null;
          });
          _showSnackbar('Profil mis à jour avec succès !', Colors.green);
          _loadUserProfile();
        } else {
          _showSnackbar(
            'Échec de la mise à jour: ${result['message']}',
            Colors.red,
          );
        }
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      if (mounted) {
        _showSnackbar('Erreur lors de la mise à jour du profil', Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _handleLogout() async {
    await ApiService.removeToken();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (_) => false,
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optionnel
    }

    if (value.length != 10) {
      return 'Le numéro doit contenir exactement 10 chiffres';
    }

    if (!value.startsWith('05') &&
        !value.startsWith('06') &&
        !value.startsWith('07')) {
      return 'Le numéro doit commencer par 05, 06 ou 07';
    }

    return null;
  }

  Widget _buildEditableField(
    String label,
    String value,
    TextEditingController controller, {
    bool isEditable = true,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength, // ✅ AJOUTÉ
    String? Function(String?)? validator, // ✅ AJOUTÉ
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (validator != null && _isEditing && controller.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    validator(controller.text) == null
                        ? Icons.check_circle
                        : Icons.error,
                    size: 16,
                    color: validator(controller.text) == null
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          _isEditing && isEditable
              ? TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  maxLength: maxLength,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    counterText: '', // Masquer le compteur
                    errorText: validator != null
                        ? validator(controller.text)
                        : null,
                    errorStyle: const TextStyle(fontSize: 11, height: 0.5),
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  onChanged: (value) {
                    if (validator != null) {
                      setState(() {}); // Refresh pour afficher l'icône
                    }
                  },
                )
              : Text(
                  value.isEmpty ? 'Non spécifié' : value,
                  style: TextStyle(
                    fontSize: 14,
                    color: value.isEmpty ? Colors.grey : Colors.black87,
                  ),
                ),
        ],
      ),
    );
  }

  // ⚠️ NOUVELLE MÉTHODE CORRIGÉE POUR LE USERNAME
  Widget _buildUsernameField() {
    final username = _userData['username'];
    final displayUsername = username != null && username.toString().isNotEmpty
        ? '@$username'
        : '@username';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Fond gris pour indiquer non modifiable
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nom d\'utilisateur',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            displayUsername,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey, // Texte en gris
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String currentValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _isEditing
              ? DropdownButton<String>(
                  value: currentValue,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.replaceAll('_', ' '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                )
              : Text(
                  currentValue.replaceAll('_', ' '),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
        ],
      ),
    );
  }

  Widget _buildWilayaDropdown() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wilaya',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _isEditing
              ? DropdownButton<String>(
                  value: _selectedWilaya,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: _wilayas.map((String wilaya) {
                    return DropdownMenuItem<String>(
                      value: wilaya,
                      child: Text(wilaya, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedWilaya = newValue;
                      });
                    }
                  },
                )
              : Text(
                  _selectedWilaya,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        toolbarHeight: 90,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (mounted) Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: _isLoading ? null : _updateProfile,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 Profile Header avec photo
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: _isEditing ? _showImagePickerDialog : null,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: _selectedImageBytes != null
                                    ? MemoryImage(_selectedImageBytes!)
                                    : _userData['profile_image'] != null
                                    ? NetworkImage(
                                        'http://localhost:5000${_userData['profile_image']}',
                                      )
                                    : null,
                                child:
                                    _selectedImageBytes == null &&
                                        _userData['profile_image'] == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _showImagePickerDialog,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF7A00),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _userData['name'] ?? 'Aucun nom',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // ⚠️ CORRECTION DU USERNAME DANS LE HEADER
                        Text(
                          _userData['username'] != null &&
                                  _userData['username'].toString().isNotEmpty
                              ? '@${_userData['username']}'
                              : '@username',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _userData['bio'] ?? 'Aucune bio pour le moment',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        if (_isEditing && _selectedImageBytes != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Nouvelle image sélectionnée ✓',
                              style: TextStyle(
                                color: Color(0xFFFF7A00),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🧾 Informations personnelles ÉDITABLES
                  const Text(
                    'Informations personnelles',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  _buildEditableField(
                    'Nom complet',
                    _userData['name'] ?? '',
                    _nameController,
                  ),

                  // ⚠️ UTILISATION DE LA NOUVELLE MÉTHODE CORRIGÉE POUR LE USERNAME
                  _buildUsernameField(),

                  // Role - Dropdown
                  _buildDropdownField('Rôle', _selectedRole, _roles, (
                    String? newValue,
                  ) {
                    if (newValue != null) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    }
                  }),

                  // Category - Dropdown
                  _buildDropdownField(
                    'Catégorie',
                    _selectedCategory,
                    _categories,
                    (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                  ),
                  _buildWilayaDropdown(),
                  _buildEditableField(
                    'Compétences',
                    _userData['skills'] ?? '',
                    _skillsController,
                  ),
                  _buildEditableField(
                    'Numéro de téléphone',
                    _userData['phone_number'] ?? '',
                    _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10), // ✅ Max 10 chiffres
                    ],
                    maxLength: 10,
                    validator: _validatePhoneNumber, // ✅ Validation
                  ),
                  _buildEditableField(
                    'Bio',
                    _userData['bio'] ?? '',
                    _bioController,
                  ),
                  // 🏠 Visibilité sur Home (Service Seekers uniquement)
                  if (_selectedRole == 'service_seeker') ...[
                    const Text(
                      'Visibilité',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Color(0xFFFF7A00),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Visible sur la page d\'accueil',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _visibleOnHome
                                      ? 'Les recruteurs peuvent vous voir'
                                      : 'Activez pour être visible par les recruteurs',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _visibleOnHome,
                            onChanged: _isLoading
                                ? null
                                : (bool value) {
                                    _toggleVisibility();
                                  },
                            activeThumbColor: const Color(0xFFFF7A00),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],

                  const SizedBox(height: 25),

                  // ⚙️ Section Compte
                  const Text(
                    'Paramètres du compte',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  _iconOption(
                    Icons.lock_outline,
                    'Changer le mot de passe',
                    onTap: () {
                      _showSnackbar(
                        'Changement de mot de passe bientôt disponible',
                        Colors.orange,
                      );
                    },
                  ),
                  _iconOption(
                    Icons.verified_user_outlined,
                    'Vérifier l\'identité',
                    onTap: () {
                      _showSnackbar(
                        'Vérification d\'identité bientôt disponible',
                        Colors.orange,
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // 📱 Paramètres de l'application
                  const Text(
                    'Paramètres de l\'application',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: const Text(
                      'Langue',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🆘 Aide & Support
                  const Text(
                    'Aide & Support',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  _iconOption(
                    Icons.help_outline,
                    'Contacter le support',
                    onTap: () {
                      _showSnackbar(
                        'Contact support bientôt disponible',
                        Colors.orange,
                      );
                    },
                  ),
                  _iconOption(
                    Icons.report_problem_outlined,
                    'Signaler un problème',
                    onTap: () {
                      _showSnackbar(
                        'Signalement de problème bientôt disponible',
                        Colors.orange,
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // 🔸 Bouton Déconnexion
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
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
                              'Déconnexion',
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

  // Helper for icon + text options
  Widget _iconOption(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
