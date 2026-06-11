import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_offer.dart'; // ✅ AJOUTÉ

class OfferDetail extends StatefulWidget {
  final int offerId;
  final bool isOwner;

  const OfferDetail({super.key, required this.offerId, this.isOwner = false});

  @override
  State<OfferDetail> createState() => _OfferDetailState();
}

class _OfferDetailState extends State<OfferDetail> {
  Map<String, dynamic>? _offerData;
  bool _isLoading = true;
  String _offerStatus = 'available';

  @override
  void initState() {
    super.initState();
    _loadOfferDetails();
  }

  Future<void> _loadOfferDetails() async {
    try {
      final result = await ApiService.getOfferDetails(widget.offerId);

      if (mounted && result['success'] == true) {
        setState(() {
          _offerData = result['data']['offer'];
          _offerStatus = _offerData?['status'] ?? 'available';
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
      debugPrint('Error loading offer: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleOfferStatus() async {
    try {
      final result = await ApiService.toggleOfferStatus(widget.offerId);

      if (mounted && result['success'] == true) {
        setState(() {
          _offerStatus = result['data']['status'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Statut modifié'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: ${result['message']}')),
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
        title: const Text('Détails de l\'offre'),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (widget.isOwner && !_isLoading)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditOffer(
                      offerId: widget.offerId,
                      offerData: _offerData!,
                    ),
                  ),
                );

                if (result == true) {
                  _loadOfferDetails(); // Recharger les détails
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _offerData == null
          ? const Center(child: Text('Offre introuvable'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge (visible par tous, modifiable par owner)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _offerStatus == 'available'
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _offerStatus == 'available'
                              ? 'Disponible'
                              : 'Indisponible',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (widget.isOwner)
                        ElevatedButton.icon(
                          onPressed: _toggleOfferStatus,
                          icon: const Icon(Icons.swap_horiz, size: 18),
                          label: const Text('Changer statut'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7A00),
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _offerData?['user_name'] ?? 'User',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Publié ${_formatDate(_offerData?['created_at'])}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Title
                  const Text(
                    'Titre',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _offerData?['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _offerData?['description'] ?? '',
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 20),

                  // Details cards
                  _buildInfoCard(
                    'Catégorie',
                    _offerData?['category_name'] ?? 'Non spécifié',
                    Icons.category,
                  ),
                  _buildInfoCard(
                    'Localisation',
                    _offerData?['location'] ?? 'Non spécifié',
                    Icons.location_on,
                  ),
                  if (_offerData?['salary'] != null)
                    _buildInfoCard(
                      'Salaire',
                      '${_offerData?['salary']} DA',
                      Icons.attach_money,
                    ),
                  if (_offerData?['schedule'] != null)
                    _buildInfoCard(
                      'Horaire',
                      _offerData?['schedule'],
                      Icons.schedule,
                    ),

                  // ✅ TÉLÉPHONE DU PROPRIÉTAIRE
                  if (_offerData?['user_phone'] != null &&
                      (_offerData!['user_phone'].toString().isNotEmpty))
                    _buildInfoCard(
                      'Contact',
                      _offerData!['user_phone'],
                      Icons.phone,
                    ),

                  const SizedBox(height: 30),

                  // Contact button
                  if (!widget.isOwner)
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
                          'Contacter',
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

  Widget _buildInfoCard(String label, String value, IconData icon) {
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
          Icon(icon, color: const Color(0xFFFF7A00)),
          const SizedBox(width: 12),
          Column(
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
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'récemment';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) return 'aujourd\'hui';
      if (diff.inDays == 1) return 'hier';
      if (diff.inDays < 7) return 'il y a ${diff.inDays} jours';
      return 'le ${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'récemment';
    }
  }
}
