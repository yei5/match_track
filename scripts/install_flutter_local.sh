#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FLUTTER_DIR="$HOME/flutter-sdk"

echo "Installing Flutter (stable) into $FLUTTER_DIR (no sudo)..."
if [ -d "$FLUTTER_DIR" ]; then
  echo "Flutter already present at $FLUTTER_DIR"
else
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
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
