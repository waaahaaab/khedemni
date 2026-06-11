const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const User = require('../models/User');
const db = require('../config/database');
const { sendResetCode } = require('../services/emailService');

// Fonction pour générer un code à 6 chiffres
const generateResetCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

// 1️⃣ Demander un code de réinitialisation
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    // Vérifier si l'utilisateur existe
    const user = await User.findByEmail(email);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Aucun compte associé à cet email'
      });
    }

    // Générer un code à 6 chiffres
    const resetCode = generateResetCode();
    
    // Calculer la date d'expiration (15 minutes)
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000);

    // Supprimer les anciens codes non utilisés de cet utilisateur
    await db.query(
      'DELETE FROM password_resets WHERE user_id = $1 AND used = false',
      [user.id]
    );

    // Enregistrer le nouveau code
    await db.query(
      `INSERT INTO password_resets (user_id, reset_code, expires_at)
       VALUES ($1, $2, $3)`,
      [user.id, resetCode, expiresAt]
    );

    // Envoyer l'email
    const emailResult = await sendResetCode(email, resetCode, user.name);

    if (!emailResult.success) {
      return res.status(500).json({
        success: false,
        message: 'Erreur lors de l\'envoi de l\'email'
      });
    }

    res.json({
      success: true,
      message: 'Un code de vérification a été envoyé à votre email'
    });
  } catch (error) {
    console.error('Forgot password error:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur serveur lors de la demande de réinitialisation'
    });
  }
};

// 2️⃣ Vérifier le code de réinitialisation
exports.verifyResetCode = async (req, res) => {
  try {
    const { email, code } = req.body;

    // Trouver l'utilisateur
    const user = await User.findByEmail(email);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Utilisateur introuvable'
      });
    }

    // Vérifier le code
    const result = await db.query(
      `SELECT * FROM password_resets 
       WHERE user_id = $1 AND reset_code = $2 AND used = false
       ORDER BY created_at DESC LIMIT 1`,
      [user.id, code]
    );

    if (result.rows.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Code invalide ou déjà utilisé'
      });
    }

    const resetRecord = result.rows[0];

    // Vérifier si le code a expiré
    if (new Date() > new Date(resetRecord.expires_at)) {
      return res.status(400).json({
        success: false,
        message: 'Ce code a expiré. Demandez un nouveau code.'
      });
    }

    res.json({
      success: true,
      message: 'Code vérifié avec succès'
    });
  } catch (error) {
    console.error('Verify code error:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur serveur lors de la vérification'
    });
  }
};

// 3️⃣ Réinitialiser le mot de passe
exports.resetPassword = async (req, res) => {
  try {
    const { email, code, newPassword } = req.body;

    // Trouver l'utilisateur
    const user = await User.findByEmail(email);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Utilisateur introuvable'
      });
    }

    // Vérifier le code à nouveau
    const result = await db.query(
      `SELECT * FROM password_resets 
       WHERE user_id = $1 AND reset_code = $2 AND used = false
       ORDER BY created_at DESC LIMIT 1`,
      [user.id, code]
    );

    if (result.rows.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Code invalide ou déjà utilisé'
      });
    }

    const resetRecord = result.rows[0];

    // Vérifier l'expiration
    if (new Date() > new Date(resetRecord.expires_at)) {
      return res.status(400).json({
        success: false,
        message: 'Ce code a expiré'
      });
    }

    // Hasher le nouveau mot de passe
    const bcrypt = require('bcryptjs');
    const hashedPassword = await bcrypt.hash(newPassword, 12);

    // Mettre à jour le mot de passe
    await db.query(
      'UPDATE users SET password = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
      [hashedPassword, user.id]
    );

    // Marquer le code comme utilisé
    await db.query(
      'UPDATE password_resets SET used = true WHERE id = $1',
      [resetRecord.id]
    );

    res.json({
      success: true,
      message: 'Mot de passe réinitialisé avec succès'
    });
  } catch (error) {
    console.error('Reset password error:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur serveur lors de la réinitialisation'
    });
  }
};

// Configuration Multer pour le stockage des images
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/profile-pictures/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'profile-' + req.user.id + '-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB max
  },
  fileFilter: function (req, file, cb) {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed!'), false);
    }
  }
});

// Middleware pour upload de photo
exports.uploadProfilePicture = upload.single('profile_picture');

const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN
  });
};

exports.register = async (req, res) => {
  console.log('Register request body:', req.body);
  try {
    const { name, email, password, username, role, skills, bio } = req.body;

    // Check if user already exists
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'User already exists with this email'
      });
    }

    // Create new user
    const user = await User.create({
      name,
      email,
      password,
      username: username || email.split('@')[0],
      role: role || 'service_seeker',
      skills,
      bio
    });

    const token = generateToken(user.id);

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      data: {
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          username: user.username,
          role: user.role,
          skills: user.skills,
          bio: user.bio
        },
        token
      }
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during registration'
    });
  }
};

exports.login = async (req, res) => {
  console.log('Login request body:', req.body);
  try {
    const { email, password } = req.body;

    // Check if user exists
    const user = await User.findByEmail(email);
    if (!user) {
      return res.status(400).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Check password
    const isMatch = await User.comparePassword(password, user.password);
    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    const token = generateToken(user.id);

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          username: user.username,
          role: user.role,
          skills: user.skills,
          bio: user.bio,
          profile_image: user.profile_image
        },
        token
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during login'
    });
  }
};

exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    
    res.json({
      success: true,
      data: { user }
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching profile'
    });
  }
};

exports.updateProfile = async (req, res) => {
  try {
    // ✅ Ajoutez phone_number ici
    const { name, skills, bio, role, category, wilaya, phone_number } = req.body;
    
    console.log('📝 Update Profile - Body reçu:', req.body);
    
    const currentUser = await User.findById(req.user.id);
    
    if (!currentUser) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    const updateData = {
      name: name || currentUser.name,
      username: currentUser.username,
      skills: skills || currentUser.skills,
      bio: bio || currentUser.bio,
      role: role || currentUser.role,
      category: category || currentUser.category,
      wilaya: wilaya || currentUser.wilaya,
      phone_number: phone_number || currentUser.phone_number, // ✅ AJOUTÉ
      profile_image: currentUser.profile_image
    };

    if (req.file) {
      updateData.profile_image = `/uploads/profile-pictures/${req.file.filename}`;
    }

    const updatedUser = await User.updateProfile(req.user.id, updateData);

    res.json({
      success: true,
      message: 'Profile updated successfully',
      data: { user: updatedUser }
    });
  } catch (error) {
    console.error('❌ Update profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error updating profile',
      error: error.message
    });
  }
};
  // Toggle visibility on home page (service_seekers only)
exports.toggleVisibility = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    // Only service_seekers can be visible on home
    if (user.role !== 'service_seeker') {
      return res.status(403).json({
        success: false,
        message: 'Only service seekers can toggle visibility on home page'
      });
    }

    const newVisibility = !user.visible_on_home;
    
    await db.query(
      'UPDATE users SET visible_on_home = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2',
      [newVisibility, req.user.id]
    );

    res.json({
      success: true,
      message: newVisibility ? 'You are now visible on home page' : 'You are now hidden from home page',
      data: { visible_on_home: newVisibility }
    });
  } catch (error) {
    console.error('Toggle visibility error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error toggling visibility'
    });
  }
};

// Get visible service seekers for home page
exports.getVisibleServiceSeekers = async (req, res) => {
  try {
    const { limit = 20, wilaya } = req.query;
    
    let query = `
      SELECT id, name, username, email, bio, skills, category, wilaya, profile_image, created_at
      FROM users 
      WHERE visible_on_home = true AND role = 'service_seeker'
    `;
    
    const params = [];
    
    if (wilaya) {
      params.push(wilaya);
      query += ` AND wilaya = $${params.length}`;
    }
    
    query += ` ORDER BY created_at DESC LIMIT $${params.length + 1}`;
    params.push(parseInt(limit));
    
    const result = await db.query(query, params);
    
    res.json({
      success: true,
      data: { users: result.rows },
      count: result.rows.length
    });
  } catch (error) {
    console.error('Get visible service seekers error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching service seekers'
    });
  }
};

// Get public profile of a user
exports.getPublicProfile = async (req, res) => {
  try {
    const { id } = req.params;
    
    const query = `
      SELECT id, name, username, email, bio, skills, category, wilaya, 
             profile_image, phone_number, role, created_at
      FROM users 
      WHERE id = $1
    `;
    
    const result = await db.query(query, [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }
    
    res.json({
      success: true,
      data: { user: result.rows[0] }
    });
  } catch (error) {
    console.error('Get public profile error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error fetching user profile'
    });
  }
};
