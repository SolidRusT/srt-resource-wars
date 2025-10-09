# Resource Wars: Technical Architecture

## Technology Stack

### Core Engine
**Godot 4.x** (MIT License)
- Native cross-platform support (Windows, Mac, Linux)
- Built-in Navigation2D for A* pathfinding
- Scene/Node architecture perfect for entity management
- GDScript for rapid prototyping

---

### Graphics Pipeline

#### Development Phase: Procedural SVG Generation
**Tool:** Python + svgwrite library
- Generate unit sprites programmatically
- Define color palettes for team identification
- Create building blueprints
- Export at development time, not runtime

```python
# Example: Generate unit sprite
from svgwrite import Drawing

def generate_unit(unit_type, team_color):
    dwg = Drawing(size=('64px', '64px'))
    # Add shapes, apply team_color
    dwg.save(f'units/{unit_type}_{team_color}.svg')
```

#### Build Phase: Rasterization
**Tool:** CairoSVG or Inkscape CLI
- Convert all SVGs to PNG sprite sheets
- Generate multiple zoom levels (64×64, 128×128, 256×256)
- Optimize with pngcrush/optipng

```bash
# Build script example
for svg in assets/svg/*.svg; do
  cairosvg -f png -o "assets/sprites/$(basename $svg .svg).png" "$svg"
done
```

#### Runtime: Cached Bitmap Rendering
**Godot:** Texture2D sprites
- Load pre-rasterized PNG sprites at startup
- Cache in memory with resource system
- Render via CanvasItem nodes at 60 FPS

**Critical:** No SVG rendering during gameplay!

---

### Map and Terrain

#### Procedural Generation (Load Time)
**Algorithm:** Perlin Noise + Cellular Automata

```gdscript
# Pseudo-code for map generation
func generate_map(width: int, height: int, seed: int) -> TileMap:
    var noise = FastNoiseLite.new()
    noise.seed = seed
    
    # Base terrain with Perlin noise
    for x in range(width):
        for y in range(height):
            var value = noise.get_noise_2d(x, y)
            if value > 0.4 and value < 0.6:
                set_tile(x, y, BUILDABLE_PLATEAU)
            elif value > 0.8:
                set_tile(x, y, RESOURCE_RICH)
            else:
                set_tile(x, y, SAND)
    
    # Smooth with cellular automata (4-7 iterations)
    smooth_terrain()
    
    # Place spawn points using Voronoi
    place_spawns_symmetrically()
    
    return tilemap
```

#### Tile System
**Godot TileMap Node**
- 64×64 tile size
- Layers: Terrain (base), Resources (overlay), Fog of War (overlay)
- Autotiling for smooth transitions

---

### Pathfinding

#### Godot Navigation2D (Built-in A*)
**Setup:**
```gdscript
# In map scene
extends Node2D

@onready var navigation_region = $NavigationRegion2D

func _ready():
    # Navigation polygon automatically generated from TileMap
    # Mark walkable/non-walkable tiles
    pass

# In unit script
func move_to(target_position: Vector2):
    var path = NavigationServer2D.map_get_path(
        get_world_2d().navigation_map,
        global_position,
        target_position,
        true
    )
    follow_path(path)
```

**Optimization:**
- 32×32 or 64×64 navigation grid
- Integer coordinates only
- 500-node search limit
- Path caching for 1-2 seconds

---

### Unit Management

#### Scene Architecture
```
Unit (KinematicBody2D)
├─ Sprite2D (visual)
├─ CollisionShape2D (physics)
├─ SelectionIndicator (sprite, hidden by default)
├─ HealthBar (ProgressBar)
├─ NavigationAgent2D (pathfinding)
└─ StateMachine (script)
```

#### Unit Script Structure
```gdscript
class_name Unit
extends CharacterBody2D

# Stats
var max_hp: int = 100
var current_hp: int = 100
var move_speed: float = 100.0
var attack_damage: int = 10
var attack_range: float = 100.0
var cost: int = 100

# State
enum State { IDLE, MOVING, ATTACKING, HARVESTING, DEAD }
var current_state: State = State.IDLE
var target_position: Vector2
var target_unit: Unit = null

# Team identification
var team: int = 0  # 0=player, 1=AI
var team_color: Color = Color.BLUE

func _physics_process(delta):
    match current_state:
        State.IDLE:
            # Wait for commands
            pass
        State.MOVING:
            # Follow navigation path
            move_along_path(delta)
        State.ATTACKING:
            # Attack target
            attack_target(delta)
        State.HARVESTING:
            # Collect resources
            harvest_resources(delta)
```

#### Entity Management with Groups
```gdscript
# Add unit to groups for efficient queries
func spawn_unit(unit_scene, position, team):
    var unit = unit_scene.instantiate()
    unit.global_position = position
    unit.team = team
    
    # Add to groups
    unit.add_to_group("units")
    unit.add_to_group("team_%d" % team)
    
    add_child(unit)
    return unit

# Query units efficiently
func get_player_units() -> Array:
    return get_tree().get_nodes_in_group("team_0")

func get_units_in_radius(pos: Vector2, radius: float) -> Array:
    var units = get_tree().get_nodes_in_group("units")
    return units.filter(func(u): return u.global_position.distance_to(pos) < radius)
```

---

### Spatial Partitioning (for 50+ units)

#### Simple Grid Hash
```gdscript
# Global spatial hash manager
class_name SpatialHash
extends Node

var cell_size: float = 256.0  # 4 tiles × 64px
var grid: Dictionary = {}  # Key: Vector2i(cell_x, cell_y), Value: Array of units

func get_cell_id(position: Vector2) -> Vector2i:
    return Vector2i(
        int(position.x / cell_size),
        int(position.y / cell_size)
    )

func insert(unit: Unit):
    var cell = get_cell_id(unit.global_position)
    if not grid.has(cell):
        grid[cell] = []
    grid[cell].append(unit)

func remove(unit: Unit):
    var cell = get_cell_id(unit.global_position)
    if grid.has(cell):
        grid[cell].erase(unit)

func update_position(unit: Unit, old_pos: Vector2, new_pos: Vector2):
    var old_cell = get_cell_id(old_pos)
    var new_cell = get_cell_id(new_pos)
    if old_cell != new_cell:
        remove_from_cell(unit, old_cell)
        insert_to_cell(unit, new_cell)

func get_nearby_units(position: Vector2, radius: float = 256.0) -> Array:
    var cell = get_cell_id(position)
    var nearby = []
    
    # Check 3×3 grid around cell
    for x in range(-1, 2):
        for y in range(-1, 2):
            var check_cell = cell + Vector2i(x, y)
            if grid.has(check_cell):
                nearby.append_array(grid[check_cell])
    
    return nearby
```

**Performance:** O(1) insertion, O(k) query where k = entities in neighboring cells

---

### AI System

#### Three-State Machine
```gdscript
class_name AIController
extends Node

enum AIState { GATHER, BUILD, ATTACK }
var current_state: AIState = AIState.GATHER

# Parameters
var resource_threshold: int = 100
var attack_unit_count: int = 5

# References
var base: Structure = null
var workers: Array[Unit] = []
var military_units: Array[Unit] = []

func _process(delta):
    match current_state:
        AIState.GATHER:
            # Send workers to resources
            ensure_worker_count(3)
            if workers.size() >= 3:
                current_state = AIState.BUILD
                
        AIState.BUILD:
            # Queue military units
            if game.get_resources(ai_team) >= resource_threshold:
                queue_military_unit()
            if military_units.size() >= attack_unit_count:
                current_state = AIState.ATTACK
                
        AIState.ATTACK:
            # Send all military units to player base
            attack_move_all_units(player_base_position)
            # Return to BUILD after attack
            if military_units.size() < 2:
                current_state = AIState.BUILD

func ensure_worker_count(target: int):
    if workers.size() < target and can_afford_worker():
        build_worker()
```

---

### Input Handling

#### Selection System
```gdscript
class_name SelectionManager
extends Node2D

var selected_units: Array[Unit] = []
var selection_box: RectangleShape2D = null
var is_dragging: bool = false
var drag_start: Vector2

func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                # Start drag selection
                is_dragging = true
                drag_start = get_global_mouse_position()
                clear_selection()
            else:
                # End drag selection
                if is_dragging:
                    complete_drag_selection()
                is_dragging = false
                
        elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            # Context command (move/attack)
            issue_context_command(get_global_mouse_position())
    
    elif event is InputEventMouseMotion and is_dragging:
        # Update selection box visual
        update_selection_box(drag_start, get_global_mouse_position())

func complete_drag_selection():
    var rect = Rect2(drag_start, get_global_mouse_position() - drag_start).abs()
    for unit in get_tree().get_nodes_in_group("team_0"):  # Player units
        if rect.has_point(unit.global_position):
            select_unit(unit)
```

#### Control Groups
```gdscript
var control_groups: Dictionary = {}  # Key: int (1-0), Value: Array[Unit]

func _input(event):
    if event is InputEventKey and event.pressed:
        var key = event.keycode
        
        # Ctrl + Number: Assign control group
        if event.ctrl_pressed and key >= KEY_1 and key <= KEY_0:
            var group_num = key - KEY_1 if key != KEY_0 else 9
            control_groups[group_num] = selected_units.duplicate()
            
        # Number: Select control group
        elif key >= KEY_1 and key <= KEY_0:
            var group_num = key - KEY_1 if key != KEY_0 else 9
            if control_groups.has(group_num):
                clear_selection()
                for unit in control_groups[group_num]:
                    if is_instance_valid(unit):  # Check unit still exists
                        select_unit(unit)
```

---

### LLM Integration

#### Local LLM via Ollama (HTTP API)
```gdscript
class_name LLMInterface
extends Node

const OLLAMA_URL = "http://localhost:11434/api/generate"

func generate_mission_briefing(game_state: Dictionary) -> String:
    var prompt = """
    You are a military commander briefing your troops. The current situation:
    - Player faction: {faction}
    - Resources: {resources}
    - Completed missions: {completed_missions}
    - Enemy strength: {enemy_strength}
    
    Generate a brief 2-3 sentence mission briefing that adapts to this state.
    """.format(game_state)
    
    var response = await make_llm_request(prompt)
    return response

func make_llm_request(prompt: String) -> String:
    var http = HTTPRequest.new()
    add_child(http)
    
    var body = JSON.stringify({
        "model": "llama3.2:3b",
        "prompt": prompt,
        "stream": false,
        "options": {
            "temperature": 0.7,
            "num_predict": 100
        }
    })
    
    var headers = ["Content-Type: application/json"]
    http.request(OLLAMA_URL, headers, HTTPClient.METHOD_POST, body)
    
    var result = await http.request_completed
    var response_body = result[3].get_string_from_utf8()
    var json = JSON.parse_string(response_body)
    
    http.queue_free()
    return json["response"] if json else "Mission briefing unavailable."
```

#### AI Personality Taunts
```gdscript
func generate_taunt(ai_personality: Dictionary, game_event: String) -> String:
    var context = """
    You are an AI opponent with personality: {traits}
    Recent event: {event}
    
    Generate a short 1-sentence taunt that matches your personality.
    """.format({
        "traits": ai_personality["traits"],
        "event": game_event
    })
    
    return await make_llm_request(context)

# Example usage
var ai_personality = {
    "name": "Brutal Commander",
    "traits": ["aggressive", "arrogant", "impatient"]
}

# When player loses harvester
var taunt = await llm.generate_taunt(ai_personality, "Player lost a harvester to my attack")
display_taunt(taunt)  # "Your pathetic economy crumbles before my might!"
```

---

### Resource Management

#### Simple Resource System
```gdscript
class_name ResourceManager
extends Node

var resources_by_team: Dictionary = {
    0: 1000,  # Player starts with 1000
    1: 1000   # AI starts with 1000
}

signal resources_changed(team: int, amount: int)

func add_resources(team: int, amount: int):
    resources_by_team[team] += amount
    resources_changed.emit(team, resources_by_team[team])

func spend_resources(team: int, amount: int) -> bool:
    if resources_by_team[team] >= amount:
        resources_by_team[team] -= amount
        resources_changed.emit(team, resources_by_team[team])
        return true
    return false

func get_resources(team: int) -> int:
    return resources_by_team[team]
```

---

### UI System

#### HUD Scene Structure
```
HUD (CanvasLayer)
├─ ResourceDisplay (HBoxContainer)
│  ├─ ResourceIcon (TextureRect)
│  └─ ResourceLabel (Label)
├─ SelectionPanel (Panel)
│  ├─ UnitIcon (TextureRect)
│  ├─ UnitName (Label)
│  └─ HealthBar (ProgressBar)
├─ CommandPanel (HBoxContainer)
│  ├─ MoveButton (TextureButton)
│  ├─ AttackButton (TextureButton)
│  └─ StopButton (TextureButton)
└─ Minimap (Panel)
   └─ MinimapViewport (SubViewport)
```

#### Minimap Implementation
```gdscript
class_name Minimap
extends Control

@onready var viewport = $SubViewport
@onready var camera = $SubViewport/Camera2D

var map_size: Vector2
var minimap_size: Vector2 = Vector2(200, 200)

func _ready():
    # Setup minimap camera to show full map
    camera.zoom = map_size / minimap_size

func _process(delta):
    # Update unit positions on minimap
    queue_redraw()

func _draw():
    # Draw units as colored dots
    for unit in get_tree().get_nodes_in_group("units"):
        var minimap_pos = world_to_minimap(unit.global_position)
        var color = Color.BLUE if unit.team == 0 else Color.RED
        draw_circle(minimap_pos, 2, color)

func world_to_minimap(world_pos: Vector2) -> Vector2:
    return (world_pos / map_size) * minimap_size
```

---

### Build Queue System

#### Structure Production Queue
```gdscript
class_name Structure
extends StaticBody2D

var production_queue: Array[Dictionary] = []  # [{type: String, remaining_time: float}]
var current_production: Dictionary = {}

func queue_unit(unit_type: String, cost: int, build_time: float):
    if game.resource_manager.spend_resources(team, cost):
        production_queue.append({
            "type": unit_type,
            "remaining_time": build_time
        })
        
        if production_queue.size() == 1:
            start_production()

func _process(delta):
    if not current_production.is_empty():
        current_production["remaining_time"] -= delta
        
        if current_production["remaining_time"] <= 0:
            # Production complete!
            spawn_unit(current_production["type"])
            current_production = {}
            
            # Start next in queue
            if not production_queue.is_empty():
                start_production()

func start_production():
    current_production = production_queue.pop_front()

func cancel_production():
    if not current_production.is_empty():
        # Refund some resources (50%?)
        var refund = get_unit_cost(current_production["type"]) / 2
        game.resource_manager.add_resources(team, refund)
        current_production = {}
```

---

### Save/Load System (Day 2, if time permits)

#### Simple JSON Serialization
```gdscript
class_name SaveManager
extends Node

func save_game(slot: int = 0):
    var save_data = {
        "resources": game.resource_manager.resources_by_team,
        "units": [],
        "structures": []
    }
    
    # Serialize all units
    for unit in get_tree().get_nodes_in_group("units"):
        save_data["units"].append({
            "type": unit.unit_type,
            "position": [unit.global_position.x, unit.global_position.y],
            "hp": unit.current_hp,
            "team": unit.team
        })
    
    # Serialize all structures
    for structure in get_tree().get_nodes_in_group("structures"):
        save_data["structures"].append({
            "type": structure.structure_type,
            "position": [structure.global_position.x, structure.global_position.y],
            "hp": structure.current_hp,
            "team": structure.team
        })
    
    # Write to file
    var file = FileAccess.open("user://save_%d.json" % slot, FileAccess.WRITE)
    file.store_string(JSON.stringify(save_data, "\t"))
    file.close()

func load_game(slot: int = 0):
    var file = FileAccess.open("user://save_%d.json" % slot, FileAccess.READ)
    if not file:
        return false
    
    var json = JSON.parse_string(file.get_as_text())
    file.close()
    
    # Clear current game state
    clear_game()
    
    # Restore resources
    game.resource_manager.resources_by_team = json["resources"]
    
    # Spawn units
    for unit_data in json["units"]:
        spawn_unit(unit_data["type"], 
                   Vector2(unit_data["position"][0], unit_data["position"][1]),
                   unit_data["team"],
                   unit_data["hp"])
    
    # Spawn structures
    for structure_data in json["structures"]:
        spawn_structure(structure_data["type"],
                       Vector2(structure_data["position"][0], structure_data["position"][1]),
                       structure_data["team"],
                       structure_data["hp"])
    
    return true
```

---

## Performance Targets

### MVP (100-200 units)
- **Frame Rate:** 60 FPS on mid-range hardware
- **Unit Update:** Entity-Component-System pattern with Groups
- **Pathfinding:** Godot built-in A*, 500-node limit
- **Spatial:** Simple grid hash, 256px cells

### Post-MVP (200-500 units)
- **Spatial:** Quadtree if needed
- **Rendering:** Sprite batching, culling off-screen units
- **Pathfinding:** Flow fields if > 100 units moving simultaneously

---

## Development Workflow

### Day 1 Morning (Hours 0-3)
1. Create Godot project structure
2. Setup basic scenes (Main, Map, Unit, Structure)
3. Implement camera controls
4. Create tile system with test map

### Day 1 Afternoon (Hours 3-8)
1. Unit selection (click, drag-box)
2. Basic pathfinding (move command)
3. Simple collision
4. Resource system (display counter)

### Day 1 Evening (Hours 8-12)
1. Combat system (attack command, HP, death)
2. Basic AI (state machine)
3. One building (base/factory)

### Day 2 Morning (Hours 12-18)
1. Production queue
2. Win/lose conditions
3. Integration testing

### Day 2 Afternoon (Hours 18-24)
1. Visual polish (health bars, selection indicators)
2. UI (minimap, resource display, command panel)
3. Balance tweaking

---

## Critical Paths and Risks

### Risk: Pathfinding Performance
**Mitigation:** Use Godot's built-in Navigation2D, limit search nodes, cache paths

### Risk: Too Many Features
**Mitigation:** Strict MVP scope, cut features at Hour 16/30/38 checkpoints

### Risk: AI Too Dumb/Smart
**Mitigation:** Simple state machine, acceptable cheating (1.2x resources)

### Risk: Balance Issues
**Mitigation:** Use Dune II ratios as starting point, iterate quickly

---

## Post-MVP Roadmap

### Week 2: Core Expansion
- [ ] 3-5 more unit types
- [ ] 2-3 more buildings
- [ ] Basic tech tree (2 tiers)
- [ ] Faction differences

### Week 3: Polish and Features
- [ ] Procedural SVG unit generation tool
- [ ] LLM mission briefings
- [ ] AI personality taunts
- [ ] Multiple maps

### Month 2: Multiplayer Foundation
- [ ] Network architecture (ENet)
- [ ] Lobby system
- [ ] Basic multiplayer testing

---

## Conclusion

This architecture prioritizes:
✅ **Rapid prototyping** via Godot's built-in features
✅ **Performance** through smart caching and spatial partitioning
✅ **Maintainability** via clean scene hierarchy and typed GDScript
✅ **Scalability** from MVP (100 units) to full game (500+ units)

The key innovation is **procedural SVG generation at development time**, not runtime, avoiding the performance cliff while maintaining modern scalable graphics.
