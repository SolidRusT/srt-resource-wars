@echo off
REM Resource Wars - Asset Rasterization Script (Windows)
REM Converts SVG source files to PNG sprites for Godot

echo ============================================================
echo Resource Wars - Asset Rasterization
echo ============================================================

REM Create output directories
echo.
echo [1/4] Creating output directories...
if not exist "..\godot-project\assets\sprites\units" mkdir "..\godot-project\assets\sprites\units"
if not exist "..\godot-project\assets\sprites\structures" mkdir "..\godot-project\assets\sprites\structures"
if not exist "..\godot-project\assets\sprites\resources" mkdir "..\godot-project\assets\sprites\resources"
echo   + Created sprite directories

REM Check if cairosvg is available
echo.
echo [2/4] Checking dependencies...
python -c "import cairosvg" 2>nul
if errorlevel 1 (
    echo   ! cairosvg not found. Installing...
    pip install cairosvg
) else (
    echo   + cairosvg is installed
)

REM Convert units (64x64)
echo.
echo [3/4] Rasterizing unit sprites (64x64)...
set /a count=0
for %%f in (..\assets-source\units\*.svg) do (
    python -c "import cairosvg; cairosvg.svg2png(url='%%f', write_to='..\\godot-project\\assets\\sprites\\units\\%%~nf.png', output_width=64, output_height=64)"
    echo   + Converted: %%~nf.png
    set /a count+=1
)
echo   Total units converted: %count%

REM Convert structures (128x128)
echo.
echo [4/4] Rasterizing structure sprites (128x128)...
set /a count=0
for %%f in (..\assets-source\structures\*.svg) do (
    python -c "import cairosvg; cairosvg.svg2png(url='%%f', write_to='..\\godot-project\\assets\\sprites\\structures\\%%~nf.png', output_width=128, output_height=128)"
    echo   + Converted: %%~nf.png
    set /a count+=1
)
echo   Total structures converted: %count%

REM Convert resources (64x64)
echo.
echo [5/5] Rasterizing resource sprites (64x64)...
set /a count=0
for %%f in (..\assets-source\resources\*.svg) do (
    python -c "import cairosvg; cairosvg.svg2png(url='%%f', write_to='..\\godot-project\\assets\\sprites\\resources\\%%~nf.png', output_width=64, output_height=64)"
    echo   + Converted: %%~nf.png
    set /a count+=1
)
echo   Total resources converted: %count%

echo.
echo ============================================================
echo Rasterization complete!
echo Assets ready in: godot-project\assets\sprites\
echo.
echo Next step: Open godot-project in Godot Engine
echo ============================================================
pause
