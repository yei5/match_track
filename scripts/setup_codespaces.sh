#!/usr/bin/env bash
set -euo pipefail

echo "=== setup_codespaces.sh: Installing prerequisites and Flutter SDK ==="

if [ "$(id -u)" -ne 0 ]; then
  SUDO='sudo'
else
  SUDO=''
fi

echo "Updating apt and installing dependencies..."
$SUDO apt-get update -y
$SUDO apt-get install -y git curl unzip xz-utils zip libglu1-mesa wget ca-certificates gnupg lsb-release

FLUTTER_DIR=/usr/local/flutter
if [ ! -d "$FLUTTER_DIR" ]; then
  echo "Cloning Flutter stable channel into $FLUTTER_DIR (this may take a few minutes)..."
  $SUDO git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_DIR
else
  echo "Flutter already cloned in $FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# Persist PATH for interactive shells
if ! grep -q "$FLUTTER_DIR/bin" ~/.bashrc 2>/dev/null; then
  echo "export PATH=\"$FLUTTER_DIR/bin:\$PATH\"" >> ~/.bashrc
fi

echo "Running flutter precache and doctor (may download artifacts)..."
flutter --version || true
flutter precache
flutter doctor -v

echo "Running flutter pub get to fetch dependencies..."
flutter pub get

echo "Setup finished. Restart your terminal or run: source ~/.bashrc"
