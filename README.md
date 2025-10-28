# match_track — ejecutar demo de "Reestablecer contraseña" en Codespaces

Breve guía para ejecutar la demo de la HU "Reestablecer contraseña" en GitHub Codespaces o en un devcontainer local.

Requisitos:
- Tener Codespaces o VS Code Remote - Containers.
- Puerto 8080 es usado por el demo (web-server).

Pasos recomendados:

1) (Recomendado) Abrir el repositorio en Codespaces o en VS Code y elegir "Rebuild Container" / "Reopen in Container" para usar la configuración en `.devcontainer/`.

2) Si por alguna razón el contenedor no tiene Flutter (mensaje `flutter: command not found`), puedes ejecutar un instalador local sin sudo:

```bash
./scripts/install_flutter_local.sh
```

3) Ejecutar el demo (instala deps, corre tests y levanta app en web-server):

```bash
./scripts/start_demo.sh
```

4) Abrir el puerto que forwardea Codespaces (8080) o acceder a `http://localhost:8080` si ejecutas localmente.

Notas:
- El proyecto contiene un `.env` con credenciales para Supabase (uso académico). Si lo prefieres, crea tu propio `.env` siguiendo `.env.example`.
- He añadido tests unitarios que mockean la comunicación con Supabase. `./scripts/start_demo.sh` ejecuta `flutter test` antes de iniciar la app.
- Si prefieres que la imagen de devcontainer venga ya con Flutter (recomendado), el `Dockerfile` en `.devcontainer/` lo instala; reconstruir el contenedor es necesario para usarlo.

Si tienes problemas para reconstruir el contenedor, ejecuto los pasos manualmente aquí si me lo indicas.
# match_track

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
