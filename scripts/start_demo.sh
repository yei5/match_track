#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Running flutter pub get"
flutter pub get

echo "==> Running flutter tests"
if flutter test; then
  echo "Tests passed"
else
  echo "Some tests failed (see output). Continuing to run the app for manual testing."
fi

echo "==> Starting app on web-server at http://0.0.0.0:8080"
echo "Open https://localhost:8080 from your browser (Codespaces forwards the port)."

# Run web-server; will block until terminated
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080
