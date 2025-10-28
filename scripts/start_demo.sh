#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Ensure flutter is available"
if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found. Running local installer (no sudo)..."
  ./scripts/install_flutter_local.sh
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

# Run web-server; will block until terminated
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080
