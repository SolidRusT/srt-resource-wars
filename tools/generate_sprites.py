#!/usr/bin/env python3
"""
Resource Wars - SVG Sprite Generator
Generates procedural unit and structure sprites for the game.
"""

import svgwrite
from pathlib import Path
import sys

# Color palettes for teams
TEAM_COLORS = {
    0: "#0066FF",  # Blue (player)
    1: "#FF0000",  # Red (AI)
    2: "#00FF00",  # Green (future multiplayer)
    3: "#FFFF00",  # Yellow (future multiplayer)
}

def generate_unit_worker(team_id, output_dir):
    """Generate simple worker unit sprite"""
    dwg = svgwrite.Drawing(size=('64px', '64px'))
    
    # Body (rectangle)
    color = TEAM_COLORS.get(team_id, "#888888")
    dwg.add(dwg.rect(
        insert=(20, 20),
        size=(24, 32),
        fill=color,
        stroke='black',
        stroke_width=2
    ))
    
    # Head (circle)
    dwg.add(dwg.circle(
        center=(32, 16),
        r=6,
        fill='#FFD8B0',  # Skin tone
        stroke='black',
        stroke_width=1
    ))
    
    # Tool (small rectangle - representing a tool/wrench)
    dwg.add(dwg.rect(
        insert=(44, 28),
        size=(8, 16),
        fill='#666666',
        stroke='black',
        stroke_width=1
    ))
    
    filename = f"worker_team{team_id}.svg"
    filepath = output_dir / filename
    dwg.saveas(str(filepath))
    print(f"  ✓ Generated: {filename}")
    return filepath


def generate_unit_soldier(team_id, output_dir):
    """Generate simple soldier unit sprite"""
    dwg = svgwrite.Drawing(size=('64px', '64px'))
    
    # Body
    color = TEAM_COLORS.get(team_id, "#888888")
    dwg.add(dwg.rect(
        insert=(20, 22),
        size=(24, 30),
        fill=color,
        stroke='black',
        stroke_width=2
    ))
    
    # Head
    dwg.add(dwg.circle(
        center=(32, 18),
        r=6,
        fill='#FFD8B0',
        stroke='black',
        stroke_width=1
    ))
    
    # Weapon (line representing a rifle)
    dwg.add(dwg.line(
        start=(44, 26),
        end=(56, 22),
        stroke='#333333',
        stroke_width=3
    ))
    
    # Weapon detail (stock)
    dwg.add(dwg.rect(
        insert=(44, 24),
        size=(6, 4),
        fill='#8B4513',  # Brown
        stroke='black',
        stroke_width=1
    ))
    
    filename = f"soldier_team{team_id}.svg"
    filepath = output_dir / filename
    dwg.saveas(str(filepath))
    print(f"  ✓ Generated: {filename}")
    return filepath


def generate_unit_tank(team_id, output_dir):
    """Generate simple tank unit sprite"""
    dwg = svgwrite.Drawing(size=('64px', '64px'))
    
    color = TEAM_COLORS.get(team_id, "#888888")
    
    # Tank body (rounded rectangle)
    dwg.add(dwg.rect(
        insert=(16, 24),
        size=(32, 20),
        rx=4, ry=4,
        fill=color,
        stroke='black',
        stroke_width=2
    ))
    
    # Turret
    dwg.add(dwg.circle(
        center=(32, 32),
        r=8,
        fill=color,
        stroke='black',
        stroke_width=2
    ))
    
    # Cannon
    dwg.add(dwg.rect(
        insert=(40, 30),
        size=(16, 4),
        fill='#333333',
        stroke='black',
        stroke_width=1
    ))
    
    # Treads (left)
    dwg.add(dwg.rect(
        insert=(14, 26),
        size=(4, 16),
        fill='#222222',
        stroke='black',
        stroke_width=1
    ))
    
    # Treads (right)
    dwg.add(dwg.rect(
        insert=(46, 26),
        size=(4, 16),
        fill='#222222',
        stroke='black',
        stroke_width=1
    ))
    
    filename = f"tank_team{team_id}.svg"
    filepath = output_dir / filename
    dwg.saveas(str(filepath))
    print(f"  ✓ Generated: {filename}")
    return filepath


def generate_structure_base(team_id, output_dir):
    """Generate base/command center structure"""
    dwg = svgwrite.Drawing(size=('128px', '128px'))
    
    color = TEAM_COLORS.get(team_id, "#888888")
    
    # Main building base
    dwg.add(dwg.rect(
        insert=(20, 50),
        size=(88, 58),
        fill=color,
        stroke='black',
        stroke_width=3
    ))
    
    # Roof/top
    dwg.add(dwg.polygon(
        points=[(20, 50), (64, 30), (108, 50)],
        fill='#444444',
        stroke='black',
        stroke_width=2
    ))
    
    # Door
    dwg.add(dwg.rect(
        insert=(54, 78),
        size=(20, 30),
        fill='#222222',
        stroke='black',
        stroke_width=2
    ))
    
    # Windows (left side)
    dwg.add(dwg.rect(
        insert=(30, 60),
        size=(12, 12),
        fill='#87CEEB',  # Light blue
        stroke='black',
        stroke_width=1
    ))
    
    # Windows (right side)
    dwg.add(dwg.rect(
        insert=(86, 60),
        size=(12, 12),
        fill='#87CEEB',
        stroke='black',
        stroke_width=1
    ))
    
    # Antenna
    dwg.add(dwg.line(
        start=(64, 30),
        end=(64, 15),
        stroke='#666666',
        stroke_width=2
    ))
    dwg.add(dwg.circle(
        center=(64, 15),
        r=3,
        fill='#FF0000',  # Red light
        stroke='black',
        stroke_width=1
    ))
    
    filename = f"base_team{team_id}.svg"
    filepath = output_dir / filename
    dwg.saveas(str(filepath))
    print(f"  ✓ Generated: {filename}")
    return filepath


def generate_structure_factory(team_id, output_dir):
    """Generate factory/production building"""
    dwg = svgwrite.Drawing(size=('128px', '128px'))
    
    color = TEAM_COLORS.get(team_id, "#888888")
    
    # Main factory building
    dwg.add(dwg.rect(
        insert=(15, 40),
        size=(98, 68),
        fill=color,
        stroke='black',
        stroke_width=3
    ))
    
    # Chimney
    dwg.add(dwg.rect(
        insert=(85, 20),
        size=(15, 20),
        fill='#666666',
        stroke='black',
        stroke_width=2
    ))
    
    # Smoke (circles)
    dwg.add(dwg.circle(
        center=(92, 12),
        r=4,
        fill='#CCCCCC',
        opacity=0.7
    ))
    dwg.add(dwg.circle(
        center=(88, 8),
        r=3,
        fill='#CCCCCC',
        opacity=0.5
    ))
    
    # Large door/bay
    dwg.add(dwg.rect(
        insert=(35, 68),
        size=(58, 40),
        fill='#333333',
        stroke='black',
        stroke_width=2
    ))
    
    # Door segments (horizontal lines)
    for y in [78, 88, 98]:
        dwg.add(dwg.line(
            start=(35, y),
            end=(93, y),
            stroke='#555555',
            stroke_width=2
        ))
    
    # Side detail
    dwg.add(dwg.rect(
        insert=(20, 50),
        size=(10, 40),
        fill='#555555',
        stroke='black',
        stroke_width=1
    ))
    
    filename = f"factory_team{team_id}.svg"
    filepath = output_dir / filename
    dwg.saveas(str(filepath))
    print(f"  ✓ Generated: {filename}")
    return filepath


def generate_structure_refinery(team_id, output_dir):
    """Generate refinery/resource processing building"""
    dwg = svgwrite.Drawing(size=('128px', '128px'))
    
    color = TEAM_COLORS.get(team_id, "#888888")
    
    # Main building
    dwg.add(dwg.rect(
        insert=(25, 45),
        size=(78, 63),
        fill=color,
        stroke='black',
        stroke_width=3
    ))
    
    # Storage tanks (circles on sides)
    dwg.add(dwg.circle(
        center=(20, 75),
        r=12,
        fill='#888888',
        stroke='black',
        stroke_width=2
    ))
    dwg.add(dwg.circle(
        center=(108, 75),
        r=12,
        fill='#888888',
        stroke='black',
        stroke_width=2
    ))
    
    # Pipes
    dwg.add(dwg.rect(
        insert=(15, 80),
        size=(98, 4),
        fill='#666666',
        stroke='black',
        stroke_width=1
    ))
    
    # Processing tower
    dwg.add(dwg.rect(
        insert=(55, 20),
        size=(18, 25),
        fill='#777777',
        stroke='black',
        stroke_width=2
    ))
    
    # Loading platform
    dwg.add(dwg.rect(
        insert=(35, 95),
        size=(58, 13),
        fill='#555555',
        stroke='black',
        stroke_width=2
    ))
    
    filename = f"refinery_team{team_id}.svg"
    filepath = output_dir / filename
    dwg.saveas(str(filepath))
    print(f"  ✓ Generated: {filename}")
    return filepath


def generate_resource_crystal(output_dir):
    """Generate resource deposit sprite (neutral)"""
    dwg = svgwrite.Drawing(size=('64px', '64px'))
    
    # Crystal cluster (polygons)
    # Main crystal
    dwg.add(dwg.polygon(
        points=[(32, 10), (45, 30), (38, 50), (26, 50), (19, 30)],
        fill='#FFD700',  # Gold
        stroke='#8B6914',
        stroke_width=2
    ))
    
    # Left crystal
    dwg.add(dwg.polygon(
        points=[(22, 20), (28, 35), (24, 48), (16, 48), (12, 35)],
        fill='#FFA500',  # Orange
        stroke='#8B6914',
        stroke_width=2
    ))
    
    # Right crystal
    dwg.add(dwg.polygon(
        points=[(42, 20), (48, 35), (52, 48), (44, 48), (36, 35)],
        fill='#FFA500',
        stroke='#8B6914',
        stroke_width=2
    ))
    
    # Base/ground
    dwg.add(dwg.ellipse(
        center=(32, 52),
        r=(20, 6),
        fill='#8B4513',  # Brown
        stroke='#654321',
        stroke_width=1
    ))
    
    filename = "resource_crystal.svg"
    filepath = output_dir / filename
    dwg.saveas(str(filepath))
    print(f"  ✓ Generated: {filename}")
    return filepath


def main():
    """Main generation function"""
    print("=" * 60)
    print("Resource Wars - SVG Sprite Generator")
    print("=" * 60)
    
    # Create output directories
    base_dir = Path(__file__).parent.parent / "assets-source"
    units_dir = base_dir / "units"
    structures_dir = base_dir / "structures"
    resources_dir = base_dir / "resources"
    
    # Ensure directories exist
    units_dir.mkdir(parents=True, exist_ok=True)
    structures_dir.mkdir(parents=True, exist_ok=True)
    resources_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"\nOutput directories:")
    print(f"  • Units: {units_dir}")
    print(f"  • Structures: {structures_dir}")
    print(f"  • Resources: {resources_dir}")
    
    # Generate units for teams 0 and 1 (player and AI)
    print("\n[1/4] Generating unit sprites...")
    generated_units = []
    for team in [0, 1]:
        generated_units.append(generate_unit_worker(team, units_dir))
        generated_units.append(generate_unit_soldier(team, units_dir))
        generated_units.append(generate_unit_tank(team, units_dir))
    
    # Generate structures for teams 0 and 1
    print("\n[2/4] Generating structure sprites...")
    generated_structures = []
    for team in [0, 1]:
        generated_structures.append(generate_structure_base(team, structures_dir))
        generated_structures.append(generate_structure_factory(team, structures_dir))
        generated_structures.append(generate_structure_refinery(team, structures_dir))
    
    # Generate neutral resources
    print("\n[3/4] Generating resource sprites...")
    generated_resources = []
    generated_resources.append(generate_resource_crystal(resources_dir))
    
    print("\n[4/4] Generation complete!")
    print("=" * 60)
    print(f"Total files generated: {len(generated_units) + len(generated_structures) + len(generated_resources)}")
    print(f"  • Units: {len(generated_units)}")
    print(f"  • Structures: {len(generated_structures)}")
    print(f"  • Resources: {len(generated_resources)}")
    print("\nNext step: Run the rasterization script to convert to PNG")
    print("  Windows: tools\\build_assets.bat")
    print("  Linux/Mac: tools/build_assets.sh")
    print("=" * 60)
    
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        print(f"\nERROR: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
