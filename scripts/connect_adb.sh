#!/bin/bash

# Script para conectar con ADB del host desde el devcontainer
# Autor: GitHub Copilot
# Fecha: 2025-11-09

echo "🔧 Intentando conectar con ADB del host..."

# Verificar si ADB está disponible
if ! command -v adb &> /dev/null; then
    echo "❌ ADB no está instalado en el devcontainer"
    echo "💡 Necesitas ejecutar 'flutter run' desde tu máquina host"
    echo ""
    echo "Pasos para ejecutar desde el host:"
    echo "1. Abre una terminal en tu máquina local (fuera del devcontainer)"
    echo "2. Navega al directorio del proyecto"
    echo "3. Ejecuta: flutter devices"
    echo "4. Ejecuta: flutter run"
    exit 1
fi

# Verificar dispositivos conectados
echo "📱 Buscando dispositivos Android..."
DEVICES=$(adb devices | grep -v "List" | grep "device$" | wc -l)

if [ "$DEVICES" -eq 0 ]; then
    echo "❌ No se encontraron dispositivos Android conectados"
    echo ""
    echo "Asegúrate de que:"
    echo "1. El emulador esté corriendo en tu máquina host"
    echo "2. El devcontainer esté usando --network=host"
    echo "3. ADB esté corriendo en el host (ejecuta: adb start-server)"
    exit 1
else
    echo "✅ Se encontraron $DEVICES dispositivo(s) Android"
    echo ""
    echo "Dispositivos disponibles:"
    adb devices
    echo ""
    echo "✨ Puedes ejecutar: flutter run"
fi
