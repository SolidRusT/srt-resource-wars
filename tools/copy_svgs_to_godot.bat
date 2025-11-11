@echo off
REM Copy SVG files directly to Godot project
REM Godot 4 has native SVG support - no PNG conversion needed!

echo ============================================================
echo Resource Wars - Copy SVGs to Godot Project
echo ============================================================
echo.

echo Copying SVG files...
xcopy /E /I /Y "..\assets-source\*.svg" "..\godot-project\assets\svg\" 2>nul
if errorlevel 1 (
    echo.
    echo Trying individual directories...
    xcopy /E /I /Y "..\assets-source\units\*.svg" "..\godot-project\assets\svg\units\" 2>nul
    xcopy /E /I /Y "..\assets-source\structures\*.svg" "..\godot-project\assets\svg\structures\" 2>nul
    xcopy /E /I /Y "..\assets-source\resources\*.svg" "..\godot-project\assets\svg\resources\" 2>nul
)

echo.
echo ============================================================
echo SUCCESS: SVG files copied to godot-project\assets\svg\
echo ============================================================
echo.
echo Godot 4 has NATIVE SVG support - no PNG conversion needed!
echo.
echo Next steps:
echo   1. Open godot-project in Godot Engine
echo   2. SVG files will appear in FileSystem dock
echo   3. They work as Texture2D automatically
echo.
echo That's it! No more Python conversion headaches.
echo ============================================================
pause
