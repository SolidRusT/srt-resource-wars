# Resource Wars: Getting Started Guide

## Project Overview

**Resource Wars** is a modern Dune II-inspired RTS game featuring:
- Dynamic procedurally generated SVG graphics
- AI LLM integration for adaptive gameplay
- Old-school 4X mechanics with modern QoL features
- Cross-platform support (Windows, Mac, Linux)

**Timeline:** 2-day MVP development
**Target Audience:** Old-school RTS/4X players
**Technology:** Godot 4.x + Python (asset generation) + Ollama (LLM)

---

## Prerequisites

### Required Software

#### 1. Godot Engine 4.x
**Download:** https://godotengine.org/download

- Choose **Godot Engine - Standard** (not .NET version)
- Version 4.2 or later recommended
- Windows: Extract .exe to convenient location
- Mac: Move .app to Applications folder
- Linux: Extract and mark as executable

#### 2. Python 3.10+
**Download:** https://www.python.org/downloads/

**Required Libraries:**
```bash
pip install svgwrite cairosvg pillow noise
```

- `svgwrite` - SVG file generation
- `cairosvg` - SVG to PNG conversion
- `pillow` - Image manipulation
- `noise` - Perlin noise for terrain

#### 3. Ollama (Optional, for LLM features)
**Download:** https://ollama.ai/download

**Setup:**
```bash
# Install Ollama
# Download from website or use package manager

# Pull Llama 3.2 3B model (recommended for speed)
ollama pull llama3.2:3b

# Verify installation
ollama list
```

**Note:** Ollama is optional for MVP. Can be added later.

#### 4. Git (Recommended)
**Download:** https://git-scm.com/downloads

For version control and collaboration.

---

## Project Setup

### Step 1: Create Project Structure

Navigate to `C:\Users\shaun\repos\resource-wars` (already created!)

Expected structure:
```
resource-wars/
├── docs/                          # Documentation (you are here!)
│   ├── 01-dunedynasty-analysis.md
│   ├── 02-game-balance-reference.md
│   ├── 03-technical-architecture.md
│   └── 04-getting-started.md
├── godot-project/                 # Main Godot project
│   ├── project.godot
│   ├── scenes/
│   ├── scripts/
│   └── assets/
├── tools/                         # Python asset generation
│   ├── generate_sprites.py
│   ├── generate_terrain.py
│   └── build_assets.sh
├── assets-source/                 # Source SVGs (pre-rasterization)
│   ├── units/
│   ├── structures/
│   └── terrain/
└── README.md                      # Project overview
```

### Step 2: Initialize Godot Project

1. Open Godot Engine
2. Click "New Project"
3. Project Path: `C:\Users\shaun\repos\resource-wars\godot-project`
4. Project Name: "Resource Wars"
5. Renderer: **Forward+** (best compatibility and performance)
6. Click "Create & Edit"

### Step 3: Configure Project Settings

In Godot, go to **Project → Project Settings:**

#### Display Settings
- **Window → Size → Viewport Width:** 1920
- **Window → Size → Viewport Height:** 1080
- **Window → Size → Mode:** Windowed (change to Fullscreen later)
- **Window → Stretch → Mode:** viewport
- **Window → Stretch → Aspect:** expand

#### Rendering Settings
- **Rendering → Textures → Canvas Textures → Default Texture Filter:** Nearest
  (for crisp pixel-art style)

#### Input Map
Add actions:
- `select_unit` → Left Mouse Button
- `context_command` → Right Mouse Button
- `select_all_type` → Ctrl + Left Mouse Button
- `add_to_selection` → Shift + Left Mouse Button
- `stop_unit` → S key
- `attack_move` → A key
- `camera_up` → W key
- `camera_down` → S key  
- `camera_left` → A key
- `camera_right` → D key
- `camera_pan` → Middle Mouse Button (hold and drag)

Control groups (Ctrl+1 through Ctrl+0 and 1-0 for selection):
- Add in script dynamically

---

## Initial Scene Setup

### Main Scene Structure

Create the following scene hierarchy:

```
Main (Node2D)
├── Camera2D
│   └── (enable "Enabled" and set smoothing)
├── Map (Node2D)
│   ├── TileMap (for terrain)
│   ├── Resources (Node2D, for resource deposits)
│   └── FogOfWar (CanvasModulate, for fog)
├── Units (Node2D)
│   └── (units spawn here as children)
├── Structures (Node2D)
│   └── (buildings spawn here as children)
├── UI (CanvasLayer)
│   ├── HUD (Control)
│   │   ├── ResourceDisplay
│   │   ├── SelectionPanel
│   │   └── CommandPanel
│   └── Minimap (Panel)
└── GameManager (Node)
    ├── SelectionManager (Node)
    ├── ResourceManager (Node)
    ├── AIController (Node)
    └── LLMInterface (Node, optional)
```

Save as `res://scenes/main.tscn`

---

## Asset Generation Workflow

### Phase 1: Generate SVG Source Assets (Python)

Create `tools/generate_sprites.py`:

```python
import svgwrite
from pathlib import Path

# Color palettes for teams
TEAM_COLORS = {
    0: "#0066FF",  # Blue (player)
    1: "#FF0000",  # Red (AI)
    2: "#00FF00",  # Green (future multiplayer)
}

def generate_unit_worker(team_id, output_dir):
    """Generate simple worker unit sprite"""
    dwg = svgwrite.Drawing(size=('64px', '64px'))
    
    # Body (rectangle)
    color = TEAM_COLORS[team_id]
    dwg.add(dwg.rect(
        insert=(20, 20),
        size=(24, 32),
        fill=color,
        stroke='black',
        stroke_width=2
    ))
    
    # Tool (small rectangle)
    dwg.add(dwg.rect(
        insert=(44, 28),
        size=(8, 16),
        fill='#666666',
        stroke='black',
        stroke_width=1
    ))
    
    filename = f"worker_team{team_id}.svg"
    dwg.saveas(output_dir / filename)
    print(f"Generated: {filename}")

def generate_unit_soldier(team_id, output_dir):
    """Generate simple soldier unit sprite"""
    dwg = svgwrite.Drawing(size=('64px', '64px'))
    
    # Body
    color = TEAM_COLORS[team_id]
    dwg.add(dwg.rect(
        insert=(20, 20),
        size=(24, 32),
        fill=color,
        stroke='black',
        stroke_width=2
    ))
    
    # Weapon (line)
    dwg.add(dwg.line(
        start=(44, 24),
        end=(56, 20),
        stroke='#333333',
        stroke_width=3
    ))
    
    filename = f"soldier_team{team_id}.svg"
    dwg.saveas(output_dir / filename)
    print(f"Generated: {filename}")

def generate_structure_base(team_id, output_dir):
    """Generate simple base structure"""
    dwg = svgwrite.Drawing(size=('128px', '128px'))
    
    # Main building
    color = TEAM_COLORS[team_id]
    dwg.add(dwg.rect(
        insert=(20, 40),
        size=(88, 68),
        fill=color,
        stroke='black',
        stroke_width=3
    ))
    
    # Roof
    dwg.add(dwg.polygon(
        points=[(20, 40), (64, 20), (108, 40)],
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
    
    filename = f"base_team{team_id}.svg"
    dwg.saveas(output_dir / filename)
    print(f"Generated: {filename}")

if __name__ == "__main__":
    output_dir = Path("../assets-source/units")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Generate for both teams
    for team in [0, 1]:
        generate_unit_worker(team, output_dir)
        generate_unit_soldier(team, output_dir)
    
    output_dir = Path("../assets-source/structures")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    for team in [0, 1]:
        generate_structure_base(team, output_dir)
    
    print("\nSVG generation complete!")
    print("Next: Run rasterization script to convert to PNG")
```

Run: `python tools/generate_sprites.py`

### Phase 2: Rasterize to PNG (Build Script)

Create `tools/build_assets.sh` (or `.bat` for Windows):

```bash
#!/bin/bash

echo "Rasterizing SVG assets to PNG..."

# Create output directories
mkdir -p ../godot-project/assets/sprites/units
mkdir -p ../godot-project/assets/sprites/structures

# Convert units (64×64)
for svg in ../assets-source/units/*.svg; do
    filename=$(basename "$svg" .svg)
    cairosvg -f png -W 64 -H 64 -o "../godot-project/assets/sprites/units/${filename}.png" "$svg"
    echo "Converted: $filename"
done

# Convert structures (128×128)
for svg in ../assets-source/structures/*.svg; do
    filename=$(basename "$svg" .svg)
    cairosvg -f png -W 128 -H 128 -o "../godot-project/assets/sprites/structures/${filename}.png" "$svg"
    echo "Converted: $filename"
done

echo "Rasterization complete!"
echo "Assets ready in godot-project/assets/sprites/"
```

Make executable: `chmod +x tools/build_assets.sh`
Run: `./tools/build_assets.sh`

**Windows Alternative (`build_assets.bat`):**
```batch
@echo off
echo Rasterizing SVG assets to PNG...

mkdir ..\godot-project\assets\sprites\units 2>nul
mkdir ..\godot-project\assets\sprites\structures 2>nul

for %%f in (..\assets-source\units\*.svg) do (
    cairosvg -f png -W 64 -H 64 -o "..\godot-project\assets\sprites\units\%%~nf.png" "%%f"
    echo Converted: %%~nf
)

for %%f in (..\assets-source\structures\*.svg) do (
    cairosvg -f png -W 128 -H 128 -o "..\godot-project\assets\sprites\structures\%%~nf.png" "%%f"
    echo Converted: %%~nf
)

echo Rasterization complete!
```

---

## First Playable Milestone (Hour 8)

### Goal: Unit Movement and Selection

1. **Unit Scene** (`res://scenes/unit.tscn`)
   - Create CharacterBody2D
   - Add Sprite2D (use worker_team0.png)
   - Add CollisionShape2D (CircleShape2D, radius ~16)
   - Attach script `res://scripts/unit.gd`

2. **Unit Script** (`res://scripts/unit.gd`)
```gdscript
extends CharacterBody2D
class_name Unit

var selected: bool = false
var move_speed: float = 100.0
var target_position: Vector2 = Vector2.ZERO

func _ready():
    add_to_group("units")

func _physics_process(delta):
    if target_position != Vector2.ZERO:
        var direction = (target_position - global_position).normalized()
        velocity = direction * move_speed
        
        if global_position.distance_to(target_position) < 5:
            target_position = Vector2.ZERO
            velocity = Vector2.ZERO
        
        move_and_slide()

func select():
    selected = true
    modulate = Color(1, 1, 1, 1.5)  # Brighten

func deselect():
    selected = false
    modulate = Color(1, 1, 1, 1)  # Normal

func move_to(pos: Vector2):
    target_position = pos
```

3. **Test**: Spawn a few units, implement basic click selection and move commands

---

## Development Checkpoints

### Hour 4: Camera + Map
- [x] Camera movement (WASD)
- [x] Basic tile map
- [x] Unit spawning

### Hour 8: Units + Selection
- [x] Click selection
- [x] Drag-box selection
- [x] Move command (right-click)
- [x] Multiple units moving

### Hour 12: Combat + Resources
- [x] Attack command
- [x] HP and death
- [x] Resource display
- [x] Basic harvesting

### Hour 16: AI + Buildings (CRITICAL CHECKPOINT)
- [x] Simple AI state machine
- [x] One building with production
- [x] Win/lose condition

**If behind at Hour 16:** Cut combat, make resource-only game

### Hour 24: Integration + Basic Polish
- [x] All systems connected
- [x] Game playable end-to-end
- [x] Basic UI

### Hour 38: Polish + Bug Fixes (FINAL CHECKPOINT)
- [x] Visual feedback (health bars, selection)
- [x] Command panel
- [x] Minimap
- [x] Balance tweaking

**If behind at Hour 38:** Cut all non-essential features immediately

---

## Testing the MVP

### Minimum Viable Test (Hour 16)
```
1. Can spawn units? YES/NO
2. Can select and move units? YES/NO
3. Do units collect resources? YES/NO
4. Can build more units? YES/NO
5. Does AI do anything? YES/NO
6. Is there a win condition? YES/NO
```

If **any answer is NO**, that's your priority before continuing.

### Playability Test (Hour 24)
1. Start game
2. Gather resources for 2 minutes
3. Build 5 military units
4. Attack AI base
5. Can you win?

**If game crashes or is unwinnable, that's blocking for MVP.**

---

## Git Workflow (Recommended)

### Initial Commit
```bash
cd C:\Users\shaun\repos\resource-wars
git init
git add .
git commit -m "Initial project structure and documentation"
```

### Development Commits (Every 2-3 hours)
```bash
git add .
git commit -m "Hour X: [Feature] - [Status]"

# Examples:
# git commit -m "Hour 4: Camera and map - Working"
# git commit -m "Hour 8: Unit selection - Drag-box broken, click works"
# git commit -m "Hour 16: AI CHECKPOINT - Basic state machine functional"
```

### Branches (If experimenting)
```bash
# Try risky feature on branch
git checkout -b experiment-feature
# ... work ...

# If it works:
git checkout main
git merge experiment-feature

# If it doesn't:
git checkout main
git branch -D experiment-feature  # Discard
```

---

## Troubleshooting

### Godot Won't Open Project
- Check you selected correct Godot version (4.x, not 3.x)
- Verify `project.godot` file exists in project root
- Try "Import" instead of "New Project"

### Assets Not Appearing
- Check file paths are correct (case-sensitive on Linux/Mac)
- Reimport assets: Project → Reimport Assets
- Verify PNG files exist after rasterization

### Units Not Moving
- Check NavigationRegion2D is setup
- Verify unit has NavigationAgent2D
- Print debug info: `print(global_position, target_position)`

### Performance Issues (< 30 FPS)
- Check unit count (should be < 100 for MVP)
- Disable debug collision shapes
- Profile: Debug → Profiler

### Python Scripts Failing
- Verify all libraries installed: `pip list`
- Check Python version: `python --version` (should be 3.10+)
- Try running in virtual environment

### Ollama Not Responding
- Check Ollama is running: `ollama list`
- Verify model pulled: `ollama pull llama3.2:3b`
- Test manually: `ollama run llama3.2:3b "Hello"`
- Check port 11434 not blocked by firewall

---

## Next Steps

1. ✅ Read all documentation in `docs/` folder
2. ✅ Setup development environment (Godot, Python, Ollama)
3. ✅ Create initial Godot project structure
4. ⬜ Generate initial asset sprites (Python script)
5. ⬜ Implement core game loop (follow Hour-by-Hour roadmap)
6. ⬜ Regular commits and checkpoint validation
7. ⬜ MVP playable at Hour 24
8. ⬜ Polish and bug fixes Hour 24-48

---

## Resources and References

### Documentation
- `01-dunedynasty-analysis.md` - Code reference from existing RTS
- `02-game-balance-reference.md` - Proven balance ratios and unit stats
- `03-technical-architecture.md` - Godot implementation details

### External Resources
- **Godot Docs:** https://docs.godotengine.org/en/stable/
- **Godot RTS Tutorial:** https://www.youtube.com/results?search_query=godot+rts+tutorial
- **Dunedynasty Source:** `C:\Users\shaun\repos\dunedynasty`
- **Ollama Docs:** https://ollama.ai/docs

---

## Questions or Issues?

While working, document:
1. What you tried
2. What happened
3. What you expected
4. Error messages (full text)

Then consult:
- Godot documentation
- Stack Overflow (tag: godot)
- Godot Discord community
- This project's documentation

---

**Ready to build Resource Wars? Let's go!** 🚀

Start with: `python tools/generate_sprites.py`
