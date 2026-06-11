const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const offersRoutes = require('./routes/offers');

const app = express();
const PORT = process.env.PORT || 5000;

// ✅ MIDDLEWARE CORS ULTIME - Mets ça APRÈS la déclaration de 'app'
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Accept');
  res.header('Access-Control-Allow-Credentials', 'true');
  
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});
// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ MIDDLEWARE DE LOGGING - Ajoute ça APRÈS le CORS
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  console.log('Body:', req.body);
  next();
});

// ✅ MIDDLEWARE DE DEBUG EXPLICITE
app.use((req, res, next) => {
  console.log('=== NOUVELLE REQUÊTE ===');
  console.log('URL:', req.method, req.url);
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);
  console.log('=======================');
  next();
});


// Routes
app.use('/api/auth', authRoutes);
app.use('/api/offers', offersRoutes);

// Health check route
app.get('/api/health', (req, res) => {
  res.json({ 
    success: true, 
    message: 'Khedemni API is running!',
    timestamp: new Date().toISOString()
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'API route not found'
  });
});

// Error handling middleware
app.use((error, req, res, next) => {
  console.error('Unhandled error:', error);
  res.status(500).json({
    success: false,
    message: 'Internal server error'
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Khedemni server running on port ${PORT}`);
  console.log(`🔗 Accessible via: http://localhost:${PORT}/api/health`);
});
