# ⚠️ CONFIGURACIÓN URGENTE REQUERIDA

## 🚨 Error actual:
```
PostgresException: could not find the 'away_score' column of 'matches'
```

## ✅ SOLUCIÓN RÁPIDA (5 minutos):

### Paso 1: Abrir Supabase
1. Ve a: https://supabase.com/dashboard
2. Inicia sesión
3. Selecciona tu proyecto **match_track**

### Paso 2: Crear las tablas
1. En el menú lateral izquierdo, haz clic en **"SQL Editor"**
2. Haz clic en **"New Query"**
3. **Copia TODO** el contenido del archivo `supabase_migration_matches.sql`
4. **Pégalo** en el editor
5. Haz clic en el botón **"RUN"** (▶️) o presiona `Ctrl+Enter`

### Paso 3: Verificar
1. Ve a **"Table Editor"** en el menú lateral
2. Busca la tabla **"matches"**
3. ✅ Si la ves, ¡listo!

---

## 📋 Script SQL completo a ejecutar:

```sql
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
    player_id TEXT,
    player2_id TEXT,
    player_name TEXT,
    player2_name TEXT,
    details TEXT,
    jersey_number INTEGER,
    jersey_number2 INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índices
CREATE INDEX IF NOT EXISTS idx_matches_user_id ON matches(user_id);
CREATE INDEX IF NOT EXISTS idx_matches_status ON matches(status);
CREATE INDEX IF NOT EXISTS idx_matches_scheduled_date ON matches(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_match_events_match_id ON match_events(match_id);

-- Habilitar Row Level Security
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

-- Trigger para updated_at
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
```

---

## 🎯 Después de ejecutar el script:

1. Vuelve a la app
2. Intenta agendar un partido
3. ✅ Debería funcionar sin errores

---

## 💡 ¿Por qué este error?

La app está intentando guardar partidos en Supabase, pero la tabla `matches` no existe todavía. El script SQL la crea con todas las columnas necesarias.

**Sin el script**: Los partidos no se pueden guardar
**Con el script**: ✅ Todo funciona perfecto
