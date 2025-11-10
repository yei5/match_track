#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FLUTTER_DIR="$HOME/flutter-sdk"

echo "Installing Flutter (stable) into $FLUTTER_DIR (no sudo)..."

# Detect musl (Alpine) vs glibc. Flutter prebuilt binaries expect glibc.
if command -v ldd >/dev/null 2>&1; then
  if ldd --version 2>&1 | grep -iq musl; then
    cat <<'MSG'
ERROR: This environment appears to be Alpine / musl-based.
The prebuilt Flutter and Dart binaries require a glibc-based system (Debian/Ubuntu/CentOS).
Common symptom: "/cache/dart-sdk/bin/dart: cannot execute: required file not found".

Recommended options:
  - Rebuild the devcontainer using the project's `.devcontainer/Dockerfile` (Ubuntu 22.04) so Flutter works out-of-the-box.
  - Or install a glibc compatibility layer (e.g. gcompat) on Alpine — this is advanced and not guaranteed.

Run the devcontainer rebuild in Codespaces or open via "Reopen in Container" in VS Code.
MSG
    exit 1
  fi
fi

if [ -d "$FLUTTER_DIR" ]; then
  echo "Flutter already present at $FLUTTER_DIR"
else
  git clone --depth 1 https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# Append PATH to ~/.bashrc if not present
if ! grep -q "$FLUTTER_DIR/bin" "$HOME/.bashrc" 2>/dev/null; then
  echo "export PATH=\"$FLUTTER_DIR/bin:\$PATH\"" >> "$HOME/.bashrc"
  echo "Added Flutter to ~/.bashrc"
fi

echo "Running flutter --version to finish install..."
"$FLUTTER_DIR/bin/flutter" --version || true

echo "Pre-caching web artifacts and running pub get..."
"$FLUTTER_DIR/bin/flutter" precache --web || true
cd "$ROOT_DIR"
"$FLUTTER_DIR/bin/flutter" pub get

echo "Flutter installed at $FLUTTER_DIR. Restart your shell or run: source ~/.bashrc"
