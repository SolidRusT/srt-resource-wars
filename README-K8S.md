# Resource Wars - Kubernetes Deployment

**Game Server**: Godot 4.x headless multiplayer server
**Platform**: SRT-HQ Kubernetes cluster
**Deployment Type**: LoadBalancer service (MetalLB)
**Last Updated**: 2025-11-10

---

## 🚀 Quick Start

### Deploy to Kubernetes

```powershell
# Build, push, and deploy in one command
.\deploy.ps1 -Build -Push

# Or deploy using existing Docker Hub image
.\deploy.ps1
```

### Connect Game Clients

```bash
# Get server external IP
kubectl get svc resource-wars-server -n resource-wars

# Connect desktop client to: <EXTERNAL-IP>:9999
```

---

## 📋 Maintenance

### Update Deployment

```powershell
# Rebuild and redeploy
.\deploy.ps1 -Build -Push
```

### View Logs

```bash
# Real-time server logs
kubectl logs -n resource-wars -l app=resource-wars -f
```

### Uninstall

```powershell
# Remove from cluster
.\deploy.ps1 -Uninstall
```

---

## 🏗️ Architecture

### Tech Stack
- **Game Engine**: Godot 4.2+ (headless mode)
- **Networking**: ENet (UDP/TCP)
- **Container**: Multi-stage Docker build
- **Service**: LoadBalancer (MetalLB)
- **Namespace**: `resource-wars`

### Networking
- **Game Port**: 9999/UDP (ENet game traffic)
- **Status Port**: 9998/TCP (server query, future)
- **External IP**: Assigned by MetalLB
- **No Ingress**: Game uses custom protocol (not HTTP)
- **No SSL**: Game traffic is not HTTPS

### Resources
- **CPU**: 500m request, 2000m limit
- **Memory**: 512Mi request, 2Gi limit
- **Replicas**: 1 (single game server instance)

---

## ✨ Features

**Game**:
- Dune II-inspired RTS gameplay
- Real-time strategy with classic 4X mechanics
- Procedurally generated SVG graphics
- LLM-powered AI opponents (local)
- Multiplayer via ENet networking

**Deployment**:
- Headless server (no display needed)
- LoadBalancer external IP via MetalLB
- Desktop clients connect from any network
- Full resource isolation via Kubernetes

---

## 📁 Files Overview

### Deployment Files (Kubernetes-specific)
- **Dockerfile** - Multi-stage build (Godot export → Runtime)
- **k8s/** - Kubernetes manifests (Namespace, Deployment, Service)
- **build-and-push.ps1** - Docker image builder
- **deploy.ps1** - Kubernetes deployment script
- **CLAUDE.md** - Comprehensive AI agent context
- **README-K8S.md** - This file

### Game Files (Main Repository)
- **godot-project/** - Godot game engine project
- **docs/** - Game design and architecture docs
- **tools/** - Python asset generation scripts
- **README.md** - Game documentation

---

## 🔧 Useful Commands

```bash
# Get all resources
kubectl get all -n resource-wars

# Get server external IP
kubectl get svc resource-wars-server -n resource-wars

# Check pod logs
kubectl logs -n resource-wars -l app=resource-wars --tail=100 -f

# Describe service (shows LoadBalancer details)
kubectl describe svc resource-wars-server -n resource-wars

# Restart server
kubectl rollout restart deployment/resource-wars-server -n resource-wars

# Watch rollout status
kubectl rollout status deployment/resource-wars-server -n resource-wars
```

---

## 🌐 Links

- **Docker Hub**: https://hub.docker.com/r/suparious/resource-wars
- **GitHub**: https://github.com/SolidRusT/srt-resource-wars
- **Platform**: SRT-HQ Kubernetes (srt-hq-k8s repository)

---

## 📝 Notes

**Server Status**: Infrastructure ready, game logic in MVP development

**Game Development**: Work in main repository (`/mnt/c/Users/shaun/repos/srt-resource-wars`)

**Server Deployment**: Work in this submodule (`manifests/apps/resource-wars/`)

**Testing Workflow**:
1. Develop game in Godot Editor (main repo)
2. Test locally with F5 in Godot
3. Build Docker image → Test in container
4. Deploy to Kubernetes → Connect clients

**Connection Details**:
- Server assigns external IP via MetalLB
- Clients connect to `<EXTERNAL-IP>:9999`
- UDP port 9999 must be accessible from client networks
- No web browser access (desktop game clients only)

---

*For detailed documentation, see CLAUDE.md*
