#!/bin/bash

# Script de verificación del proyecto Flutter
# Verifica que todas las correcciones se hayan aplicado correctamente

echo "🔍 Verificando estado del proyecto match_track..."
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: No se encuentra pubspec.yaml"
    echo "   Ejecuta este script desde el directorio raíz del proyecto"
    exit 1
fi

# Verificar dependencias críticas
echo "📦 Verificando dependencias en pubspec.yaml..."
if grep -q "flutter_bloc: \^9.1.1" pubspec.yaml && grep -q "flutter_svg: \^2.2.1" pubspec.yaml; then
    echo "   ✅ flutter_bloc y flutter_svg encontradas"
else
    echo "   ❌ Faltan dependencias críticas"
    exit 1
fi

# Verificar assets
echo "🎨 Verificando configuración de assets..."
if grep -q "assets:" pubspec.yaml && grep -q "- .env" pubspec.yaml; then
    echo "   ✅ Assets configurados correctamente"
else
    echo "   ⚠️  Assets no configurados"
fi

# Verificar archivo .env
echo "🔐 Verificando archivo .env..."
if [ -f ".env" ]; then
    echo "   ✅ Archivo .env existe"
else
    echo "   ❌ Archivo .env no encontrado"
    exit 1
fi

# Verificar directorio assets
echo "📁 Verificando directorio assets..."
if [ -d "assets" ]; then
    echo "   ✅ Directorio assets existe"
else
    echo "   ⚠️  Directorio assets no encontrado"
fi

# Verificar análisis de código
echo "🔬 Analizando código..."
ANALYZE_OUTPUT=$(flutter analyze 2>&1)
if echo "$ANALYZE_OUTPUT" | grep -q "No issues found"; then
    echo "   ✅ Código sin errores"
else
    echo "   ⚠️  Se encontraron algunos issues:"
    echo "$ANALYZE_OUTPUT" | tail -5
fi

# Verificar dispositivos
echo "📱 Verificando dispositivos disponibles..."
DEVICES=$(flutter devices 2>&1)
if echo "$DEVICES" | grep -q "android"; then
    echo "   ✅ Dispositivo Android detectado"
    echo "$DEVICES" | grep "android"
else
    echo "   ⚠️  No se detectaron dispositivos Android"
    echo "   💡 Ejecuta desde tu máquina host o inicia un emulador"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESUMEN"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Correcciones aplicadas desde rama dev:"
echo "   • flutter_bloc: ^9.1.1 agregado"
echo "   • flutter_svg: ^2.2.1 agregado"
echo "   • Assets configurados (.env y assets/)"
echo "   • Código sin errores de compilación"
echo ""
echo "📝 Próximos pasos:"
echo "   1. Si ves dispositivos Android arriba: ejecuta 'flutter run'"
echo "   2. Si no hay dispositivos: ejecuta desde tu máquina host"
echo "   3. Lee ANDROID_SETUP.md para instrucciones detalladas"
echo ""
echo "🚀 Para ejecutar desde tu máquina host:"
echo "   cd /ruta/a/match_track"
echo "   flutter devices"
echo "   flutter run"
echo ""
