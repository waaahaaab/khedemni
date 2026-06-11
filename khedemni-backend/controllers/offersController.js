const Offer = require('../models/Offer');

exports.createOffer = async (req, res) => {
  try {
    const { title, description, category_id, location, salary, schedule, status = 'published' } = req.body;

    const offer = await Offer.create({
      title,
      description,
      category_id,
      location,
      salary: salary ? parseFloat(salary) : null,
      schedule,
      user_id: req.user.id,
      status
    });

    res.status(201).json({
      success: true,
      message: status === 'draft' ? 'Draft saved successfully' : 'Offer created successfully',
      data: { offer }
    });
  } catch (error) {
    console.error('Create offer error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error creating offer'
    });
  }
};

exports.getAllOffers = async (req, res) => {
  try {
    const { category_id, limit, status } = req.query;
    const filters = {
      category_id: category_id ? parseInt(category_id) : null,
      limit: limit ? parseInt(limit) : null,
      status,
      current_user_id: req.user?.id || null
    };

    const offers = await Offer.findAll(filters);

    res.json({
      success: true,
      data: { offers },
      count: offers.length
    });
  } catch (error) {
    console.error('Get offers error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching offers'
    });
  }
};

exports.getOffer = async (req, res) => {
  try {
    const { id } = req.params;
    const offer = await Offer.findById(id, req.user?.id);

    if (!offer) {
      return res.status(404).json({
        success: false,
        message: 'Offer not found'
      });
    }

    res.json({
      success: true,
      data: { offer }
    });
  } catch (error) {
    console.error('Get offer error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching offer'
    });
  }
};

exports.updateOffer = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, category_id, location, salary, schedule, status } = req.body;

    // Verify ownership
    const existingOffer = await Offer.findById(id);
    if (!existingOffer) {
      return res.status(404).json({
        success: false,
        message: 'Offer not found'
      });
    }

    if (existingOffer.user_id !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this offer'
      });
    }

    const offer = await Offer.update(id, {
      title,
      description,
      category_id,
      location,
      salary: salary ? parseFloat(salary) : null,
      schedule,
      status
    });

    res.json({
      success: true,
      message: 'Offer updated successfully',
      data: { offer }
    });
  } catch (error) {
    console.error('Update offer error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error updating offer'
    });
  }
};

exports.deleteOffer = async (req, res) => {
  try {
    const { id } = req.params;

    const existingOffer = await Offer.findById(id);
    if (!existingOffer) {
      return res.status(404).json({
        success: false,
        message: 'Offer not found'
      });
    }

    if (existingOffer.user_id !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to delete this offer'
      });
    }

    await Offer.delete(id, req.user.id);

    res.json({
      success: true,
      message: 'Offer deleted successfully'
    });
  } catch (error) {
    console.error('Delete offer error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error deleting offer'
    });
  }
};

exports.getCategories = async (req, res) => {
  try {
    const categories = await Offer.getCategories();
    
    res.json({
      success: true,
      data: { categories }
    });
  } catch (error) {
    console.error('Get categories error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching categories'
    });
  }
};

exports.getUserOffers = async (req, res) => {
  try {
    const { status } = req.query;
    const filters = {
      user_id: req.user.id,
      status,
      current_user_id: req.user.id
    };

    const offers = await Offer.findAll(filters);

    res.json({
      success: true,
      data: { offers }
    });
  } catch (error) {
    console.error('Get user offers error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching user offers'
    });
  }
};

exports.toggleFavorite = async (req, res) => {
  try {
    const { offerId } = req.params;
    const result = await Offer.toggleFavorite(req.user.id, offerId);

    res.json({
      success: true,
      message: result.favorited ? 'Offer added to favorites' : 'Offer removed from favorites',
      data: result
    });
  } catch (error) {
    console.error('Toggle favorite error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error toggling favorite'
    });
  }
};

exports.getFavorites = async (req, res) => {
  try {
    const favorites = await Offer.getUserFavorites(req.user.id);

    res.json({
      success: true,
      data: { favorites }
    });
  } catch (error) {
    console.error('Get favorites error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching favorites'
    });
  }
};
// Toggle offer status (owner only)
exports.toggleOfferStatus = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Get existing offer
    const existingOffer = await Offer.findById(id);
    
    if (!existingOffer) {
      return res.status(404).json({
        success: false,
        message: 'Offer not found'
      });
    }
    
    // Check if user is the owner
    if (existingOffer.user_id !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to change this offer status'
      });
    }
    
    // Toggle status
    const newStatus = existingOffer.status === 'available' ? 'unavailable' : 'available';
    
    const db = require('../config/database');
    await db.query(
      'UPDATE offers SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
      [newStatus, id]
    );
    
    res.json({
      success: true,
      message: `Offer is now ${newStatus}`,
      data: { 
        offer_id: id,
        status: newStatus 
      }
    });
  } catch (error) {
    console.error('Toggle offer status error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error toggling offer status'
    });
  }
};