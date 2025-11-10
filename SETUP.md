# Setup Instructions

## Configuración del archivo .env

1. Copia el archivo de ejemplo:
   ```bash
   cp assets/.env.example assets/.env
   ```

   En Windows:
   ```bash
   copy assets\.env.example assets\.env
   ```

2. Edita `assets/.env` con tus credenciales reales de Supabase:
   ```
   SUPABASE_URL=https://tu-proyecto.supabase.co
   SUPABASE_ANON_KEY=tu-clave-anonima-aqui
   ```

3. El archivo `.env` está en `.gitignore` y NO se subirá al repositorio (correcto por seguridad).

## Ejecutar la aplicación

```bash
flutter pub get
flutter run
```

## 📦 Almacenamiento de Eventos

### Actualmente: In-Memory (Temporal)
Los eventos del partido se almacenan **temporalmente en memoria** usando `MatchRepositoryImpl`:
- ✅ Los eventos persisten mientras la app está abierta
- ❌ Se pierden al cerrar la app
- 📍 Ubicación: `lib/features/match/data/repository/match_repository_impl.dart`

### Estado Actual
```dart
// Almacenamiento temporal en memoria
final Map<String, List<MatchEventDetail>> _eventsStore = {};
```

### Próximamente: Supabase (Persistente)
Para almacenamiento permanente, necesitas:

1. **Crear tabla en Supabase:**
```sql
CREATE TABLE match_events (
  id TEXT PRIMARY KEY,
  match_id TEXT NOT NULL,
  type TEXT NOT NULL,
  minute INTEGER NOT NULL,
  team_id TEXT NOT NULL,
  scorer_name TEXT,
  scorer_number TEXT,
  assist_name TEXT,
  assist_number TEXT,
  player_name TEXT,
  player_number TEXT,
  player_out_name TEXT,
  player_out_number TEXT,
  player_in_name TEXT,
  player_in_number TEXT,
  description TEXT,
  timestamp TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (match_id) REFERENCES matches(id)
);
```

2. **Implementar `SupabaseMatchRepository`:**
   - Reemplazar `MatchRepositoryImpl` con implementación de Supabase
   - Usar `supabase.from('match_events').insert()` para guardar
   - Usar `supabase.from('match_events').select()` para cargar

### ¿Dónde se usan los eventos?

1. **`MatchController.addDetailedEvent()`**
   - Guarda evento en repositorio
   - Actualiza marcador si es gol
   - Notifica cambios a la UI

2. **`EventsTimeline` widget**
   - Lee eventos de `controller.sortedEvents`
   - Muestra cronológicamente (más reciente primero)
   - Se actualiza en tiempo real

3. **Flujo de datos:**
```
Botón presionado → Diálogo abierto → Usuario llena datos
       ↓
MatchEventDetail creado
       ↓
controller.addDetailedEvent(event)
       ↓
repository.saveEvent(event, matchId)  ← Aquí se guarda (memoria por ahora)
       ↓
notifyListeners() → UI se actualiza
```
