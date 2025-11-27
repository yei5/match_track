# 🚀 CONFIGURACIÓN ÚNICA DE PARTIDOS EN SUPABASE

## ¿Por qué esto?
Los equipos y torneos ya funcionan porque sus tablas YA EXISTEN en Supabase. Para que los partidos funcionen igual, necesitas ejecutar un script SQL **una sola vez**.

## Pasos (5 minutos):

### 1️⃣ Abre tu Dashboard de Supabase
- Ve a: https://supabase.com/dashboard
- Entra a tu proyecto

### 2️⃣ Abre el SQL Editor
- En el menú izquierdo, haz clic en **SQL Editor**
- Haz clic en **"+ New query"**

### 3️⃣ Copia el script
- Abre el archivo `EJECUTAR_EN_SUPABASE.sql` de este proyecto
- Copia TODO su contenido
- Pégalo en el SQL Editor

### 4️⃣ Ejecuta
- Haz clic en **"Run"** (esquina inferior derecha)
- Verás el mensaje: "Success. No rows returned"

### 5️⃣ ¡Listo!
- Cierra el navegador
- Vuelve a la app
- Los partidos ahora se guardarán automáticamente

## ¿Qué hace el script?
- ✅ Crea la tabla `matches` (partidos)
- ✅ Crea la tabla `match_events` (eventos: goles, tarjetas, etc.)
- ✅ Configura seguridad (solo ves tus partidos)
- ✅ Optimiza con índices
- ✅ Actualiza fechas automáticamente

## ¿Es seguro?
Sí, el script usa `IF NOT EXISTS`, así que:
- No duplica tablas si ya existen
- No afecta tus datos actuales
- Es idempotente (puedes ejecutarlo varias veces sin problema)

## Después de ejecutar:
La app funcionará exactamente como con equipos y torneos:
- ✅ Agendar partido → Se guarda
- ✅ Cerrar app → Datos persisten
- ✅ Reabrir app → Partidos aparecen
- ✅ Eventos (goles, etc.) → Se guardan también

---

**Nota:** Esto es lo mismo que se hizo con `teams` y `tournaments`. Es la forma estándar de Supabase. No se pueden crear tablas desde Flutter por seguridad.
