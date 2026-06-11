-- Ajouter la colonne visible_on_home pour les utilisateurs
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS visible_on_home BOOLEAN DEFAULT false;

-- Ajouter un index pour les recherches
CREATE INDEX IF NOT EXISTS idx_users_visible_on_home ON users(visible_on_home) WHERE visible_on_home = true;

-- Modifier la colonne status des offres pour utiliser 'available'/'unavailable'
ALTER TABLE offers 
ALTER COLUMN status SET DEFAULT 'available';

-- Mettre à jour les offres existantes
UPDATE offers SET status = 'available' WHERE status = 'published' OR status IS NULL;

-- Ajouter un commentaire pour clarifier les valeurs possibles
COMMENT ON COLUMN offers.status IS 'available, unavailable';

-- Ajouter un index pour les recherches de statut
CREATE INDEX IF NOT EXISTS idx_offers_status_active ON offers(status) WHERE status = 'available';