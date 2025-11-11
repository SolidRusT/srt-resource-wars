# Resource Wars: Dependency Structure

This document explains the different Python dependency contexts in this project.

---

## Overview

Resource Wars uses Python in **three distinct contexts**, each with different dependencies:

```
resource-wars/
├── tools/requirements.txt          # Asset generation (dev-time only)
├── requirements-dev.txt            # Development tools (optional)
└── requirements-runtime.txt        # Game runtime (if needed, future)
```

---

## 1. Tools Dependencies (`tools/requirements.txt`)

**Purpose:** Asset generation and preprocessing  
**Used by:** Developers during asset creation  
**When:** Development time, before building the game  
**Required for:** Players/end-users? **NO**

### Current Dependencies:

```txt
# SVG Generation
svgwrite>=1.4.3              # Create vector graphics programmatically

# SVG to PNG Conversion
cairosvg>=2.7.0              # Best quality (requires C library)
svglib>=1.5.1                # Pure Python alternative
reportlab>=4.0.0             # Required by svglib

# Image Processing
Pillow>=10.0.0               # Image manipulation, fallback conversion

# Procedural Generation
noise>=1.2.2                 # Perlin noise for terrain generation
```

### Installation:
```bash
cd tools
pip install -r requirements.txt
```

### Usage:
- Generate SVG sprites: `python generate_sprites.py`
- Rasterize to PNG: `python rasterize_sprites.py`
- Generate terrain: `python generate_terrain.py` (future)

---

## 2. Development Dependencies (`requirements-dev.txt`)

**Purpose:** Development tools, testing, documentation  
**Used by:** Developers during coding  
**When:** Development time, for code quality  
**Required for:** Players/end-users? **NO**

### Planned Dependencies:

```txt
# Testing
pytest>=7.4.0                # Unit testing framework
pytest-cov>=4.1.0            # Code coverage
pytest-mock>=3.11.1          # Mocking for tests

# Code Quality
black>=23.7.0                # Code formatter
flake8>=6.1.0                # Linter
mypy>=1.5.0                  # Type checking
isort>=5.12.0                # Import sorting

# Documentation
sphinx>=7.1.0                # Documentation generator
sphinx-rtd-theme>=1.3.0      # ReadTheDocs theme

# Git Hooks (optional)
pre-commit>=3.3.0            # Git pre-commit hooks
```

### Installation (when needed):
```bash
pip install -r requirements-dev.txt
```

### Usage:
- Run tests: `pytest`
- Format code: `black .`
- Lint code: `flake8 .`
- Build docs: `sphinx-build docs/ docs/_build/`

**Status:** Not created yet (will add when we start testing)

---

## 3. Runtime Dependencies (`requirements-runtime.txt`)

**Purpose:** Game runtime features (if Python is used at runtime)  
**Used by:** The game when running  
**When:** Runtime, when players play the game  
**Required for:** Players/end-users? **Only if features are used**

### Potential Future Dependencies:

```txt
# LLM Integration (optional)
requests>=2.31.0             # HTTP client for Ollama API
aiohttp>=3.8.5               # Async HTTP (if using async)

# Multiplayer Backend (if Python server)
flask>=2.3.0                 # Web server
flask-socketio>=5.3.0        # WebSocket support
python-socketio>=5.9.0       # Socket.IO client/server

# Analytics (optional)
psutil>=5.9.0                # System resource monitoring
```

### Current Status: **NONE NEEDED YET**

The game currently runs entirely in Godot with GDScript. Python is only used for asset generation (development time).

### Future Scenarios That Would Need Runtime Dependencies:

1. **Local LLM Integration (Ollama)**
   - IF: We implement Python middleware between Godot and Ollama
   - THEN: Need `requests` or `aiohttp`
   - ALTERNATIVE: Godot can call HTTP directly (no Python needed!)

2. **Multiplayer Server**
   - IF: We implement a Python-based game server
   - THEN: Need `flask`, `socketio`, etc.
   - ALTERNATIVE: Use Godot's built-in networking (ENet)

3. **Procedural Content at Runtime**
   - IF: We generate maps/content while game is running
   - THEN: Need `noise` library at runtime
   - ALTERNATIVE: Pre-generate maps, save as JSON

**Decision:** For MVP, we're doing ALTERNATIVES (Godot-native), so no runtime Python dependencies needed.

---

## 4. Root `requirements.txt` (Optional)

**Purpose:** Quick setup for all development dependencies  
**Strategy:** Aggregate all dev-time dependencies

### Option A: Single Unified File

```txt
# Resource Wars - Complete Development Environment
# Install with: pip install -r requirements.txt

# Include all development dependencies
-r tools/requirements.txt
-r requirements-dev.txt
```

**Pros:** One command to install everything  
**Cons:** Installs testing tools even if you just want to generate assets

### Option B: Separate Files (RECOMMENDED)

Keep them separate:
- `tools/requirements.txt` - Asset generation only
- `requirements-dev.txt` - Testing and code quality
- `requirements-runtime.txt` - Game runtime (if needed)

**Pros:** Install only what you need  
**Cons:** Need to know which file to use

---

## Current Project State

```
✅ tools/requirements.txt        - EXISTS (asset generation)
❌ requirements-dev.txt           - NOT CREATED (not needed yet)
❌ requirements-runtime.txt       - NOT NEEDED (Godot-native approach)
❌ root requirements.txt          - NOT CREATED (not needed, use tools/)
```

---

## Installation Guide

### For Asset Generation (Always Required for Developers)

```bash
cd C:\Users\shaun\repos\resource-wars\tools
pip install -r requirements.txt
```

This installs:
- SVG generation tools
- Image conversion tools
- Procedural generation tools

### For Game Development (No Python Needed!)

The game itself runs in Godot and uses GDScript. No Python installation required to:
- Run the game
- Edit scenes
- Write GDScript code
- Test gameplay

### For Testing (Future)

When we add unit tests:
```bash
cd C:\Users\shaun\repos\resource-wars
pip install -r requirements-dev.txt
```

### For End Users (No Python Needed!)

When we distribute the game:
- **Players DO NOT need Python**
- **Players DO NOT need any dependencies**
- Game is exported as standalone executable
- All assets are pre-generated and bundled

---

## Dependency Decision Tree

```
┌─────────────────────────────────────┐
│   What are you trying to do?       │
└─────────────────────────────────────┘
           │
           ├─ Generate sprites/assets
           │  └─> tools/requirements.txt
           │
           ├─ Run tests / lint code
           │  └─> requirements-dev.txt (future)
           │
           ├─ Play/develop the game
           │  └─> No Python needed! Use Godot.
           │
           └─ Distribute to players
              └─> No Python needed! Export from Godot.
```

---

## Virtual Environment Strategy

### Recommended Setup

```bash
# Create project-wide venv
cd C:\Users\shaun\repos\resource-wars
python -m venv venv

# Activate it
venv\Scripts\activate

# Install only what you need
pip install -r tools/requirements.txt
```

### Why One Venv for Whole Project?

**Pros:**
- ✓ Simpler to manage
- ✓ All tools available everywhere
- ✓ One activation command

**Cons:**
- Might install unused dependencies

**Decision:** Use project-wide venv (`resource-wars/venv/`) for simplicity.

---

## Package Version Philosophy

### Current Strategy: Minimum Versions (`>=`)

```txt
svgwrite>=1.4.3
```

**Meaning:** Use version 1.4.3 or any newer version

**Pros:**
- ✓ Get bug fixes automatically
- ✓ Compatible with other projects

**Cons:**
- Might break if library changes API

### Alternative: Pinned Versions (`==`)

```txt
svgwrite==1.4.3
```

**Meaning:** Use exactly version 1.4.3

**Pros:**
- ✓ Guaranteed reproducibility
- ✓ No surprise breaks

**Cons:**
- Miss out on bug fixes
- Need to manually update

### Our Choice: Minimum Versions for Now

Reason: We're in active development, want latest features. Will pin versions before 1.0 release.

---

## Future Considerations

### When to Add requirements-dev.txt?

**Trigger:** When we start writing Python tests for our asset generation scripts

**Contents:**
- pytest for testing
- black for formatting
- flake8 for linting

### When to Add requirements-runtime.txt?

**Trigger:** Only if we decide to use Python at game runtime

**Current Plan:** DON'T. Keep game pure Godot/GDScript.

**Exception Scenarios:**
1. LLM integration becomes too complex for Godot's HTTP
2. We need Python for multiplayer matchmaking server
3. We implement server-side anti-cheat

---

## Best Practices

### ✅ DO:
- Keep tool dependencies separate from game dependencies
- Use virtual environments
- Document what each dependency is for
- Update dependencies periodically

### ❌ DON'T:
- Install runtime dependencies unless actually needed
- Mix development and runtime dependencies
- Use root requirements.txt as a dumping ground
- Install packages globally (always use venv)

---

## Quick Reference

| File | Purpose | Install When | Required For Game? |
|------|---------|--------------|-------------------|
| `tools/requirements.txt` | Asset generation | Developing assets | No |
| `requirements-dev.txt` | Testing/QA | Writing tests | No |
| `requirements-runtime.txt` | Game runtime | Using Python features | Maybe |
| Root `requirements.txt` | Convenience | Quick dev setup | No |

---

## Conclusion

**Current State:**
- ✅ `tools/requirements.txt` - Complete and working
- ❌ Other requirement files - Not needed yet

**For MVP:**
- Only `tools/requirements.txt` is required
- Game runs entirely in Godot (no runtime Python)
- Players need zero Python dependencies

**Future:**
- Will add `requirements-dev.txt` when we write tests
- Will add `requirements-runtime.txt` only if we implement Python-based features

**Your Next Step:**
```bash
cd tools
pip install svglib reportlab  # Fix the Cairo issue
python rasterize_sprites.py   # Generate PNG assets
```

---

*Last Updated: 2025-10-08*
