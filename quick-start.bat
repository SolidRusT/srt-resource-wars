@echo off
REM Resource Wars - Quick Start Script
REM Automates initial setup for Windows

echo ============================================================
echo Resource Wars - Quick Start Setup
echo ============================================================

REM Check if we're in the right directory
if not exist "tools\generate_sprites.py" (
    echo ERROR: Please run this script from the resource-wars root directory
    pause
    exit /b 1
)

REM Step 1: Check Python
echo.
echo [1/5] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo   ! Python not found. Please install Python 3.10+ from python.org
    pause
    exit /b 1
) else (
    python --version
    echo   + Python is installed
)

REM Step 2: Install dependencies
echo.
echo [2/5] Installing Python dependencies...
cd tools
pip install -r requirements.txt
if errorlevel 1 (
    echo   ! Failed to install dependencies
    cd ..
    pause
    exit /b 1
) else (
    echo   + Dependencies installed successfully
)

REM Step 3: Generate SVG sprites
echo.
echo [3/5] Generating SVG sprites...
python generate_sprites.py
if errorlevel 1 (
    echo   ! Failed to generate sprites
    cd ..
    pause
    exit /b 1
) else (
    echo   + Sprites generated successfully
)

REM Step 4: Rasterize to PNG
echo.
echo [4/5] Rasterizing sprites to PNG...
call build_assets.bat
if errorlevel 1 (
    echo   ! Failed to rasterize sprites
    cd ..
    pause
    exit /b 1
) else (
    echo   + Sprites rasterized successfully
)

cd ..

REM Step 5: Final check
echo.
echo [5/5] Verifying setup...
if exist "godot-project\assets\sprites\units\worker_team0.png" (
    echo   + Setup verified successfully!
) else (
    echo   ! Warning: Some files may be missing
)

echo.
echo ============================================================
echo Setup Complete!
echo ============================================================
echo.
echo Next steps:
echo   1. Open Godot Engine
echo   2. Click "Import"
echo   3. Navigate to: %CD%\godot-project
echo   4. Select project.godot
echo   5. Click "Import & Edit"
echo.
echo See IMPLEMENTATION-ROADMAP.md for next development steps
echo ============================================================
pause
