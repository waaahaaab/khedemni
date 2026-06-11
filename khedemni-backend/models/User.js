const db = require('../config/database');
const bcrypt = require('bcryptjs');

class User {
  static async create(userData) {
    const { name, email, password, username, role, skills, bio } = userData;
    
    const hashedPassword = await bcrypt.hash(password, 12);
    
    const query = `
      INSERT INTO users (name, email, password, username, role, skills, bio)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id, name, email, username, role, skills, bio, created_at
    `;
    
    const result = await db.query(query, [
      name, email, hashedPassword, username, role, skills, bio
    ]);
    
    return result.rows[0];
  }

  // Remplacez la méthode findByEmail dans User.js :

  static async findByEmail(email) {
  // Normaliser l'email : trim + lowercase
  const normalizedEmail = email.trim().toLowerCase();
  
  const query = 'SELECT * FROM users WHERE LOWER(TRIM(email)) = $1';
  const result = await db.query(query, [normalizedEmail]);
  return result.rows[0];
  }

  static async findById(id) {
  const query = `
    SELECT id, name, email, username, role, skills, bio, 
           profile_image, category, wilaya, created_at
    FROM users WHERE id = $1
  `;
  const result = await db.query(query, [id]);
  return result.rows[0];
  }  

static async updateProfile(id, updateData) {
  const { name, username, skills, bio, profile_image, role, category, wilaya, phone_number } = updateData;
  
  const query = `
    UPDATE users 
    SET name = $1, 
        username = $2, 
        skills = $3, 
        bio = $4, 
        profile_image = $5, 
        role = $6, 
        category = $7, 
        wilaya = $8,
        phone_number = $9,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = $10
    RETURNING id, name, email, username, role, skills, bio, 
              profile_image, category, wilaya, phone_number, created_at
  `;
  
  const result = await db.query(query, [
    name, 
    username, 
    skills, 
    bio, 
    profile_image, 
    role, 
    category, 
    wilaya, 
    phone_number,
    id
  ]);
  
  return result.rows[0];
}

static async findById(id) {
  const query = `
    SELECT id, name, email, username, role, skills, bio, 
           profile_image, category, wilaya, phone_number, 
           visible_on_home, created_at
    FROM users WHERE id = $1
  `;
  const result = await db.query(query, [id]);
  return result.rows[0];
}

  static async comparePassword(candidatePassword, hashedPassword) {
    return await bcrypt.compare(candidatePassword, hashedPassword);
  }
}

module.exports = User;