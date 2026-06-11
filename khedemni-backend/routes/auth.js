const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const auth = require('../middleware/auth');
const { registerValidation, loginValidation, handleValidationErrors } = require('../middleware/validation');

// ========================================
// PUBLIC ROUTES
// ========================================

// Registration & Login
router.post('/register', registerValidation, handleValidationErrors, authController.register);
router.post('/login', loginValidation, handleValidationErrors, authController.login);

// Password Reset Routes (public)
router.post('/forgot-password', authController.forgotPassword);
router.post('/verify-reset-code', authController.verifyResetCode);
router.post('/reset-password', authController.resetPassword);

// ========================================
// PROTECTED ROUTES (require authentication)
// ========================================

// Profile routes
router.get('/profile', auth, authController.getProfile);
router.put('/profile', auth, authController.uploadProfilePicture, authController.updateProfile);

// Static files
router.use('/uploads', express.static('uploads'));

// Visibility toggle (service seekers only)
router.put('/toggle-visibility', auth, authController.toggleVisibility);

// Get visible service seekers for home
router.get('/visible-service-seekers', authController.getVisibleServiceSeekers);

// Get public profile
router.get('/users/:id/public-profile', authController.getPublicProfile);

module.exports = router;