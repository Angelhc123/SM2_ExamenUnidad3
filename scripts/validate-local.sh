#!/bin/bash

# 🔍 Script de Validación Local - Acees Group
# Ejecutar antes de hacer commit/push

echo "🚀 Iniciando validación local del proyecto Acees Group..."
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
ERRORS=0
WARNINGS=0

# Función para mostrar error
error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    ((ERRORS++))
}

# Función para mostrar warning
warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    ((WARNINGS++))
}

# Función para mostrar éxito
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

echo "📋 Validación de Backend (Node.js)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. Verificar que existe el directorio backend
if [ -d "backend" ]; then
    success "Directorio backend existe"
    
    cd backend
    
    # 2. Verificar package.json
    if [ -f "package.json" ]; then
        success "package.json encontrado"
    else
        error "package.json no encontrado"
    fi
    
    # 3. Verificar node_modules
    if [ -d "node_modules" ]; then
        success "Dependencias instaladas"
    else
        warning "Dependencias no instaladas. Ejecutar: npm install"
    fi
    
    # 4. Ejecutar npm audit
    echo ""
    echo "🔍 Ejecutando npm audit..."
    if npm audit --audit-level=moderate; then
        success "No se encontraron vulnerabilidades críticas"
    else
        warning "Se encontraron vulnerabilidades. Revisar con: npm audit"
    fi
    
    # 5. Verificar .env
    if [ -f ".env" ]; then
        success ".env encontrado"
    else
        warning ".env no encontrado. Copiar desde .env.example"
    fi
    
    # 6. Verificar index.js
    if [ -f "index.js" ]; then
        success "index.js encontrado"
    else
        error "index.js no encontrado"
    fi
    
    cd ..
else
    error "Directorio backend no encontrado"
fi

echo ""
echo "📱 Validación de Frontend (Flutter)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 7. Verificar Flutter
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    success "Flutter instalado: $FLUTTER_VERSION"
else
    error "Flutter no está instalado"
fi

# 8. Verificar pubspec.yaml
if [ -f "pubspec.yaml" ]; then
    success "pubspec.yaml encontrado"
else
    error "pubspec.yaml no encontrado"
fi

# 9. Verificar dependencias Flutter
if [ -d ".dart_tool" ]; then
    success "Dependencias Flutter instaladas"
else
    warning "Dependencias Flutter no instaladas. Ejecutar: flutter pub get"
fi

# 10. Flutter analyze
if command -v flutter &> /dev/null; then
    echo ""
    echo "🔍 Ejecutando flutter analyze..."
    if flutter analyze --no-fatal-infos > /dev/null 2>&1; then
        success "Flutter analyze pasó sin errores críticos"
    else
        warning "Flutter analyze encontró problemas. Ejecutar: flutter analyze"
    fi
fi

# 11. Verificar estructura de directorios
echo ""
echo "📂 Verificando estructura del proyecto..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

REQUIRED_DIRS=(
    "lib"
    "lib/models"
    "lib/services"
    "lib/viewmodels"
    "lib/views"
    "lib/widgets"
    "backend"
    ".github/workflows"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        success "Directorio $dir existe"
    else
        error "Directorio $dir no encontrado"
    fi
done

# 12. Verificar workflows
echo ""
echo "⚙️  Verificando workflows..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

WORKFLOWS=(
    ".github/workflows/security.yml"
    ".github/workflows/code-quality.yml"
    ".github/workflows/performance.yml"
    ".github/workflows/build.yml"
    ".github/workflows/database.yml"
    ".github/workflows/documentation.yml"
    ".github/workflows/monitoring.yml"
    ".github/workflows/e2e-testing.yml"
    ".github/workflows/ml-analysis.yml"
)

for workflow in "${WORKFLOWS[@]}"; do
    if [ -f "$workflow" ]; then
        success "Workflow $(basename $workflow) existe"
    else
        error "Workflow $(basename $workflow) no encontrado"
    fi
done

# 13. Verificar Git
echo ""
echo "🔧 Verificando configuración Git..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d ".git" ]; then
    success "Repositorio Git inicializado"
    
    # Verificar .gitignore
    if [ -f ".gitignore" ]; then
        success ".gitignore existe"
        
        # Verificar que .env está en .gitignore
        if grep -q "\.env" .gitignore; then
            success ".env está en .gitignore"
        else
            warning ".env debería estar en .gitignore"
        fi
    else
        warning ".gitignore no encontrado"
    fi
    
    # Verificar cambios pendientes
    if git diff-index --quiet HEAD --; then
        success "No hay cambios sin commitear"
    else
        warning "Hay cambios sin commitear"
    fi
else
    error "No es un repositorio Git"
fi

# 14. Verificar archivos importantes
echo ""
echo "📄 Verificando archivos importantes..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

IMPORTANT_FILES=(
    "README.md"
    "Dockerfile"
    "pubspec.yaml"
    "backend/package.json"
    ".github/workflows/README.md"
)

for file in "${IMPORTANT_FILES[@]}"; do
    if [ -f "$file" ]; then
        success "Archivo $file existe"
    else
        warning "Archivo $file no encontrado"
    fi
done

# 15. Verificar configuración de Docker
if [ -f "Dockerfile" ]; then
    if command -v docker &> /dev/null; then
        success "Docker está instalado"
        
        # Verificar que el Dockerfile es válido
        if docker build -t test-build -f Dockerfile . --quiet > /dev/null 2>&1; then
            success "Dockerfile es válido"
        else
            warning "Dockerfile podría tener problemas. Probar: docker build ."
        fi
    else
        warning "Docker no está instalado"
    fi
fi

# Resumen final
echo ""
echo "═══════════════════════════════════════════"
echo "📊 RESUMEN DE VALIDACIÓN"
echo "═══════════════════════════════════════════"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✨ ¡Perfecto! No se encontraron problemas.${NC}"
    echo -e "${GREEN}✅ El proyecto está listo para commit/push${NC}"
    EXIT_CODE=0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Se encontraron $WARNINGS advertencias${NC}"
    echo -e "${YELLOW}💡 Revisar las advertencias antes de continuar${NC}"
    EXIT_CODE=0
else
    echo -e "${RED}❌ Se encontraron $ERRORS errores y $WARNINGS advertencias${NC}"
    echo -e "${RED}🛑 Corregir los errores antes de hacer commit/push${NC}"
    EXIT_CODE=1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Sugerencias
if [ $ERRORS -gt 0 ] || [ $WARNINGS -gt 0 ]; then
    echo "💡 Sugerencias:"
    echo "   1. Instalar dependencias: npm install (backend) y flutter pub get"
    echo "   2. Ejecutar análisis local: npm audit y flutter analyze"
    echo "   3. Configurar variables de entorno (.env)"
    echo "   4. Revisar los workflows en .github/workflows/"
    echo ""
fi

echo "🚀 Para ejecutar los workflows localmente con act:"
echo "   act -l  # Listar workflows"
echo "   act push  # Simular push"
echo ""

exit $EXIT_CODE
