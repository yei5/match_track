-- ============================================
-- SCRIPT DE MIGRACIÓN PARA SUPABASE
-- Tablas: matches y match_events
-- ============================================

-- Crear tabla de partidos (matches)
CREATE TABLE IF NOT EXISTS matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    home_team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    away_team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    home_score INTEGER DEFAULT 0,
    away_score INTEGER DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'idle',
    current_half TEXT NOT NULL DEFAULT 'firstHalf',
    elapsed_seconds INTEGER DEFAULT 0,
    scheduled_date TIMESTAMP WITH TIME ZONE,
    tournament_id UUID REFERENCES tournaments(id) ON DELETE SET NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear tabla de eventos de partido (match_events)
CREATE TABLE IF NOT EXISTS match_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    minute INTEGER NOT NULL,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    player_id UUID REFERENCES players(id) ON DELETE SET NULL,
    player2_id UUID REFERENCES players(id) ON DELETE SET NULL,
    details TEXT,
    jersey_number INTEGER,
    jersey_number2 INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_matches_user_id ON matches(user_id);
CREATE INDEX IF NOT EXISTS idx_matches_status ON matches(status);
CREATE INDEX IF NOT EXISTS idx_matches_tournament_id ON matches(tournament_id);
CREATE INDEX IF NOT EXISTS idx_matches_scheduled_date ON matches(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_match_events_match_id ON match_events(match_id);
CREATE INDEX IF NOT EXISTS idx_match_events_team_id ON match_events(team_id);

-- Habilitar Row Level Security (RLS)
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_events ENABLE ROW LEVEL SECURITY;

-- Políticas de seguridad para matches
CREATE POLICY "Users can view their own matches"
    ON matches FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own matches"
    ON matches FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own matches"
    ON matches FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own matches"
    ON matches FOR DELETE
    USING (auth.uid() = user_id);

-- Políticas de seguridad para match_events
CREATE POLICY "Users can view events of their matches"
    ON match_events FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert events to their matches"
    ON match_events FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update events of their matches"
    ON match_events FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete events of their matches"
    ON match_events FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar updated_at en matches
CREATE TRIGGER update_matches_updated_at
    BEFORE UPDATE ON matches
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- INSTRUCCIONES:
-- ============================================
-- 1. Ve a tu dashboard de Supabase
-- 2. Navega a "SQL Editor"
-- 3. Copia y pega este script completo
-- 4. Ejecuta el script
-- 5. Verifica que las tablas se crearon en "Table Editor"
-- ============================================
