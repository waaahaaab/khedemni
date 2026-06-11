const express = require('express');
const router = express.Router();
const offersController = require('../controllers/offersController');
const auth = require('../middleware/auth');
const { offerValidation, handleValidationErrors } = require('../middleware/validation');

// Public routes
router.get('/', offersController.getAllOffers);
router.get('/categories', offersController.getCategories);
router.get('/:id', offersController.getOffer);

// Protected routes
router.post('/', auth, offerValidation, handleValidationErrors, offersController.createOffer);
router.put('/:id', auth, offerValidation, handleValidationErrors, offersController.updateOffer);
router.delete('/:id', auth, offersController.deleteOffer);
router.get('/user/my-offers', auth, offersController.getUserOffers);
router.post('/:offerId/favorite', auth, offersController.toggleFavorite);
router.get('/user/favorites', auth, offersController.getFavorites);
// Toggle offer status (owner only)
router.put('/:id/status', auth, offersController.toggleOfferStatus);

module.exports = router;