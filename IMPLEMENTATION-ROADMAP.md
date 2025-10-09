# Resource Wars: Implementation Roadmap

**Status:** Asset generation tools created, Godot project initialized  
**Date:** October 8, 2025  
**Next Phase:** Generate assets and begin core implementation

---

## ✅ Completed Steps

1. [x] Documentation structure created
2. [x] Repository initialized with Git
3. [x] Python sprite generation tool created (`tools/generate_sprites.py`)
4. [x] Asset rasterization scripts created (Windows + Linux)
5. [x] Godot project structure initialized
6. [x] Basic project configuration complete

---

## 🎯 Immediate Next Steps (Next 30 Minutes)

### Step 1: Install Python Dependencies

```bash
cd C:\Users\shaun\repos\resource-wars\tools
pip install -r requirements.txt
```

**Required packages:**
- `svgwrite` - SVG generation
- `cairosvg` - SVG to PNG conversion
- `Pillow` - Image processing
- `noise` - Procedural generation

### Step 2: Generate SVG Assets

```bash
cd C:\Users\shaun\repos\resource-wars\tools
python generate_sprites.py
```

**Expected output:**
- 6 unit sprites (worker, soldier, tank × 2 teams)
- 6 structure sprites (base, factory, refinery × 2 teams)
- 1 resource sprite (crystal)
- Total: 13 SVG files

### Step 3: Rasterize to PNG

```bash
cd C:\Users\shaun\repos\resource-wars\tools
build_assets.bat
```

**Expected output:**
- PNG sprites in `godot-project/assets/sprites/`
- Units: 64×64 pixels
- Structures: 128×128 pixels
- Resources: 64×64 pixels

### Step 4: Open Project in Godot

1. Launch Godot Engine (from wherever you built it)
2. Click "Import"
3. Navigate to `C:\Users\shaun\repos\resource-wars\godot-project`
4. Select `project.godot`
5. Click "Import & Edit"

---

## 📋 Hour-by-Hour Development Plan

### **Hour 1-3: Core Scene Setup**

#### Tasks:
- [x] Create main scene (`scenes/main.tscn`)
- [ ] Add Camera2D with movement controls
- [ ] Create TileMap for terrain
- [ ] Setup basic scene hierarchy

#### Priority: CRITICAL
**Checkpoint:** Camera moves with WASD, scene loads without errors

---

### **Hour 4-6: Unit Foundation**

#### Tasks:
- [ ] Create Unit scene (`scenes/unit.tscn`)
- [ ] Implement Unit script (`scripts/unit.gd`)
- [ ] Add sprite rendering with team colors
- [ ] Basic movement with pathfinding
- [ ] Collision detection

#### Files to Create:
```
scenes/
  └── unit.tscn
scripts/
  └── unit.gd
```

#### Priority: CRITICAL
**Checkpoint:** Can spawn units, they render correctly with sprites

---

### **Hour 7-9: Selection System**

#### Tasks:
- [ ] Implement SelectionManager (`scripts/selection_manager.gd`)
- [ ] Click selection (single unit)
- [ ] Drag-box selection (multiple units)
- [ ] Visual feedback (selection ring/highlight)
- [ ] Selection state management

#### Priority: CRITICAL
**Checkpoint:** Can select units by clicking or dragging

---

### **Hour 10-12: Movement Commands**

#### Tasks:
- [ ] Right-click move command
- [ ] Pathfinding integration (NavigationRegion2D)
- [ ] Multiple unit movement
- [ ] Unit collision avoidance

#### Priority: CRITICAL
**Checkpoint:** Selected units move to right-click location

---

### **Hour 13-15: Resource System**

#### Tasks:
- [ ] Create ResourceManager (`scripts/resource_manager.gd`)
- [ ] Resource deposit spawning
- [ ] Worker harvesting behavior
- [ ] Resource UI display
- [ ] Resource collection logic

#### Priority: HIGH
**Checkpoint:** Workers can harvest resources, counter updates

---

### **Hour 16-18: Combat System** ⚠️ CRITICAL CHECKPOINT

#### Tasks:
- [ ] Attack command implementation
- [ ] HP and damage system
- [ ] Death and unit removal
- [ ] Visual feedback (damage numbers, death animation)

#### Priority: HIGH
**Checkpoint Decision Point:**
- **If ON SCHEDULE:** Continue with combat
- **If BEHIND:** Consider cutting combat, make resource-only game

---

### **Hour 19-21: Building System**

#### Tasks:
- [ ] Create Structure scene (`scenes/structure.tscn`)
- [ ] Structure script (`scripts/structure.gd`)
- [ ] Production queue system
- [ ] Unit spawning from structures
- [ ] Build UI

#### Priority: HIGH
**Checkpoint:** Can build at least one building, produce units

---

### **Hour 22-25: AI Opponent**

#### Tasks:
- [ ] Create AIController (`scripts/ai_controller.gd`)
- [ ] Three-state machine (GATHER/BUILD/ATTACK)
- [ ] Worker management
- [ ] Military production
- [ ] Attack wave logic

#### Priority: HIGH
**Checkpoint:** AI gathers resources, builds units, attacks player

---

### **Hour 26-28: Win/Lose Conditions**

#### Tasks:
- [ ] Game state management
- [ ] Victory detection (destroy enemy base)
- [ ] Defeat detection (player base destroyed)
- [ ] Game over screen
- [ ] Restart functionality

#### Priority: CRITICAL
**Checkpoint:** Game has clear win/lose states

---

### **Hour 29-32: UI Polish** ⚠️ CRITICAL CHECKPOINT

#### Tasks:
- [ ] HUD creation (`scenes/hud.tscn`)
- [ ] Resource display
- [ ] Selection panel
- [ ] Command panel
- [ ] Basic minimap

#### Priority: MEDIUM
**Checkpoint:** Game is playable and understandable

---

### **Hour 33-36: Integration Testing**

#### Tasks:
- [ ] Full playthrough testing
- [ ] Bug fixing
- [ ] Balance tweaking
- [ ] Performance optimization
- [ ] Edge case handling

#### Priority: CRITICAL
**Checkpoint:** Can complete a full game without crashes

---

### **Hour 37-40: Final Polish** ⚠️ FINAL CHECKPOINT

#### Tasks:
- [ ] Visual polish (health bars, effects)
- [ ] Audio (if time permits)
- [ ] Menu system
- [ ] Settings
- [ ] Final bug fixes

#### Priority: LOW-MEDIUM
**Checkpoint:** Game feels complete, no critical bugs

---

### **Hour 41-48: Buffer & Documentation**

#### Tasks:
- [ ] Additional testing
- [ ] README updates
- [ ] Known issues documentation
- [ ] Future roadmap planning
- [ ] Git commit cleanup

---

## 🚨 Emergency Scope Cuts

### If Behind at Hour 16
**CUT:** Combat system entirely  
**PIVOT:** Pure economy/building game  
**KEEP:** Movement, selection, resource gathering, building

### If Behind at Hour 26
**CUT:** AI opponent  
**PIVOT:** 1v1 local multiplayer (same computer)  
**KEEP:** All core systems, manual testing

### If Behind at Hour 37
**CUT:** All polish features  
**DELIVER:** Minimal but functional MVP  
**POST-LAUNCH:** Add polish incrementally

---

## 📁 File Structure to Create

```
godot-project/
├── project.godot                 [✓ DONE]
├── icon.svg                      [✓ DONE]
├── scenes/
│   ├── main.tscn                 [ ] TODO - Hour 1
│   ├── unit.tscn                 [ ] TODO - Hour 4
│   ├── structure.tscn            [ ] TODO - Hour 19
│   └── hud.tscn                  [ ] TODO - Hour 29
├── scripts/
│   ├── game_manager.gd           [ ] TODO - Hour 1
│   ├── unit.gd                   [ ] TODO - Hour 4
│   ├── selection_manager.gd      [ ] TODO - Hour 7
│   ├── resource_manager.gd       [ ] TODO - Hour 13
│   ├── structure.gd              [ ] TODO - Hour 19
│   └── ai_controller.gd          [ ] TODO - Hour 22
└── assets/
    └── sprites/                  [ ] PENDING - Generate next!
```

---

## 🎨 Asset Generation Checklist

- [ ] Run `pip install -r requirements.txt` in tools directory
- [ ] Run `python generate_sprites.py` in tools directory
- [ ] Run `build_assets.bat` in tools directory
- [ ] Verify PNG files exist in `godot-project/assets/sprites/`
- [ ] Open Godot project and verify assets import correctly

---

## 🧪 Testing Strategy

### Hour 8 Test (Basic Functionality)
```
[ ] Can spawn units programmatically
[ ] Units render with correct sprites
[ ] Can select units by clicking
[ ] Can drag-select multiple units
[ ] Can move units with right-click
```

### Hour 16 Test (Core Loop) - CRITICAL
```
[ ] Workers can harvest resources
[ ] Resources increment correctly
[ ] Can build a structure
[ ] Structure produces units
[ ] Units can attack (if implemented)
[ ] Units die at 0 HP (if implemented)
```

### Hour 28 Test (Full Game)
```
[ ] AI builds workers
[ ] AI gathers resources
[ ] AI produces military units
[ ] AI attacks player
[ ] Game detects victory
[ ] Game detects defeat
```

### Hour 38 Test (Polish) - FINAL
```
[ ] Game feels responsive
[ ] UI shows all necessary info
[ ] No crashes during 10-minute play
[ ] Frame rate acceptable (>30 FPS)
[ ] Game is understandable without tutorial
```

---

## 🐛 Common Issues & Solutions

### Issue: "cairosvg not found"
**Solution:** 
```bash
pip install cairosvg
# On Windows, may need: pip install cairocffi
```

### Issue: Godot won't import project
**Solution:**
- Verify `project.godot` exists
- Check Godot version is 4.2+
- Try "Import" instead of "Open"

### Issue: Assets not showing in Godot
**Solution:**
- Check PNG files exist in correct directories
- Reimport: Project → Reimport Assets
- Restart Godot editor

### Issue: Units not moving
**Solution:**
- Verify NavigationRegion2D exists
- Check NavigationAgent2D is child of unit
- Ensure navigation mesh is baked

### Issue: Performance problems
**Solution:**
- Check unit count (should be <100 for MVP)
- Use profiler: Debug → Profiler
- Disable debug collision shapes
- Implement spatial hash if needed

---

## 💡 Development Tips

### Commit Strategy
```bash
# Every 2-3 hours
git add .
git commit -m "Hour X: [Feature] - [Status]"
git push

# Examples:
git commit -m "Hour 4: Unit foundation - Basic rendering works"
git commit -m "Hour 16: CHECKPOINT - Core loop functional"
```

### Debug Workflow
```gdscript
# Use print() liberally
print("Unit position:", global_position)
print("Target:", target_position)
print("State:", current_state)

# Use breakpoints (F9 in script editor)
# Step through with F10 (next line), F11 (step into)
```

### Scene Testing
```
F6 - Run current scene (test individual systems)
F5 - Run full project (integration testing)
```

---

## 📚 Reference Documents

When implementing features, consult:

- **Unit Implementation** → `docs/01-dunedynasty-analysis.md` (Section 2)
- **Game Balance** → `docs/02-game-balance-reference.md`
- **Technical Patterns** → `docs/03-technical-architecture.md`
- **Quick Reference** → `CHEATSHEET.md`

---

## 🎯 Success Criteria for MVP

### Must Have (Non-Negotiable)
- [x] Units can move and be selected
- [ ] Resource gathering works
- [ ] Can build structures
- [ ] Structures produce units
- [ ] AI opponent functions
- [ ] Clear win/lose conditions

### Should Have (Cut if Necessary)
- [ ] Combat system
- [ ] Multiple unit types
- [ ] Visual polish
- [ ] Sound effects

### Nice to Have (Post-MVP)
- [ ] LLM integration
- [ ] Advanced AI
- [ ] Multiple maps
- [ ] Faction differences

---

## 🚀 Ready to Start!

**Your immediate action items:**

1. ✅ Read this document
2. ⬜ Install Python dependencies
3. ⬜ Generate sprites
4. ⬜ Rasterize to PNG
5. ⬜ Open Godot project
6. ⬜ Start Hour 1 implementation

**Estimated time to first playable prototype:** 16-20 hours  
**Estimated time to MVP:** 36-48 hours

---

**Let's build Resource Wars!** 🚀

*Remember: Progress over perfection. Ship the MVP first, polish later.*

*Last Updated: 2025-10-08*
