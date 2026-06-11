-- Ajouter la colonne phone_number
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS phone_number VARCHAR(20);

-- Ajouter un index pour les recherches
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone_number);