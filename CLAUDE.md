# CLAUDE.md - Resource Wars Game Server Agent Context

**Project**: Resource Wars - Dune II-inspired RTS game server on SRT-HQ Kubernetes platform
**Status**: In Development (MVP phase) - Game server infrastructure ready
**Server Type**: Godot 4.x Headless Server (Multiplayer)
**Last Updated**: 2025-11-10
**Shaun's Golden Rule**: **No workarounds, no temporary fixes, no disabled functionality. Full solutions only.**

---

## ⚡ AGENT QUICK START

**Your job**: Help with Resource Wars game server - a Godot 4.x headless multiplayer server on Kubernetes.

**Shaun's top rule**: No workarounds, no temporary fixes, complete solutions only.

**What this is**:
- Godot 4.x RTS game (Dune II-inspired)
- Headless server mode (no display, multiplayer only)
- Desktop clients connect to K8s-hosted server
- LoadBalancer service (not HTTP/Ingress)
- Uses UDP/TCP game ports (not HTTPS)

**Where to start**:
1. Read "Project Overview" below
2. Understand this is a GAME SERVER (not a web app)
3. No Ingress, no SSL certificates (game protocol)
4. Reference ChromaDB for platform capabilities
5. Check main game repo for game logic and mechanics

---

## 📚 PLATFORM INTEGRATION (ChromaDB Knowledge Base)

**When working in this submodule**, you cannot access the parent srt-hq-k8s repository files. Use ChromaDB to query platform capabilities and integration patterns.

**Collection**: `srt-hq-k8s-platform-guide` (43 docs, updated 2025-11-10)

**Why This Matters for Resource Wars**:
The game server runs on the SRT-HQ Kubernetes platform and needs:
- MetalLB LoadBalancer for external IP assignment
- Persistent storage for server state (future)
- Monitoring integration (future)
- Platform deployment conventions

**Query When You Need**:
- Platform architecture and three-tier taxonomy
- MetalLB LoadBalancer service patterns
- Storage classes for persistent game state
- Monitoring and logging integration
- Platform networking capabilities

**Example Queries**:
```
"What is the srt-hq-k8s platform architecture?"
"How does MetalLB LoadBalancer work?"
"What storage classes are available for game state?"
"How do I integrate with platform monitoring?"
```

**When NOT to Query**:
- ❌ Godot game development (see main game repo)
- ❌ Game logic and mechanics (see game README.md and docs/)
- ❌ Docker build process (use build-and-push.ps1)
- ❌ RTS gameplay features (see main game repository)

---

## 📍 PROJECT OVERVIEW

**Game Type**: Real-Time Strategy (RTS) / 4X - Dune II-inspired
**Engine**: Godot 4.x (MIT License)
**Language**: GDScript (primary), Python (asset generation)
**Server Mode**: Headless (no display, multiplayer only)
**Development Status**: MVP phase - server infrastructure ready, game logic in progress

**Key Features (Game)**:
- Classic RTS mechanics (resource gathering, base building, unit production)
- Asymmetric factions with unique units
- Procedurally generated SVG graphics
- LLM-powered AI personalities (local Ollama)
- Dynamic maps and environmental threats

**Deployment Model**:
- **Game Server**: Runs in Kubernetes (this deployment)
- **Game Clients**: Desktop applications (Windows/macOS/Linux)
- **Networking**: ENet protocol (UDP/TCP)
- **Connection**: Clients connect to LoadBalancer external IP

---

## 🗂️ LOCATIONS

**Repository**:
- GitHub: `git@github.com:SolidRusT/srt-resource-wars.git`
- Submodule: `/mnt/c/Users/shaun/repos/srt-hq-k8s/manifests/apps/resource-wars/`
- Standalone: `/mnt/c/Users/shaun/repos/srt-resource-wars/`

**Deployment**:
- Game Dev: Godot Editor → F5 (local testing)
- Docker Test: `docker run -p 9999:9999/udp suparious/resource-wars:latest`
- Production: K8s namespace `resource-wars`, LoadBalancer service

**Images**:
- Docker Hub: `suparious/resource-wars:latest`
- Public URL: `https://hub.docker.com/r/suparious/resource-wars`

**Server Access**:
- External IP: Assigned by MetalLB (check `kubectl get svc -n resource-wars`)
- Game Port: 9999/UDP (ENet game traffic)
- Status Port: 9998/TCP (server query/status, if implemented)

---

## 🛠️ TECH STACK

### Game Server (Godot Headless)
- **Engine**: Godot 4.2+ (headless mode)
- **Networking**: ENet (built into Godot)
- **Protocol**: UDP primary, TCP fallback
- **Ports**: 9999 (game), 9998 (status)
- **Resources**: 500m-2000m CPU, 512Mi-2Gi memory

### Docker (Multi-Stage Build)
- **Builder**: barichello/godot-ci:4.2.2 (Godot export)
- **Runtime**: ubuntu:22.04 (minimal dependencies)
- **Export Target**: Linux/X11 headless
- **Build Time**: ~5-10 minutes (Godot export + dependencies)

### Kubernetes
- **Service Type**: LoadBalancer (MetalLB)
- **Replicas**: 1 (game servers typically single instance per lobby)
- **Namespace**: `resource-wars`
- **Ingress**: None (game protocol, not HTTP)
- **Certificate**: None (game protocol, not HTTPS)

---

## 📁 PROJECT STRUCTURE

```
resource-wars/
├── godot-project/                 # Main Godot game project
│   ├── project.godot
│   ├── scenes/                    # Game scenes
│   ├── scripts/                   # GDScript game logic
│   └── assets/                    # Sprites, sounds, fonts
├── docs/                          # Game documentation
│   ├── 01-dunedynasty-analysis.md
│   ├── 02-game-balance-reference.md
│   ├── 03-technical-architecture.md
│   └── 04-getting-started.md
├── tools/                         # Asset generation (Python)
│   ├── generate_sprites.py
│   └── generate_terrain.py
├── assets-source/                 # Source SVG files
│   ├── units/
│   └── structures/
├── k8s/                           # Kubernetes manifests (submodule only)
│   ├── 01-namespace.yaml
│   ├── 02-deployment.yaml
│   └── 03-service.yaml
├── Dockerfile                     # Multi-stage build (submodule only)
├── .dockerignore                  # Docker build exclusions (submodule only)
├── build-and-push.ps1             # Docker build script (submodule only)
├── deploy.ps1                     # Kubernetes deployment (submodule only)
├── CLAUDE.md                      # This file (submodule only)
├── README-K8S.md                  # Deployment guide (submodule only)
├── README.md                      # Game documentation
└── PROJECT-SUMMARY.md             # Game project overview
```

**Note**: Files marked "submodule only" exist in the K8s deployment submodule but NOT in the main game repository.

---

## 🚀 DEVELOPMENT WORKFLOW

### Local Game Development

```bash
# Work in main game repository
cd /mnt/c/Users/shaun/repos/srt-resource-wars

# Install Python dependencies (for asset generation)
pip install svgwrite cairosvg pillow noise

# Generate sprites
cd tools
python generate_sprites.py

# Open in Godot Editor
# File → Open Project → Select godot-project/project.godot

# Test locally (F5 in Godot)
```

### Server Testing (Docker)

```bash
# Work in submodule
cd /mnt/c/Users/shaun/repos/srt-hq-k8s/manifests/apps/resource-wars

# Build server image
.\build-and-push.ps1

# Test server locally
docker run --rm -p 9999:9999/udp -p 9998:9998/tcp suparious/resource-wars:latest

# Connect game client to localhost:9999
```

### Production Deployment

```bash
# Work in submodule
cd /mnt/c/Users/shaun/repos/srt-hq-k8s/manifests/apps/resource-wars

# Build and push to Docker Hub
.\build-and-push.ps1 -Login -Push

# Deploy to Kubernetes
.\deploy.ps1

# Or build + push + deploy in one command
.\deploy.ps1 -Build -Push
```

---

## 📋 DEPLOYMENT

### Quick Deploy (Recommended)

```powershell
# Full deployment (build, push, deploy)
.\deploy.ps1 -Build -Push

# Deploy only (uses existing Docker Hub image)
.\deploy.ps1

# Uninstall
.\deploy.ps1 -Uninstall
```

### Manual Deployment

```bash
# Build and push Docker image
docker build -t suparious/resource-wars:latest .
docker push suparious/resource-wars:latest

# Deploy to cluster
kubectl apply -f k8s/

# Verify deployment
kubectl get all -n resource-wars
kubectl get svc -n resource-wars -o wide

# Get external IP
kubectl get svc resource-wars-server -n resource-wars
```

---

## 🔧 COMMON TASKS

### View Logs

```bash
# Server logs
kubectl logs -n resource-wars -l app=resource-wars -f

# Specific pod
kubectl logs -n resource-wars <pod-name> -f
```

### Update Deployment

```bash
# Restart server (pull latest image)
kubectl rollout restart deployment/resource-wars-server -n resource-wars

# Watch rollout status
kubectl rollout status deployment/resource-wars-server -n resource-wars
```

### Check Server Status

```bash
# Get LoadBalancer external IP
kubectl get svc resource-wars-server -n resource-wars

# Check server accessibility (if status port implemented)
nc -zv <EXTERNAL-IP> 9998
```

### Troubleshooting

```bash
# Check pod status
kubectl get pods -n resource-wars

# Describe pod (events and errors)
kubectl describe pod -n resource-wars <pod-name>

# Check LoadBalancer service
kubectl describe svc resource-wars-server -n resource-wars

# Check if MetalLB assigned IP
kubectl get svc -n resource-wars -o wide
```

---

## 🎯 USER PREFERENCES (CRITICAL)

### Solutions
- ✅ **Complete, working solutions** - Every change must be immediately deployable
- ✅ **Direct execution** - Use available tools, verify in real-time
- ✅ **No back-and-forth** - Show results, iterate to solution
- ❌ **NO workarounds** - If symptoms remain, keep digging for root cause
- ❌ **NO temporary files** - All code is production code
- ❌ **NO disabled functionality** - Don't hack around errors, fix them
- ✅ **Git as source of truth** - All changes in code, nothing manual

### Code Quality
- Full files, never patch fragments (unless part of strategy)
- Scripts work on first run (no retry logic needed)
- Documentation before infrastructure
- Reproducibility via automation

---

## 🏗️ BUILD PROCESS

### Multi-Stage Docker Build

**Stage 1: Exporter** (barichello/godot-ci:4.2.2)
1. Copy Godot project files
2. Export project for Linux/X11 (headless)
3. Output: `resource-wars-server.x86_64` executable

**Stage 2: Runtime** (ubuntu:22.04)
1. Install runtime dependencies (libGL, libX11, etc.)
2. Copy exported game server from builder
3. Copy assets directory
4. Expose ports 9999/UDP, 9998/TCP
5. Run server in headless mode

**Build Time**: ~5-10 minutes (Godot export)
**Image Size**: ~200-300 MB (includes runtime dependencies)

**Important Notes**:
- Requires export templates in Godot project
- Requires export preset configured for "Linux/X11"
- Game must support `--headless` and `--server` flags

---

## 🌐 NETWORKING

**Service Type**: LoadBalancer (MetalLB)
- **Game Port**: 9999/UDP (ENet game traffic)
- **Status Port**: 9998/TCP (server query, if implemented)
- **External IP**: Assigned by MetalLB from pool (172.20.75.200-210)
- **No Ingress**: Game uses custom protocol, not HTTP/HTTPS
- **No Certificate**: Game traffic is not HTTPS

**Client Connection**:
1. Get external IP: `kubectl get svc resource-wars-server -n resource-wars`
2. Connect game client to `<EXTERNAL-IP>:9999`
3. ENet handles connection, authentication, game state sync

**Firewall Notes**:
- Ensure UDP port 9999 is accessible from client networks
- TCP port 9998 is optional (status/query)
- MetalLB BGP announces routes to OPNsense

---

## 📊 RESOURCE ALLOCATION

**Deployment**:
- Replicas: 1 (game servers typically run 1 instance per lobby)
- Strategy: RollingUpdate (for future multi-server scenarios)

**Container Resources**:
- **Requests**: 500m CPU, 512Mi memory
- **Limits**: 2000m CPU, 2Gi memory

**Probes**:
- **Liveness**: Commented out (requires status endpoint implementation)
- **Readiness**: Commented out (requires status endpoint implementation)
- **Future**: Implement TCP status port for health checks

**Rationale**: Game servers are CPU/memory intensive, especially with AI opponents

---

## 🔍 VALIDATION

### After Deployment

```bash
# 1. Check pod is running
kubectl get pods -n resource-wars
# Expected: 1/1 pod Running

# 2. Check service and external IP
kubectl get svc resource-wars-server -n resource-wars
# Expected: LoadBalancer with EXTERNAL-IP assigned

# 3. Check server logs
kubectl logs -n resource-wars -l app=resource-wars --tail=50
# Expected: Godot server startup messages

# 4. Test connectivity (if status port implemented)
nc -zv <EXTERNAL-IP> 9998
# Expected: Connection succeeded

# 5. Connect game client
# Desktop client → Connect to <EXTERNAL-IP>:9999
# Expected: Client connects successfully
```

---

## 💡 KEY DECISIONS

### Why Godot Headless Server?
- Multiplayer support built into engine
- ENet networking protocol included
- Headless mode reduces resource usage
- Cross-platform (Linux server, Windows/Mac/Linux clients)

### Why LoadBalancer (not Ingress)?
- Game uses custom protocol (ENet/UDP), not HTTP
- LoadBalancer exposes UDP/TCP ports directly
- MetalLB provides external IP via BGP
- No need for SSL/TLS termination

### Why Single Replica?
- Game servers maintain session state in memory
- Multiple replicas would create separate lobbies
- Future: Implement lobby system with dynamic scaling

### Why No Health Checks?
- Health checks commented out until status endpoint implemented
- Future: Implement TCP status port for K8s probes
- Game server process running = healthy enough for MVP

---

## 🎮 GAME DEVELOPMENT NOTES

**This is the SERVER deployment**. For game development:
- Work in main repository: `/mnt/c/Users/shaun/repos/srt-resource-wars`
- See game documentation: `docs/` directory
- Asset generation: `tools/` Python scripts
- Godot project: `godot-project/` directory

**Game Development vs Server Deployment**:
- **Game Dev**: Focus on mechanics, units, AI, graphics (main repo)
- **Server Deploy**: Focus on multiplayer, networking, K8s (submodule)
- **Testing**: Local Godot testing → Docker testing → K8s deployment

**References**:
- Game architecture: `docs/03-technical-architecture.md`
- Game balance: `docs/02-game-balance-reference.md`
- Getting started: `docs/04-getting-started.md`

---

## 🎓 AGENT SUCCESS CRITERIA

You're doing well if:

✅ You understand this is a GAME SERVER (not a web app)
✅ You know there's no Ingress or SSL certificates (game protocol)
✅ You know service is LoadBalancer type (MetalLB)
✅ You reference ChromaDB for platform integration questions
✅ You provide complete solutions (never workarounds)
✅ You use PowerShell scripts for deployment
✅ You validate changes work end-to-end
✅ You distinguish between game development (main repo) and server deployment (submodule)
✅ You understand this is multiplayer server, not single-player game
✅ You respect Shaun's "no workarounds" philosophy

---

## 📅 CHANGE HISTORY

| Date | Change | Impact |
|------|--------|--------|
| 2025-11-10 | Initial onboarding | Project added to SRT-HQ K8s platform |
| 2025-11-10 | Created Dockerfile | Multi-stage build for Godot headless server |
| 2025-11-10 | Created K8s manifests | Deployment, LoadBalancer Service configured |
| 2025-11-10 | Created PowerShell scripts | build-and-push.ps1, deploy.ps1 |
| 2025-11-10 | Added as git submodule | Integrated into srt-hq-k8s repo |

---

**Last Updated**: 2025-11-10
**Status**: Infrastructure Ready (Game logic in MVP development)
**Platform**: SRT-HQ Kubernetes
**Server Type**: Godot 4.x Headless (Multiplayer)

---

*Attach this file to Resource Wars server conversations for complete context.*
