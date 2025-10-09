# Resource Wars

A modern Dune II-inspired real-time strategy game featuring dynamic procedurally generated SVG graphics, AI LLM integration, and old-school 4X mechanics with modern quality-of-life features.

## 🎮 Project Overview

**Genre:** Real-Time Strategy (RTS) / 4X  
**Inspiration:** Dune II (1992), Command & Conquer, Total Annihilation  
**Target Audience:** Old-school RTS/4X players who want classic gameplay with modern polish  
**Development Timeline:** 2-day MVP → Expanded post-launch  
**Platforms:** Windows, macOS, Linux (desktop)

## ✨ Key Features

### Core Gameplay
- **Classic RTS mechanics** - Resource gathering, base building, unit production, military conquest
- **Asymmetric factions** - Three distinct factions with unique units and abilities
- **Dynamic maps** - Procedurally generated terrain with strategic resource placement
- **Environmental threats** - Natural hazards that shape tactical decisions

### Modern Enhancements
- **Quality-of-life controls** - Multi-unit selection, control groups, drag-box selection, attack-move
- **Procedural SVG graphics** - Infinitely scalable vector-based visuals with dynamic generation
- **LLM-powered AI** - Adaptive AI personalities with dynamic taunts and strategic behavior
- **Intelligent minimap** - Real-time overview with clickable navigation

### Innovation
- **"Resource Wars" theme** - Customizable resource types (Spice, Metals, Fuel, etc.)
- **Modern but faithful** - Respects Dune II's legacy while embracing contemporary technology
- **No microtransactions** - Pure gameplay experience
- **Offline-first** - Full single-player campaign, optional multiplayer

## 🛠️ Technology Stack

- **Engine:** Godot 4.x (MIT License)
- **Language:** GDScript (primary), Python (asset generation)
- **Graphics:** Procedural SVG → Rasterized PNG sprites
- **AI/LLM:** Ollama + Llama 3.2 3B (local inference)
- **Networking:** ENet (future multiplayer)
- **Version Control:** Git

## 📁 Project Structure

```
resource-wars/
├── docs/                          # Comprehensive documentation
│   ├── 01-dunedynasty-analysis.md    # Code reference from existing RTS
│   ├── 02-game-balance-reference.md   # Proven balance ratios
│   ├── 03-technical-architecture.md   # Implementation details
│   └── 04-getting-started.md          # Setup and development guide
├── godot-project/                 # Main Godot game project
│   ├── project.godot
│   ├── scenes/                    # Game scenes (Main, Unit, Structure, etc.)
│   ├── scripts/                   # GDScript game logic
│   └── assets/                    # Sprites, sounds, fonts
├── tools/                         # Asset generation tools
│   ├── generate_sprites.py        # SVG unit/structure generation
│   ├── generate_terrain.py        # Procedural map generation
│   └── build_assets.sh            # Rasterization build script
├── assets-source/                 # Source SVG files (pre-rasterization)
│   ├── units/                     # Unit sprites
│   ├── structures/                # Building sprites
│   └── terrain/                   # Terrain tiles
└── README.md                      # You are here!
```

## 🚀 Quick Start

### Prerequisites
1. **Godot 4.2+** - Download from [godotengine.org](https://godotengine.org/download)
2. **Python 3.10+** - Download from [python.org](https://www.python.org/downloads/)
3. **Ollama** (optional) - Download from [ollama.ai](https://ollama.ai/download)

### Installation

```bash
# Clone repository
git clone <repository-url>
cd resource-wars

# Install Python dependencies
pip install svgwrite cairosvg pillow noise

# (Optional) Setup Ollama for LLM features
ollama pull llama3.2:3b

# Generate initial sprites
cd tools
python generate_sprites.py
./build_assets.sh  # or build_assets.bat on Windows

# Open project in Godot
# File → Open Project → Select godot-project/project.godot
```

### First Run

1. Open `godot-project` in Godot Engine
2. Press **F5** or click the Play button
3. Test basic unit movement and selection

Detailed setup instructions: See [`docs/04-getting-started.md`](docs/04-getting-started.md)

## 📖 Documentation

Comprehensive documentation is available in the [`docs/`](docs/) folder:

1. **[Dune Dynasty Analysis](docs/01-dunedynasty-analysis.md)** - Leveraging existing RTS codebase for reference
2. **[Game Balance Reference](docs/02-game-balance-reference.md)** - Proven unit stats and economy ratios
3. **[Technical Architecture](docs/03-technical-architecture.md)** - Godot implementation patterns
4. **[Getting Started Guide](docs/04-getting-started.md)** - Setup and development workflow

## 🎯 Development Roadmap

### MVP (2 Days) - ✅ Current Focus
- [x] Project structure and documentation
- [ ] Basic unit movement and selection
- [ ] Simple combat system
- [ ] Resource gathering
- [ ] One building type
- [ ] Basic AI opponent
- [ ] Win/lose conditions

### Post-MVP (Week 2-4)
- [ ] 5-6 unit types
- [ ] 3-4 building types
- [ ] Tech tree (2-3 tiers)
- [ ] Faction differences
- [ ] LLM-generated mission briefings
- [ ] Multiple procedural maps

### Future (Month 2+)
- [ ] Campaign mode
- [ ] Multiplayer foundation
- [ ] Map editor
- [ ] Advanced AI behaviors
- [ ] Modding support

## 🎮 Gameplay Overview

### The 4X Loop
1. **eXplore** - Scout the map, find resource deposits
2. **eXpand** - Build bases, claim territory
3. **eXploit** - Harvest resources, build economy
4. **eXterminate** - Destroy enemy forces and structures

### Core Mechanics
- **Resources** - Gather to fund military and expansion
- **Base Building** - Construct buildings with dependencies
- **Unit Production** - Queue military units with build times
- **Combat** - Strategic positioning and unit counters
- **Tech Progression** - Unlock advanced units and abilities

### Factions (Planned)
- **Faction A (Balanced)** - Well-rounded units, defensive superweapon
- **Faction B (Aggressive)** - Expensive but powerful, offensive superweapon
- **Faction C (Tactical)** - Speed and tricks, infiltration abilities

## 🤝 Contributing

This is currently a personal project, but contributions are welcome!

**Areas of interest:**
- Unit sprite designs (SVG)
- Balance testing and feedback
- Bug reports and fixes
- Documentation improvements

**Development principles:**
- Fully functional solutions only (no workarounds)
- Complete files (no partial implementations)
- Test before committing
- Document complex logic

## 📝 License

*To be determined - likely MIT or GPL-compatible*

Game code and original assets will be open source.  
Inspired by Dune II but contains no copyrighted assets from the original game.

## 🙏 Acknowledgments

### Inspiration
- **Westwood Studios** - Dune II (1992), the original RTS
- **OpenDUNE Project** - Reverse-engineered Dune II engine
- **Dune Dynasty** - Enhanced Dune II remake (reference codebase)

### Technology
- **Godot Engine** - Open-source game engine
- **Ollama** - Local LLM inference
- **Allegro/ENet** - Networking libraries

### Community
- Old-school RTS players who keep the genre alive
- Godot community for excellent documentation
- RTS game developers who share their knowledge

---

## 📧 Contact

For questions, feedback, or collaboration:
- **GitHub Issues** - Bug reports and feature requests
- **Project Docs** - See `docs/` folder for detailed information

---

**"He who controls the Spice, controls the universe!"** 🪐

*Built with ❤️ for old-school RTS fans*
