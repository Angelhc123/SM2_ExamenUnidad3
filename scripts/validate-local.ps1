# 🔍 Script de Validación Local - Acees Group
# Ejecutar antes de hacer commit/push

Write-Host "🚀 Iniciando validación local del proyecto Acees Group..." -ForegroundColor Cyan
Write-Host ""

# Contadores
$script:Errors = 0
$script:Warnings = 0

# Funciones de utilidad
function Write-Error-Custom {
    param($Message)
    Write-Host "❌ ERROR: $Message" -ForegroundColor Red
    $script:Errors++
}

function Write-Warning-Custom {
    param($Message)
    Write-Host "⚠️  WARNING: $Message" -ForegroundColor Yellow
    $script:Warnings++
}

function Write-Success {
    param($Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

# 1. Validación de Backend
Write-Host "📋 Validación de Backend (Node.js)..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

if (Test-Path "backend") {
    Write-Success "Directorio backend existe"
    
    Push-Location backend
    
    if (Test-Path "package.json") {
        Write-Success "package.json encontrado"
    } else {
        Write-Error-Custom "package.json no encontrado"
    }
    
    if (Test-Path "node_modules") {
        Write-Success "Dependencias instaladas"
    } else {
        Write-Warning-Custom "Dependencias no instaladas. Ejecutar: npm install"
    }
    
    Write-Host ""
    Write-Host "🔍 Ejecutando npm audit..." -ForegroundColor Cyan
    $auditResult = npm audit --audit-level=moderate 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "No se encontraron vulnerabilidades críticas"
    } else {
        Write-Warning-Custom "Se encontraron vulnerabilidades. Revisar con: npm audit"
    }
    
    if (Test-Path ".env") {
        Write-Success ".env encontrado"
    } else {
        Write-Warning-Custom ".env no encontrado. Copiar desde .env.example"
    }
    
    if (Test-Path "index.js") {
        Write-Success "index.js encontrado"
    } else {
        Write-Error-Custom "index.js no encontrado"
    }
    
    Pop-Location
} else {
    Write-Error-Custom "Directorio backend no encontrado"
}

# 2. Validación de Frontend
Write-Host ""
Write-Host "📱 Validación de Frontend (Flutter)..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterCmd) {
    $flutterVersion = (flutter --version 2>&1 | Select-Object -First 1)
    Write-Success "Flutter instalado: $flutterVersion"
} else {
    Write-Error-Custom "Flutter no está instalado"
}

if (Test-Path "pubspec.yaml") {
    Write-Success "pubspec.yaml encontrado"
} else {
    Write-Error-Custom "pubspec.yaml no encontrado"
}

if (Test-Path ".dart_tool") {
    Write-Success "Dependencias Flutter instaladas"
} else {
    Write-Warning-Custom "Dependencias Flutter no instaladas. Ejecutar: flutter pub get"
}

if ($flutterCmd) {
    Write-Host ""
    Write-Host "🔍 Ejecutando flutter analyze..." -ForegroundColor Cyan
    $analyzeResult = flutter analyze --no-fatal-infos 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Flutter analyze pasó sin errores críticos"
    } else {
        Write-Warning-Custom "Flutter analyze encontró problemas. Ejecutar: flutter analyze"
    }
}

# 3. Verificar estructura
Write-Host ""
Write-Host "📂 Verificando estructura del proyecto..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$requiredDirs = @(
    "lib",
    "lib\models",
    "lib\services",
    "lib\viewmodels",
    "lib\views",
    "lib\widgets",
    "backend",
    ".github\workflows"
)

foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Success "Directorio $dir existe"
    } else {
        Write-Error-Custom "Directorio $dir no encontrado"
    }
}

# 4. Verificar workflows
Write-Host ""
Write-Host "⚙️  Verificando workflows..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$workflows = @(
    ".github\workflows\security.yml",
    ".github\workflows\code-quality.yml",
    ".github\workflows\performance.yml",
    ".github\workflows\build.yml",
    ".github\workflows\database.yml",
    ".github\workflows\documentation.yml",
    ".github\workflows\monitoring.yml",
    ".github\workflows\e2e-testing.yml",
    ".github\workflows\ml-analysis.yml"
)

foreach ($workflow in $workflows) {
    if (Test-Path $workflow) {
        $name = Split-Path $workflow -Leaf
        Write-Success "Workflow $name existe"
    } else {
        $name = Split-Path $workflow -Leaf
        Write-Error-Custom "Workflow $name no encontrado"
    }
}

# 5. Verificar Git
Write-Host ""
Write-Host "🔧 Verificando configuración Git..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

if (Test-Path ".git") {
    Write-Success "Repositorio Git inicializado"
    
    if (Test-Path ".gitignore") {
        Write-Success ".gitignore existe"
        
        $gitignoreContent = Get-Content .gitignore
        if ($gitignoreContent -match "\.env") {
            Write-Success ".env está en .gitignore"
        } else {
            Write-Warning-Custom ".env debería estar en .gitignore"
        }
    } else {
        Write-Warning-Custom ".gitignore no encontrado"
    }
    
    $gitStatus = git status --porcelain
    if ([string]::IsNullOrEmpty($gitStatus)) {
        Write-Success "No hay cambios sin commitear"
    } else {
        Write-Warning-Custom "Hay cambios sin commitear"
    }
} else {
    Write-Error-Custom "No es un repositorio Git"
}

# 6. Verificar archivos importantes
Write-Host ""
Write-Host "📄 Verificando archivos importantes..." -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

$importantFiles = @(
    "README.md",
    "Dockerfile",
    "pubspec.yaml",
    "backend\package.json",
    ".github\workflows\README.md"
)

foreach ($file in $importantFiles) {
    if (Test-Path $file) {
        Write-Success "Archivo $file existe"
    } else {
        Write-Warning-Custom "Archivo $file no encontrado"
    }
}

# Resumen final
Write-Host ""
Write-Host "═══════════════════════════════════════════" -ForegroundColor Gray
Write-Host "📊 RESUMEN DE VALIDACIÓN" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════" -ForegroundColor Gray
Write-Host ""

if ($script:Errors -eq 0 -and $script:Warnings -eq 0) {
    Write-Host "✨ ¡Perfecto! No se encontraron problemas." -ForegroundColor Green
    Write-Host "✅ El proyecto está listo para commit/push" -ForegroundColor Green
    $exitCode = 0
} elseif ($script:Errors -eq 0) {
    Write-Host "⚠️  Se encontraron $($script:Warnings) advertencias" -ForegroundColor Yellow
    Write-Host "💡 Revisar las advertencias antes de continuar" -ForegroundColor Yellow
    $exitCode = 0
} else {
    Write-Host "❌ Se encontraron $($script:Errors) errores y $($script:Warnings) advertencias" -ForegroundColor Red
    Write-Host "🛑 Corregir los errores antes de hacer commit/push" -ForegroundColor Red
    $exitCode = 1
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""

if ($script:Errors -gt 0 -or $script:Warnings -gt 0) {
    Write-Host "💡 Sugerencias:" -ForegroundColor Cyan
    Write-Host "   1. Instalar dependencias: npm install (backend) y flutter pub get"
    Write-Host "   2. Ejecutar análisis local: npm audit y flutter analyze"
    Write-Host "   3. Configurar variables de entorno (.env)"
    Write-Host "   4. Revisar los workflows en .github/workflows/"
    Write-Host ""
}

Write-Host "🚀 Comandos útiles:" -ForegroundColor Cyan
Write-Host "   flutter doctor  # Verificar instalación Flutter"
Write-Host "   npm test        # Ejecutar tests del backend"
Write-Host "   flutter test    # Ejecutar tests de Flutter"
Write-Host ""

exit $exitCode
