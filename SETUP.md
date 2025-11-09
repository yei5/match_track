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
