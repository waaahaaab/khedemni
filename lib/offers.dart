import 'package:flutter/material.dart';
import 'navbar.dart';
import 'pages/offer_detail.dart';
import 'services/api_service.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  List<dynamic> _allOffers = [];
  List<dynamic> _filteredOffers = [];
  bool isLoading = true;
  int? _currentUserId;

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
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

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadOffers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final result = await ApiService.getProfile();
      if (result['success'] == true && mounted) {
        setState(() {
          _currentUserId = result['data']['user']['id'];
        });
      }
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  Future<void> _loadOffers() async {
    final result = await ApiService.getOffers();
    if (!mounted) return;
    if (result['success'] == true) {
      setState(() {
        _allOffers = result['data']['offers'];
        _filteredOffers = _allOffers;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load offers: ${result['message']}')),
      );
    }
  }

  void _filterOffers() {
    setState(() {
      _filteredOffers = _allOffers.where((offer) {
        // Filtre par catégorie
        bool matchesCategory =
            _selectedCategory == 'All' ||
            offer['category_name']?.toString().toLowerCase() ==
                _selectedCategory.toLowerCase();

        // Filtre par recherche
        bool matchesSearch =
            _searchController.text.isEmpty ||
            offer['title']?.toString().toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ==
                true ||
            offer['description']?.toString().toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ==
                true ||
            offer['location']?.toString().toLowerCase().contains(
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
        _filterOffers();
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

  Future<void> _toggleOfferStatus(int offerId, int offerUserId) async {
    if (_currentUserId != offerUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous ne pouvez pas modifier cette offre'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final result = await ApiService.toggleOfferStatus(offerId);

      if (mounted && result['success'] == true) {
        _loadOffers();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Statut modifié'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${result['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error toggling status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: const Text(
          'Search offers',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          // SEARCH BAR
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterOffers(),
              decoration: InputDecoration(
                hintText: 'Rechercher une offre...',
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

          // LOADING INDICATOR
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF11224E)),
              ),
            )
          else
            // LIST OF OFFERS
            Expanded(
              child: _filteredOffers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_off,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _allOffers.isEmpty
                                ? 'Aucune offre disponible'
                                : 'Aucun résultat',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Essayez une autre recherche ou catégorie',
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
                      onRefresh: _loadOffers,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        itemCount: _filteredOffers.length,
                        itemBuilder: (context, index) {
                          final offer = _filteredOffers[index];
                          final isOwner = _currentUserId == offer['user_id'];
                          final status = offer['status'] ?? 'available';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OfferDetail(
                                    offerId: offer['id'],
                                    isOwner: isOwner,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
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
                                  // HEADER
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const CircleAvatar(radius: 20),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                offer['user_name'] ?? 'User',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF11224E),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const Text(
                                                'Posted recently',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Status badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: status == 'available'
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          status == 'available'
                                              ? 'Disponible'
                                              : 'Indisponible',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    offer['description'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "Category: ${offer['category_name'] ?? "Unknown"}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF11224E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Color(0xFFFF7A00),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            offer['location'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if (isOwner)
                                            IconButton(
                                              icon: Icon(
                                                status == 'available'
                                                    ? Icons.toggle_on
                                                    : Icons.toggle_off,
                                                color: status == 'available'
                                                    ? Colors.green
                                                    : Colors.grey,
                                                size: 32,
                                              ),
                                              onPressed: () =>
                                                  _toggleOfferStatus(
                                                    offer['id'],
                                                    offer['user_id'],
                                                  ),
                                              tooltip: 'Changer le statut',
                                            ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.message_outlined,
                                            ),
                                            color: const Color(0xFF11224E),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
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
