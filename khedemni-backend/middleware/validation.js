const { body, validationResult } = require('express-validator');

const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    console.log('❌ Validation errors:', errors.array()); // Pour debug
    return res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors: errors.array()
    });
  }
  next();
};

// Validation rules
const registerValidation = [
  body('name')
    .trim()
    .notEmpty()
    .withMessage('Name is required'),
  
  body('email')
    .trim()
    .isEmail()
    .withMessage('Valid email is required')
    .normalizeEmail(),
  
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters'),
  
  body('username')
    .optional()
    .trim()
    .isLength({ min: 3 })
    .withMessage('Username must be at least 3 characters')
    .matches(/^[a-zA-Z0-9_.]+$/) // ✅ Ajout du point (.) pour accepter "wahab.rsm.mca"
    .withMessage('Username can only contain letters, numbers, underscores, and periods'),
  
  // Champs optionnels
  body('role')
    .optional()
    .isIn(['service_seeker', 'service_provider'])
    .withMessage('Role must be either service_seeker or service_provider'),
  
  body('skills').optional().trim(),
  body('bio').optional().trim()
];

const loginValidation = [
  body('email')
    .trim()
    .isEmail()
    .withMessage('Valid email is required')
    .normalizeEmail(),
  
  body('password')
    .notEmpty()
    .withMessage('Password is required')
];

const offerValidation = [
  body('title')
    .trim()
    .notEmpty()
    .withMessage('Title is required'),
  
  body('description')
    .trim()
    .notEmpty()
    .withMessage('Description is required'),
  
  body('category_id')
    .isInt({ min: 1 })
    .withMessage('Valid category is required'),
  
  body('location')
    .trim()
    .notEmpty()
    .withMessage('Location is required'),
  
  body('salary')
    .optional()
    .isNumeric()
    .withMessage('Salary must be a number'),
  
  body('schedule')
    .optional()
    .isString()
];

module.exports = {
  handleValidationErrors,
  registerValidation,
  loginValidation,
  offerValidation
};