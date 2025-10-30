# Match Track

Una aplicación Flutter que implementa una arquitectura moderna y robusta para el seguimiento de datos deportivos, con un enfoque actual en un sistema de autenticación avanzado basado en Supabase.

## 📋 Descripción Técnica del Proyecto

### Arquitectura e Implementación

El proyecto implementa Clean Architecture con una clara separación de responsabilidades:

#### 1. Capa de Dominio (`lib/core/domain`)
- Definición de entidades core
- Casos de uso abstractos
- Interfaces de repositorios

#### 2. Capa de Datos (`lib/features/*/data`)
- **Repositories**: Implementación de la lógica de negocio
  ```dart
  abstract class AuthRepository {
    Future<void> sendPasswordResetEmail(String email);
    Future<String> signIn(String email, String password);
  }
  ```
- **Data Sources**: 
  - `SupabaseAuthRemote`: Implementación ligera de cliente REST para Supabase
  - Manejo de autenticación mediante endpoints `/auth/v1/*`
  - Gestión de tokens y estados de autenticación

#### 3. Capa de Presentación (`lib/features/*/ui`)
- **Controllers**: Gestión de estado y lógica de UI
  ```dart
  class AuthController extends ChangeNotifier {
    final AuthRepository repository;
    AuthState _state = AuthState.idle;
    // ... métodos y gestión de estado
  }
  ```
- **Screens**: 
  - `LoginScreen`: Implementación de UI para autenticación
  - `ResetPasswordRequestScreen`: Flujo de recuperación de contraseña

#### Arquitectura
- Estructura organizada por features
- Patrón Clean Architecture
- Sistema de inyección de dependencias para pruebas

## 🏗 Estructura del Proyecto y Patrones de Diseño

### Arquitectura de Carpetas
```
match_track/
├── lib/
│   ├── core/                 # Lógica central y utilidades
│   │   └── domain/          # Definiciones base y contratos
│   ├── features/            # Módulos funcionales
│   │   ├── auth/           # Feature de autenticación
│   │   │   ├── data/      # Implementación de repositorios
│   │   │   │   ├── repository/
│   │   │   │   └── source/
│   │   │   └── ui/        # Componentes de interfaz
│   │   │       ├── bloc/
│   │   │       └── screens/
│   │   └── profile/       # Feature de perfil (en desarrollo)
│   └── main.dart          # Punto de entrada de la aplicación
└── test/                  # Suite de pruebas
    └── widget_test.dart   # Pruebas de widgets

### Patrones de Diseño Implementados

1. **Repository Pattern**
   - Abstracción de fuentes de datos
   - Separación clara entre datos y lógica de negocio
   - Facilita testing y cambios de implementación

2. **Dependency Injection**
   - Inyección de dependencias manual
   - Facilita testing y modularidad
   - Configuración en `auth_scope.dart`

3. **Observer Pattern**
   - Implementado via `ChangeNotifier`
   - Actualización reactiva de UI
   - Gestión eficiente de estado

## 🔧 Configuración Técnica y Dependencias

### Requisitos del Sistema
- Flutter SDK ^3.9.2
- Dart SDK latest
- VS Code con extensiones Flutter/Dart
- Codespaces o contenedor Docker (recomendado)

### Dependencias Core
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_dotenv: ^6.0.0    # Gestión de variables de entorno
  http: ^1.5.0             # Cliente HTTP para API REST
  supabase_flutter: ^2.10.3 # Cliente Supabase oficial
```

### Configuración del Entorno de Desarrollo

1. **Configuración del Contenedor**
   ```bash
   # Reconstruir contenedor para ambiente óptimo
   cd .devcontainer
   docker build -t match_track_dev .
   ```

2. **Instalación de Flutter (si es necesario)**
   ```bash
   ./scripts/install_flutter_local.sh
   flutter --version
   flutter doctor
   ```

3. **Configuración de Variables de Entorno**
   ```bash
   # Crear .env en la raíz del proyecto
   echo "SUPABASE_URL=your_url
   SUPABASE_ANON_KEY=your_key" > .env
   ```

### Integración con Supabase

La aplicación utiliza Supabase como backend, específicamente:

1. **Endpoints de Autenticación**
   ```dart
   // Ejemplo de implementación en SupabaseAuthRemote
   class SupabaseAuthRemote {
     final String supabaseUrl;
     final String anonKey;

     Future<void> sendPasswordResetEmail(String email) async {
       // Implementación de recuperación de contraseña
     }

     Future<String> signIn(String email, String password) async {
       // Implementación de autenticación
     }
   }
   ```

## 🔐 Sistema de Autenticación

### Flujo de Autenticación

1. **Inicio de Sesión**
   ```dart
   Future<bool> signIn(String email, String password) async {
     // 1. Validación de credenciales
     // 2. Petición a Supabase
     // 3. Gestión de token y estado
   }
   ```

2. **Recuperación de Contraseña**
   ```dart
   Future<void> sendPasswordResetEmail(String email) async {
     // 1. Validación de email
     // 2. Petición a endpoint de recuperación
     // 3. Gestión de respuesta
   }
   ```

### Gestión de Estado

```dart
enum AuthState { idle, loading, success, error }

class AuthController extends ChangeNotifier {
  AuthState _state = AuthState.idle;
  String? _errorMessage;

  // Métodos para gestión de estado y notificaciones
}
```

### Seguridad y Validación

1. **Endpoints Protegidos**
   - Uso de tokens JWT
   - Validación en headers de peticiones
   - Renovación automática de tokens

2. **Validación de Datos**
   - Sanitización de inputs
   - Validación de formato de email
   - Manejo seguro de contraseñas

## 🧪 Testing y Calidad de Código

### Estructura de Tests

1. **Tests Unitarios**
   ```dart
   void main() {
     group('AuthController', () {
       test('sendResetEmail success updates state', () async {
         // Setup
         final controller = AuthController(
           repository: MockAuthRepository(),
         );
         
         // Act & Assert
         await controller.sendResetEmail('test@example.com');
         expect(controller.state, equals(AuthState.success));
       });
     });
   }
   ```

2. **Tests de Widget**
   - Pruebas de integración de UI
   - Validación de flujos completos
   - Mocking de dependencias

3. **Tests de Integración**
   - Validación con Supabase
   - Pruebas de flujos completos
   - Verificación de seguridad

### CI/CD y Calidad

1. **Análisis Estático**
   ```bash
   flutter analyze
   dart format .
   ```

2. **Linting**
   ```yaml
   # analysis_options.yaml
   include: package:flutter_lints/flutter.yaml
   analyzer:
     exclude:
       - "**/*.g.dart"
     strong-mode:
       implicit-casts: false
   ```

## 🔧 Troubleshooting y Consideraciones

### Problemas Conocidos y Soluciones

1. **Entorno de Desarrollo**
   - Error: `flutter: command not found`
   - Solución: Ejecutar `./scripts/install_flutter_local.sh`

2. **Contenedor Alpine**
   - Error: Problemas con glibc
   - Solución: Reconstruir en Ubuntu 22.04 o usar `gcompat`

3. **Variables de Entorno**
   - Error: Variables no disponibles en web
   - Solución: Usar `--dart-define` en compilación

## 📦 Build y Deployment

### Proceso de Build

1. **Web**
   ```bash
   flutter build web --release --dart-define=SUPABASE_URL=url --dart-define=SUPABASE_ANON_KEY=key
   ```

2. **Android**
   ```bash
   flutter build apk --release
   ```

3. **iOS**
   ```bash
   flutter build ios --release
   ```

### Optimizaciones

1. **Web**
   - Configuración de service workers
   - Optimización de assets
   - Lazy loading de módulos

2. **Mobile**
   - Proguard rules para Android
   - Optimización de tamaño de APK/IPA
   - Gestión de memoria

## 🗺 Roadmap y Desarrollo Futuro

### Próximas Características

1. **Autenticación**
   - [ ] Autenticación social
   - [ ] Verificación de dos factores
   - [ ] Gestión de sesiones múltiples

2. **Perfil de Usuario**
   - [ ] CRUD completo
   - [ ] Avatares y personalización
   - [ ] Preferencias de usuario

3. **Core Features**
   - [ ] Seguimiento de partidos
   - [ ] Estadísticas en tiempo real
   - [ ] Análisis de datos

## ✍️ Autor y Contribución

### Autor
- **Juan Sebastián Giraldo** - [@yei5](https://github.com/yei5)

### Contribución
1. Fork el repositorio
2. Crear rama de feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add: amazing feature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📚 Referencias Técnicas

- [Documentación Flutter](https://docs.flutter.dev/)
- [Supabase Auth API](https://supabase.com/docs/guides/auth)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture Samples](https://fluttersamples.com/)
