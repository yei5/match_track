-- ================================================
-- SCRIPT DE MIGRACIÓN: TABLAS DE PARTIDOS
-- Ejecuta esto UNA SOLA VEZ en el SQL Editor de Supabase
-- Dashboard > SQL Editor > Nuevo Query > Pega esto > Run
-- ================================================

-- 1. Crear tabla de partidos
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

-- 2. Crear tabla de eventos de partido
CREATE TABLE IF NOT EXISTS match_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    minute INTEGER NOT NULL,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    player_id TEXT,
    player2_id TEXT,
    player_name TEXT,
    player2_name TEXT,
    details TEXT,
    jersey_number INTEGER,
    jersey_number2 INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Crear índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_matches_user_id ON matches(user_id);
CREATE INDEX IF NOT EXISTS idx_matches_status ON matches(status);
CREATE INDEX IF NOT EXISTS idx_matches_scheduled_date ON matches(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_match_events_match_id ON match_events(match_id);

-- 4. Habilitar seguridad a nivel de fila
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_events ENABLE ROW LEVEL SECURITY;

-- 5. Políticas para matches
CREATE POLICY "Users can view their own matches" ON matches
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own matches" ON matches
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own matches" ON matches
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own matches" ON matches
    FOR DELETE USING (auth.uid() = user_id);

-- 6. Políticas para match_events
CREATE POLICY "Users can view events of their matches" ON match_events
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can insert events to their matches" ON match_events
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can update events of their matches" ON match_events
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can delete events of their matches" ON match_events
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM matches
            WHERE matches.id = match_events.match_id
            AND matches.user_id = auth.uid()
        )
    );

-- 7. Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_matches_updated_at
    BEFORE UPDATE ON matches
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ================================================
-- ✅ LISTO! Ahora los partidos se guardarán como los equipos
-- ================================================
