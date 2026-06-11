const db = require('../config/database');

class Offer {
  static async create(offerData) {
    const { title, description, category_id, location, salary, schedule, user_id, status = 'published' } = offerData;
    
    const query = `
      INSERT INTO offers (title, description, category_id, location, salary, schedule, user_id, status)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *
    `;
    
    const result = await db.query(query, [
      title, description, category_id, location, salary, schedule, user_id, status
    ]);
    
    return result.rows[0];
  }

  static async findAll(filters = {}) {
    let query = `
      SELECT 
        o.*,
        u.name as user_name,
        u.username,
        u.profile_image,
        c.name as category_name,
        EXISTS(
          SELECT 1 FROM favorites f 
          WHERE f.offer_id = o.id AND f.user_id = $1
        ) as is_favorited
      FROM offers o
      LEFT JOIN users u ON o.user_id = u.id
      LEFT JOIN categories c ON o.category_id = c.id
      WHERE o.is_active = true
    `;
    
    const params = [filters.current_user_id || null];
    let paramCount = 2;

    if (filters.category_id) {
      query += ` AND o.category_id = $${paramCount}`;
      params.push(filters.category_id);
      paramCount++;
    }

    if (filters.status) {
      query += ` AND o.status = $${paramCount}`;
      params.push(filters.status);
      paramCount++;
    }

    if (filters.user_id) {
      query += ` AND o.user_id = $${paramCount}`;
      params.push(filters.user_id);
      paramCount++;
    }

    query += ` ORDER BY o.created_at DESC`;
    
    if (filters.limit) {
      query += ` LIMIT $${paramCount}`;
      params.push(filters.limit);
    }

    const result = await db.query(query, params);
    return result.rows;
  }

 static async findById(id, userId = null) {
  const query = `
    SELECT 
      o.*,
      u.name as user_name,
      u.username,
      u.profile_image,
      u.skills as user_skills,
      u.bio as user_bio,
      u.phone_number as user_phone,
      c.name as category_name,
      EXISTS(
        SELECT 1 FROM favorites f 
        WHERE f.offer_id = o.id AND f.user_id = $2
      ) as is_favorited
    FROM offers o
    LEFT JOIN users u ON o.user_id = u.id
    LEFT JOIN categories c ON o.category_id = c.id
    WHERE o.id = $1 AND o.is_active = true
  `;
  
  const result = await db.query(query, [id, userId]);
  return result.rows[0];
}
  static async update(id, updateData) {
    const { title, description, category_id, location, salary, schedule, status } = updateData;
    
    const query = `
      UPDATE offers 
      SET title = $1, description = $2, category_id = $3, location = $4, 
          salary = $5, schedule = $6, status = $7, updated_at = CURRENT_TIMESTAMP
      WHERE id = $8
      RETURNING *
    `;
    
    const result = await db.query(query, [
      title, description, category_id, location, salary, schedule, status, id
    ]);
    
    return result.rows[0];
  }

  static async delete(id, userId) {
    const query = 'UPDATE offers SET is_active = false WHERE id = $1 AND user_id = $2 RETURNING *';
    const result = await db.query(query, [id, userId]);
    return result.rows[0];
  }

  static async getCategories() {
    const query = 'SELECT * FROM categories ORDER BY name';
    const result = await db.query(query);
    return result.rows;
  }

  static async toggleFavorite(userId, offerId) {
    // Check if already favorited
    const checkQuery = 'SELECT * FROM favorites WHERE user_id = $1 AND offer_id = $2';
    const checkResult = await db.query(checkQuery, [userId, offerId]);
    
    if (checkResult.rows.length > 0) {
      // Remove favorite
      const deleteQuery = 'DELETE FROM favorites WHERE user_id = $1 AND offer_id = $2 RETURNING *';
      await db.query(deleteQuery, [userId, offerId]);
      return { favorited: false };
    } else {
      // Add favorite
      const insertQuery = 'INSERT INTO favorites (user_id, offer_id) VALUES ($1, $2) RETURNING *';
      await db.query(insertQuery, [userId, offerId]);
      return { favorited: true };
    }
  }

  static async getUserFavorites(userId) {
    const query = `
      SELECT 
        o.*,
        u.name as user_name,
        u.username,
        u.profile_image,
        c.name as category_name
      FROM favorites f
      JOIN offers o ON f.offer_id = o.id
      LEFT JOIN users u ON o.user_id = u.id
      LEFT JOIN categories c ON o.category_id = c.id
      WHERE f.user_id = $1 AND o.is_active = true
      ORDER BY f.created_at DESC
    `;
    
    const result = await db.query(query, [userId]);
    return result.rows;
  }
}

module.exports = Offer;