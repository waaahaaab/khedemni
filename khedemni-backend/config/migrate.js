const { pool } = require('./database');
const fs = require('fs');
const path = require('path');

async function runMigrations() {
  try {
    const migrationSQL = fs.readFileSync(
      path.join(__dirname, '../migrations/001_initial_schema.sql'), 
      'utf8'
    );
    
    await pool.query(migrationSQL);
    console.log('✅ Database migrations completed successfully');
  } catch (error) {
    console.error('❌ Migration failed:', error);
  } finally {
    pool.end();
  }
}

runMigrations();