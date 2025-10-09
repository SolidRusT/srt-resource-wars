#!/bin/bash
# Resource Wars - Asset Rasterization Script (Linux/Mac)
# Converts SVG source files to PNG sprites for Godot

echo "============================================================"
echo "Resource Wars - Asset Rasterization"
echo "============================================================"

# Create output directories
echo ""
echo "[1/4] Creating output directories..."
mkdir -p ../godot-project/assets/sprites/units
mkdir -p ../godot-project/assets/sprites/structures
mkdir -p ../godot-project/assets/sprites/resources
echo "  ✓ Created sprite directories"

# Check if cairosvg is available
echo ""
echo "[2/4] Checking dependencies..."
if ! python3 -c "import cairosvg" 2>/dev/null; then
    echo "  ! cairosvg not found. Installing..."
    pip3 install cairosvg
else
    echo "  ✓ cairosvg is installed"
fi

# Convert units (64x64)
echo ""
echo "[3/4] Rasterizing unit sprites (64x64)..."
count=0
for svg in ../assets-source/units/*.svg; do
    if [ -f "$svg" ]; then
        filename=$(basename "$svg" .svg)
        python3 -c "import cairosvg; cairosvg.svg2png(url='$svg', write_to='../godot-project/assets/sprites/units/${filename}.png', output_width=64, output_height=64)"
        echo "  ✓ Converted: ${filename}.png"
        ((count++))
    fi
done
echo "  Total units converted: $count"

# Convert structures (128x128)
echo ""
echo "[4/4] Rasterizing structure sprites (128x128)..."
count=0
for svg in ../assets-source/structures/*.svg; do
    if [ -f "$svg" ]; then
        filename=$(basename "$svg" .svg)
        python3 -c "import cairosvg; cairosvg.svg2png(url='$svg', write_to='../godot-project/assets/sprites/structures/${filename}.png', output_width=128, output_height=128)"
        echo "  ✓ Converted: ${filename}.png"
        ((count++))
    fi
done
echo "  Total structures converted: $count"

# Convert resources (64x64)
echo ""
echo "[5/5] Rasterizing resource sprites (64x64)..."
count=0
for svg in ../assets-source/resources/*.svg; do
    if [ -f "$svg" ]; then
        filename=$(basename "$svg" .svg)
        python3 -c "import cairosvg; cairosvg.svg2png(url='$svg', write_to='../godot-project/assets/sprites/resources/${filename}.png', output_width=64, output_height=64)"
        echo "  ✓ Converted: ${filename}.png"
        ((count++))
    fi
done
echo "  Total resources converted: $count"

echo ""
echo "============================================================"
echo "Rasterization complete!"
echo "Assets ready in: godot-project/assets/sprites/"
echo ""
echo "Next step: Open godot-project in Godot Engine"
echo "============================================================"
