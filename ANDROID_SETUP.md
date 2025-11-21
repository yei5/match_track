# 🚀 Guía para Ejecutar en Emulador Android

## ✅ Correcciones Aplicadas

Se han corregido las siguientes diferencias entre la rama `feature/game_control` y `dev`:

### 1. **Dependencias Restauradas**
```yaml
# Agregadas a pubspec.yaml:
flutter_bloc: ^9.1.1
flutter_svg: ^2.2.1
```

### 2. **Assets Configurados**
```yaml
# Agregado a pubspec.yaml:
flutter:
  assets:
    - .env
    - assets/
```

### 3. **Devcontainer Actualizado**
Se agregó soporte para conexión de red con el host:
```json
"runArgs": ["--network=host"],
"mounts": ["source=/tmp/.X11-unix,target=/tmp/.X11-unix,type=bind"]
```

---

## 📱 Cómo Ejecutar en Emulador Android

### Opción 1: Desde tu Máquina Host (Recomendado)

**IMPORTANTE:** Como estás en un devcontainer, la forma más sencilla es ejecutar Flutter desde tu máquina host.

#### Pasos:

1. **Abre una terminal en tu máquina local** (fuera del devcontainer)

2. **Navega al directorio del proyecto:**
   ```bash
   cd /ruta/a/match_track
   ```

3. **Inicia el emulador de Android Studio** (si no está corriendo):
   - Abre Android Studio
   - Ve a: **Tools > Device Manager**
   - Inicia tu emulador preferido

4. **Verifica que el emulador esté conectado:**
   ```bash
   flutter devices
   ```
   
   Deberías ver algo como:
   ```
   Pixel_4_API_30 (mobile) • emulator-5554 • android-x64 • Android 11 (API 30)
   ```

5. **Ejecuta la aplicación:**
   ```bash
   flutter run
   ```

---

### Opción 2: Desde el Devcontainer (Requiere Configuración)

Para ejecutar desde el devcontainer necesitas:

1. **Reconstruir el devcontainer** con los nuevos cambios:
   - Presiona `Ctrl+Shift+P` (o `Cmd+Shift+P` en Mac)
   - Busca: "Dev Containers: Rebuild Container"
   - Espera a que se reconstruya

2. **Instalar Android SDK en el devcontainer** (opcional, complejo):
   ```bash
   # Esto requiere configuración adicional
   # No recomendado para desarrollo rápido
   ```

3. **Usar el script de verificación:**
   ```bash
   ./scripts/connect_adb.sh
   ```

---

### Opción 3: Ejecutar en Modo Web (Para Testing Rápido)

Si solo quieres probar la aplicación rápidamente:

```bash
cd /workspaces/match_track
flutter run -d web-server --web-port=8080
```

Luego abre tu navegador en: `http://localhost:8080`

---

## 🔧 Verificar Estado del Proyecto

### Verificar que no hay errores de compilación:
```bash
flutter analyze
```

### Ver dispositivos disponibles:
```bash
flutter devices
```

### Limpiar y reconstruir:
```bash
flutter clean
flutter pub get
```

---

## 📋 Checklist de Verificación

- [x] Dependencias `flutter_bloc` y `flutter_svg` agregadas
- [x] Assets configurados en `pubspec.yaml`
- [x] Directorio `assets/` creado
- [x] Archivo `.env` existe con credenciales de Supabase
- [x] `flutter pub get` ejecutado exitosamente
- [x] `flutter clean` ejecutado
- [x] Devcontainer actualizado con soporte de red
- [ ] Emulador Android conectado
- [ ] Aplicación ejecutándose

---

## ⚠️ Notas Importantes

1. **El proyecto está listo para compilar** - No hay errores de código
2. **Solo faltan 4 warnings menores** que no afectan la ejecución
3. **El archivo .env está configurado** con las credenciales correctas
4. **La configuración de Android (build.gradle.kts) es correcta**

---

## 🆘 Solución de Problemas

### "No se encuentran dispositivos"
- Verifica que el emulador esté corriendo en tu máquina host
- Ejecuta `adb devices` en tu máquina host
- Si ves el dispositivo, ejecuta `flutter run` desde el host

### "Unable to locate Android SDK"
- Este error aparece en el devcontainer porque no tiene Android SDK
- **Solución:** Ejecuta desde tu máquina host donde está instalado Android Studio

### "Build failed"
- Ejecuta: `flutter clean && flutter pub get`
- Asegúrate de tener la última versión de Flutter

---

## 📞 Siguiente Paso

**Ejecuta desde tu máquina host:**
```bash
cd /ruta/a/match_track
flutter devices
flutter run
```

✨ ¡Tu aplicación debería compilar y ejecutarse sin problemas!
