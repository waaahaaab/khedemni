import 'package:flutter/material.dart';
import 'navbar.dart';
import 'pages/user_detail.dart';
import '../services/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = 'User';
  bool _isLoading = true;
  List<dynamic> _allUsers = [];
  List<dynamic> _filteredUsers = [];

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
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

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadVisibleServiceSeekers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final result = await ApiService.getProfile();

      if (result['success'] == true && mounted) {
        setState(() {
          userName = result['data']['user']['name'] ?? 'User';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> _loadVisibleServiceSeekers() async {
    try {
      final result = await ApiService.getVisibleServiceSeekers(limit: 50);

      if (mounted && result['success'] == true) {
        setState(() {
          _allUsers = result['data']['users'] ?? [];
          _filteredUsers = _allUsers;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading service seekers: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterUsers() {
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        // Filtre par catégorie
        bool matchesCategory =
            _selectedCategory == 'All' ||
            user['category']?.toString().toLowerCase() ==
                _selectedCategory.toLowerCase();

        // Filtre par recherche
        bool matchesSearch =
            _searchController.text.isEmpty ||
            user['name']?.toString().toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ==
                true ||
            user['skills']?.toString().toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ==
                true ||
            user['bio']?.toString().toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ==
                true;

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
        _filterUsers();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF7A00) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF7A00)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF11224E),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetail(userId: user['id']),
          ),
        );
      },
      child: Container(
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
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: user['profile_image'] != null
                      ? NetworkImage(
                          'http://localhost:5000${user['profile_image']}',
                        )
                      : null,
                  child: user['profile_image'] == null
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? 'User',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF11224E),
                          fontSize: 16,
                        ),
                      ),
                      if (user['username'] != null)
                        Text(
                          '@${user['username']}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user['category'] ?? 'General',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (user['bio'] != null && user['bio'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                user['bio'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
            if (user['skills'] != null &&
                user['skills'].toString().isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFF7A00), size: 16),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      user['skills'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (user['wilaya'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFFFF7A00),
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user['wilaya'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Hello ${userName.split(' ')[0]}!\n',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const TextSpan(
                text: 'Découvrez les chercheurs de services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
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
        children: [
          // BARRE DE RECHERCHE
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterUsers(),
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, compétences...',
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
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),

          // FILTRES PAR CATÉGORIES
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              children: _categories
                  .map((cat) => _buildCategoryChip(cat))
                  .toList(),
            ),
          ),

          // LISTE DES UTILISATEURS
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _allUsers.isEmpty
                              ? 'Aucun chercheur de service visible'
                              : 'Aucun résultat',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _allUsers.isEmpty
                              ? 'Les service seekers peuvent activer\nleur visibilité dans leur profil'
                              : 'Essayez une autre recherche ou catégorie',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadVisibleServiceSeekers,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(_filteredUsers[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
