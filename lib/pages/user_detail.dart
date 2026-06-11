import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserDetail extends StatefulWidget {
  final int userId;

  const UserDetail({super.key, required this.userId});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final result = await ApiService.getPublicProfile(widget.userId);

      if (mounted && result['success'] == true) {
        setState(() {
          _userData = result['data']['user'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${result['message']}')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Profil'),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text('Utilisateur introuvable'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // Profile Header
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _userData?['profile_image'] != null
                        ? NetworkImage(
                            'http://localhost:5000${_userData?['profile_image']}',
                          )
                        : null,
                    child: _userData?['profile_image'] == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _userData?['name'] ?? 'Utilisateur',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (_userData?['username'] != null)
                    Text(
                      '@${_userData?['username']}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _userData?['role'] == 'service_seeker'
                          ? 'Chercheur de service'
                          : 'Recruteur',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_userData?['bio'] != null && _userData?['bio'] != '')
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        _userData?['bio'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  const SizedBox(height: 25),

                  // Information cards
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Informations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  if (_userData?['email'] != null)
                    _buildInfoCard('Email', _userData?['email'], Icons.email),

                  if (_userData?['phone_number'] != null &&
                      (_userData!['phone_number'].toString().isNotEmpty))
                    _buildInfoCard(
                      'Téléphone',
                      _userData!['phone_number'],
                      Icons.phone,
                    ),

                  if (_userData?['wilaya'] != null)
                    _buildInfoCard(
                      'Wilaya',
                      _userData?['wilaya'],
                      Icons.location_city,
                    ),

                  if (_userData?['category'] != null)
                    _buildInfoCard(
                      'Catégorie',
                      _userData?['category'],
                      Icons.category,
                    ),

                  if (_userData?['skills'] != null &&
                      _userData?['skills'] != '')
                    _buildInfoCard(
                      'Compétences',
                      _userData?['skills'],
                      Icons.star,
                    ),

                  const SizedBox(height: 30),

                  // Contact button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chat bientôt disponible'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message),
                      label: const Text(
                        'Envoyer un message',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(String label, String? value, IconData icon) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFF7A00), size: 24),
          const SizedBox(width: 12),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
