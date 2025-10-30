# Match Track

Una aplicación Flutter para el seguimiento y gestión de datos deportivos, con un enfoque actual en el sistema de autenticación y recuperación de contraseña.

## 🚀 Estado Actual del Proyecto

### Características Principales Implementadas

#### Sistema de Autenticación
- Integración con Supabase para autenticación
- Pantalla de inicio de sesión funcional
- Flujo de restablecimiento de contraseña en desarrollo
- Implementación de `SupabaseAuthRemote` para endpoints de autenticación

#### Arquitectura
- Estructura organizada por features
- Patrón Clean Architecture
- Sistema de inyección de dependencias para pruebas

### Estructura del Proyecto

```
match_track/
├── lib/
│   ├── core/
│   │   └── domain/
│   ├── features/
│   │   ├── auth/
│   │   └── profile/
│   └── main.dart
├── test/
└── [Configuración multiplataforma]
```

## 💻 Ejecutar la Demo de "Reestablecer contraseña"

### Requisitos
- Codespaces o VS Code Remote - Containers
- Puerto 8080 disponible para el servidor web

### Pasos de Ejecución

1. **Preparar el Entorno**
   ```bash
   # Si Flutter no está instalado
   ./scripts/install_flutter_local.sh
   ```

2. **Ejecutar la Demo**
   ```bash
   ./scripts/start_demo.sh
   ```

3. **Acceder a la Aplicación**
   - En Codespaces: Abrir el puerto forwardeado (8080)
   - Local: Acceder a `http://localhost:8080`

## 🛠 Configuración Técnica

### Variables de Entorno
- Archivo `.env` requerido con:
  ```
  SUPABASE_URL=your_supabase_url
  SUPABASE_ANON_KEY=your_supabase_anon_key
  ```

### Dependencias Principales
```yaml
dependencies:
  flutter_dotenv: ^6.0.0
  http: ^1.5.0
  supabase_flutter: ^2.10.3
```

### Estructura de Autenticación
- `lib/features/auth/data/source/supabase_auth_remote.dart`: Wrapper REST para endpoints de Supabase
- `lib/features/auth/auth_scope.dart`: Configuración y DI
- `lib/features/auth/ui/screens/`: Pantallas de UI

## 🔧 Solución de Problemas

### Problemas Conocidos
- Error con variables de Supabase en compilación web
- Dependencia de glibc en contenedores Alpine

### Fixes y Workarounds
1. **Entorno Alpine**
   - Reconstruir contenedor con Ubuntu 22.04
   - O instalar `gcompat` para compatibilidad glibc

2. **Variables de Entorno**
   - Usar `.env`
   - O pasar variables via `--dart-define`

## 👥 Contribución

1. Fork el proyecto
2. Crea rama de feature
3. Commit cambios
4. Push a la rama
5. Crear Pull Request

## ✍️ Autor

- **Juan Sebastián Giraldo** - [@yei5](https://github.com/yei5)

## 📚 Recursos

- [Documentación Flutter](https://docs.flutter.dev/)
- [Supabase Auth](https://supabase.com/docs/guides/auth)
- [Clean Architecture en Flutter](https://docs.flutter.dev/resources/architectural-overview)

---

⌨️ con ❤️ por [yei5](https://github.com/yei5)

```bash
sudo apk add --no-cache gcompat bash ca-certificates curl unzip xz libstdc++ libgcc openssl
```

This worked in the preparation environment but is not as stable as using Ubuntu; widget testing with the Flutter test runner can still be unstable under Alpine.

## What I changed in the codebase

- `lib/main.dart`: fixed duplicated constructors, made `authController` optional for easier testing and removed syntax errors.
- `test/*`: adapted tests to provide minimal fakes and be deterministic. Unit tests that mock the Supabase remote pass.
- `.devcontainer/Dockerfile`, `scripts/install_flutter_local.sh`, `scripts/start_demo.sh`: improved stability and error messages.

## Next steps I can take for you

- Rebuild the devcontainer from here and run `flutter doctor`, `flutter test` and `flutter run` (requires Docker availability in your environment). I can execute rebuild commands if you confirm Docker is available and you want me to do so.
- Add automated CI (GitHub Actions) to run `flutter analyze` and `flutter test` on push/PR.
- Add an integration test or a Puppeteer/Cypress script to exercise the web UI for the password reset flow.

If you want, ahora continuo con: (A) intentar reconstruir y ejecutar todo en este entorno (si me das permiso para usar Docker en el runner), o (B) te guío paso a paso para hacerlo en Codespaces (recomendado).
