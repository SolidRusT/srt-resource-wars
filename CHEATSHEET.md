# Resource Wars: Developer Cheat Sheet

*Quick reference for active development*

---

## 🎯 MVP Scope (Must-Have)

### Core Features
- [x] Multi-unit drag selection
- [x] Right-click move/attack
- [x] 2 unit types (worker, soldier)
- [x] 1 building (base/factory)
- [x] 1 resource type
- [x] Simple combat (HP, attack, death)
- [x] Basic AI (3-state: GATHER/BUILD/ATTACK)
- [x] Win/lose conditions

### Critical Checkpoints
- **Hour 16:** Units moving + basic game loop ✓/✗
- **Hour 30:** AI functional + production working ✓/✗
- **Hour 38:** Game playable end-to-end ✓/✗

---

## 📊 Balance Quick Reference

### Unit Cost Ratios (from Dune II)
```
Infantry  :  Light   :  Main    :  Heavy
   100    :   150    :   300    :   800
```

### Speed Ratios
```
Heavy  :  Main   :  Light  :  Scout
  30   :   40    :   45    :   60
```

### Build Times
```
Infantry:     ~2 seconds
Light Vehicle: ~4 seconds
Main Tank:    ~6 seconds
Heavy Unit:   ~10 seconds
```

### Resource Economy
```
Starting Credits: 1000-1500
Harvester Cycle:  2-4 minutes → 700 credits
Income Early:     200-300/min
Income Late:      1000+/min
```

---

## 🎨 Asset Generation Commands

### Generate SVG Sprites
```bash
cd tools
python generate_sprites.py
```

### Rasterize to PNG
```bash
# Linux/Mac
./build_assets.sh

# Windows
build_assets.bat
```

### Output Locations
- **SVG Source:** `assets-source/units/`, `assets-source/structures/`
- **PNG Sprites:** `godot-project/assets/sprites/units/`, `structures/`

---

## 🎮 Godot Quick Keys

### Editor
- **F5** - Run project
- **F6** - Run current scene
- **F7** - Resume from breakpoint
- **Ctrl+S** - Save scene
- **Ctrl+Shift+S** - Save scene as

### Scene Tree
- **Ctrl+A** - Add child node
- **Ctrl+D** - Duplicate node
- **Del** - Delete node

### Debugging
- **F9** - Add/remove breakpoint
- **Print** - `print("debug:", variable)`
- **Profiler** - Debug → Profiler

---

## 💻 Essential GDScript Patterns

### Unit Movement
```gdscript
var velocity: Vector2
var target_position: Vector2
var move_speed: float = 100.0

func _physics_process(delta):
    if target_position != Vector2.ZERO:
        var direction = (target_position - global_position).normalized()
        velocity = direction * move_speed
        move_and_slide()
```

### Selection Management
```gdscript
var selected_units: Array[Unit] = []

func select_unit(unit: Unit):
    selected_units.append(unit)
    unit.select()

func clear_selection():
    for unit in selected_units:
        unit.deselect()
    selected_units.clear()
```

### Group Management
```gdscript
# Add to group
unit.add_to_group("units")
unit.add_to_group("team_0")

# Query group
var all_units = get_tree().get_nodes_in_group("units")
var player_units = get_tree().get_nodes_in_group("team_0")
```

### Simple AI State Machine
```gdscript
enum AIState { GATHER, BUILD, ATTACK }
var state: AIState = AIState.GATHER

func _process(delta):
    match state:
        AIState.GATHER:
            ensure_workers(3)
            if workers.size() >= 3:
                state = AIState.BUILD
        AIState.BUILD:
            if resources >= 100:
                queue_unit()
            if military_units.size() >= 5:
                state = AIState.ATTACK
        AIState.ATTACK:
            attack_enemy_base()
```

---

## 🗺️ Map Generation Basics

### Perlin Noise Terrain
```gdscript
var noise = FastNoiseLite.new()
noise.seed = randi()

for x in range(width):
    for y in range(height):
        var value = noise.get_noise_2d(x, y)
        if value > 0.4 and value < 0.6:
            set_tile(x, y, BUILDABLE)
        elif value > 0.8:
            set_tile(x, y, RESOURCE_RICH)
```

---

## 🤖 Ollama LLM Integration

### Test Ollama Connection
```bash
# Check if running
ollama list

# Test model
ollama run llama3.2:3b "Hello, generate a battle taunt"
```

### Make LLM Request (GDScript)
```gdscript
func generate_taunt(personality: String, event: String) -> String:
    var prompt = """
    You are an AI opponent with personality: {personality}
    Recent event: {event}
    Generate a short 1-sentence taunt.
    """.format({"personality": personality, "event": event})
    
    var http = HTTPRequest.new()
    add_child(http)
    
    var body = JSON.stringify({
        "model": "llama3.2:3b",
        "prompt": prompt,
        "stream": false
    })
    
    http.request("http://localhost:11434/api/generate", 
                 ["Content-Type: application/json"], 
                 HTTPClient.METHOD_POST, 
                 body)
    
    var result = await http.request_completed
    var json = JSON.parse_string(result[3].get_string_from_utf8())
    http.queue_free()
    
    return json["response"] if json else ""
```

---

## 🐛 Common Issues & Fixes

### Units Not Moving
```
✓ Check NavigationRegion2D exists
✓ Verify navigation polygon baked
✓ Confirm unit has NavigationAgent2D
✓ Debug: print(target_position, global_position)
```

### Low FPS (< 30)
```
✓ Check unit count (should be < 100 for MVP)
✓ Disable debug collision shapes
✓ Use Profiler: Debug → Profiler
✓ Implement spatial hash if > 50 units
```

### Selection Not Working
```
✓ Check input map configured
✓ Verify CollisionShape2D on units
✓ Test with print statements
✓ Check z-index on selection box
```

### Assets Not Loading
```
✓ Reimport: Project → Reimport Assets
✓ Verify file paths (case-sensitive!)
✓ Check PNG files exist after rasterization
✓ Restart Godot editor
```

---

## 📋 Testing Checklist

### Hour 8 Test
```
[x] Can spawn units?
[x] Can select units (click)?
[x] Can drag-select multiple units?
[x] Can move units (right-click)?
[x] Do units avoid each other?
```

### Hour 16 Test (CRITICAL)
```
[x] Units attack on command?
[x] HP decreases when attacked?
[x] Units die at 0 HP?
[x] Resources collecting?
[x] Building produces units?
[x] AI builds workers?
```

### Hour 30 Test
```
[x] Production queue working?
[x] AI transitions states?
[x] AI attacks player?
[x] Win condition triggers?
[x] Lose condition triggers?
```

### Hour 38 Test (FINAL)
```
[x] Game playable start to finish?
[x] No crashes during 5-minute play?
[x] UI shows relevant info?
[x] Frame rate acceptable (>30 FPS)?
[x] Controls feel responsive?
```

---

## 🚨 Emergency Scope Cuts

### If Behind at Hour 16
**Cut:** Combat system  
**Pivot:** Resource-only economy game  
**Keep:** Movement, selection, harvesting

### If Behind at Hour 30
**Cut:** AI opponent  
**Pivot:** 1v1 multiplayer (same keyboard)  
**Keep:** Core game loop, win condition

### If Behind at Hour 38
**Cut EVERYTHING except:**
- Unit movement
- Basic combat
- Win condition
Ship MVP, polish later!

---

## 📁 File Organization

### Scene Hierarchy
```
Main.tscn
├── Camera2D
├── Map (TileMap)
├── Units (Node2D)
├── Structures (Node2D)
└── UI (CanvasLayer)
```

### Script Structure
```
scripts/
├── game_manager.gd         # Global state
├── unit.gd                 # Unit behavior
├── structure.gd            # Building logic
├── selection_manager.gd    # Input/selection
├── ai_controller.gd        # AI opponent
└── resource_manager.gd     # Economy
```

---

## 🎯 Performance Targets

| Units | FPS | Optimization |
|-------|-----|--------------|
| 0-50  | 60  | None needed |
| 50-100| 60  | Spatial hash |
| 100-200| 45-60 | + Quadtree |
| 200-500| 30-45 | + Flow fields |

---

## 📚 Documentation Locations

- **Full Dune Dynasty Analysis:** `docs/01-dunedynasty-analysis.md`
- **Balance Reference:** `docs/02-game-balance-reference.md`
- **Tech Architecture:** `docs/03-technical-architecture.md`
- **Setup Guide:** `docs/04-getting-started.md`
- **Project Summary:** `PROJECT-SUMMARY.md`
- **This Cheat Sheet:** `CHEATSHEET.md`

### Dunedynasty Source (Reference Only)
```
C:\Users\shaun\repos\dunedynasty\
├── include/enum_unit.h       # Unit types
├── include/enum_structure.h  # Building types
├── src/ai.c                  # AI logic
├── src/table/unitinfo.c      # Unit stats
└── src/table/structureinfo.c # Building stats
```

---

## 🎮 Controls Reference

| Action | Key/Mouse | Notes |
|--------|-----------|-------|
| Select unit | LMB | Click unit |
| Drag-select | LMB drag | Draw rectangle |
| Select all type | Ctrl+LMB or Double-click | Same unit type |
| Move | RMB | Context command |
| Attack | A + click | Attack-move |
| Stop | S | Cancel orders |
| Control group set | Ctrl+1-0 | Assign group |
| Control group recall | 1-0 | Select group |
| Camera pan | WASD or MMB drag | Move viewport |
| Pause | Esc | Pause menu |

---

## 💡 Pro Tips

### Development Workflow
- **Commit every 2-3 hours** with `Hour X: [feature] - [status]`
- **Test at each checkpoint** (Hours 8, 16, 30, 38)
- **Cut features early** if falling behind
- **Use print() liberally** for debugging

### GDScript Performance
- Use `@onready` for node references
- Prefer groups over individual references
- Cache expensive queries
- Use typed variables: `var unit: Unit`

### Asset Generation
- Generate assets **before** implementing features
- Test with simple colored squares first
- Iterate on art after gameplay works

### Balance Tuning
- **Only change ONE value at a time**
- Test for 5 minutes after each change
- Start with Dune II ratios
- 10-20% adjustments are usually enough

---

**Keep this file open during development for quick reference!**

*Last Updated: 2025-10-08*
