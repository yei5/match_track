# 🎯 Configuración de Supabase para MatchTrack

## 📋 Pasos para configurar la base de datos

### 1️⃣ Ejecutar el script SQL de migración

1. Ve a tu **dashboard de Supabase**: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. En el menú lateral, navega a **SQL Editor**
4. Haz clic en **"New Query"**
5. Copia el contenido del archivo `supabase_migration_matches.sql`
6. Pégalo en el editor SQL
7. Haz clic en **"Run"** (o presiona Ctrl/Cmd + Enter)

### 2️⃣ Verificar que las tablas se crearon

1. Ve a **Table Editor** en el menú lateral
2. Deberías ver dos nuevas tablas:
   - ✅ `matches` (partidos)
   - ✅ `match_events` (eventos de partidos)

### 3️⃣ Estructura de las tablas

#### Tabla `matches`:
```sql
- id (UUID, PRIMARY KEY)
- home_team_id (UUID, referencia a teams)
- away_team_id (UUID, referencia a teams)
- home_score (INTEGER)
- away_score (INTEGER)
- status (TEXT: idle, scheduled, inProgress, finished)
- current_half (TEXT: firstHalf, halftime, secondHalf, finished)
- elapsed_seconds (INTEGER)
- scheduled_date (TIMESTAMP)
- tournament_id (UUID, referencia a tournaments, opcional)
- user_id (UUID, referencia a auth.users)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

#### Tabla `match_events`:
```sql
- id (UUID, PRIMARY KEY)
- match_id (UUID, referencia a matches)
- type (TEXT: goal, yellowCard, redCard, substitution, injury, foul)
- minute (INTEGER)
- team_id (UUID, referencia a teams)
- player_id (UUID, referencia a players, opcional)
- player2_id (UUID, referencia a players, opcional - para sustituciones)
- details (TEXT, opcional)
- jersey_number (INTEGER)
- jersey_number2 (INTEGER, para sustituciones)
- created_at (TIMESTAMP)
```

### 4️⃣ Políticas de seguridad (RLS)

Las tablas tienen **Row Level Security** habilitado, lo que significa:
- ✅ Cada usuario solo puede ver sus propios partidos
- ✅ Cada usuario solo puede crear partidos para sí mismo
- ✅ Cada usuario solo puede modificar/eliminar sus propios partidos
- ✅ Los eventos de partido heredan la seguridad del partido

### 5️⃣ Probar la aplicación

Ahora puedes ejecutar la app:

```bash
flutter run -d emulator-5554
```

**Lo que funcionará ahora:**
- ✅ Los partidos se guardan en Supabase (persistentes)
- ✅ Los partidos aparecerán aunque cierres y abras la app
- ✅ Los equipos se guardan en Supabase (ya funcionaba)
- ✅ Los torneos se guardan en Supabase (ya funcionaba)
- ✅ Los eventos de partido también se guardan

### 6️⃣ Verificar que funciona

1. Crea un partido nuevo
2. Agrega algunos eventos (goles, tarjetas, etc.)
3. Cierra la aplicación completamente
4. Vuelve a abrir la aplicación
5. Ve a "Mis Partidos"
6. ✅ **Deberías ver el partido que creaste antes**

---

## 🔧 Solución de problemas

### Error: "relation matches does not exist"
- **Causa**: No has ejecutado el script SQL
- **Solución**: Ve al paso 1️⃣ y ejecuta el script

### Error: "permission denied for table matches"
- **Causa**: Las políticas RLS no están configuradas correctamente
- **Solución**: Vuelve a ejecutar el script SQL completo

### Los partidos no aparecen
- **Causa**: Puede que el user_id no coincida
- **Solución**: Verifica en Supabase → Table Editor → matches que existe el campo `user_id` y tiene el ID correcto

### Ver datos en Supabase
1. Ve a **Table Editor**
2. Selecciona la tabla `matches` o `match_events`
3. Verás todos los registros guardados

---

## 📊 Ventajas de usar Supabase

### Antes (solo memoria):
- ❌ Partidos se borraban al cerrar la app
- ❌ No se podían compartir entre dispositivos
- ❌ Sin respaldo de datos

### Ahora (con Supabase):
- ✅ Partidos persisten permanentemente
- ✅ Sincronización automática
- ✅ Respaldo automático en la nube
- ✅ Posibilidad de ver partidos desde cualquier dispositivo
- ✅ Consultas optimizadas con índices
- ✅ Seguridad a nivel de fila (RLS)

---

## 🎉 ¡Listo!

Ahora tu aplicación guarda TODA la información en Supabase:
- 📋 Equipos
- 🏆 Torneos
- ⚽ Partidos
- 📊 Eventos de partidos
