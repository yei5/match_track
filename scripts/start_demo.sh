#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Ensure flutter is available"
if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found. Attempting local installer (no sudo)..."
  if ! ./scripts/install_flutter_local.sh; then
    echo "Failed to install Flutter locally. If you are inside an Alpine-based container, rebuild the devcontainer using the project's .devcontainer (Ubuntu) and try again."
    exit 1
  fi
  export PATH="$HOME/flutter-sdk/bin:$PATH"
fi

echo "==> Running flutter pub get"
flutter pub get

echo "==> Running flutter tests"
if flutter test; then
  echo "Tests passed"
else
  echo "Some tests failed (see output). Continuing to run the app for manual testing."
fi

echo "==> Starting app on web-server at http://0.0.0.0:8080"
echo "Open the forwarded port 8080 in Codespaces or http://localhost:8080 locally."
echo "==> Preparing web release build"

# Build dart-define args from .env if present. These will be passed to flutter build.
dart_defines=()
envfile="$ROOT_DIR/.env"
if [ -f "$envfile" ]; then
  echo "Found .env — injecting values into Flutter via --dart-define"
  while IFS='=' read -r key val || [ -n "$key" ]; do
    key=$(echo "$key" | sed -e 's/^\s*//' -e 's/\s*$//')
    val=$(echo "$val" | sed -e 's/^\s*//' -e 's/\s*$//')
    if [ -z "$key" ] || echo "$key" | grep -qE '^#'; then
      continue
    fi
    # Escape double quotes
    val=${val//\"/\\\"}
    dart_defines+=("--dart-define=${key}=${val}")
  done < <(grep -E '^[^#[:space:]]' "$envfile" || true)
else
  echo "No .env file found; ensure SUPABASE_URL and SUPABASE_ANON_KEY are provided via environment or --dart-define when building."
fi

echo "Building web release (this may take a while)..."
flutter build web --release --pwa-strategy none "${dart_defines[@]:-}"

echo "==> Serving built web at http://0.0.0.0:8080"

# Kill any process currently listening on 8080 (best-effort)
for p in $(lsof -t -i:8080 2>/dev/null || true); do
  echo "Killing existing process on 8080: $p"
  kill -9 "$p" || true
done

# Serve the build directory using a simple HTTP server in background
BUILD_DIR="$ROOT_DIR/build/web"
if [ ! -d "$BUILD_DIR" ]; then
  echo "Build directory not found: $BUILD_DIR"
  exit 1
fi

STATIC_LOG=/tmp/static_web.log
STATIC_PID=/tmp/static_web.pid
nohup python3 -m http.server 8080 --directory "$BUILD_DIR" > "$STATIC_LOG" 2>&1 &
echo $! > "$STATIC_PID"
echo "Static server started with PID: $(cat "$STATIC_PID")"
echo "Logs: $STATIC_LOG"

echo "Open the forwarded port 8080 in Codespaces or http://localhost:8080 locally."
