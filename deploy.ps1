#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Deploy Resource Wars game server to Kubernetes

.DESCRIPTION
    Deploys the Resource Wars Godot headless server to SRT-HQ Kubernetes cluster

.PARAMETER Build
    Build Docker image before deploying

.PARAMETER Push
    Push Docker image to Docker Hub (requires authentication)

.PARAMETER Uninstall
    Remove deployment from cluster

.EXAMPLE
    .\deploy.ps1
    Deploy using existing Docker Hub image

.EXAMPLE
    .\deploy.ps1 -Build -Push
    Build, push, and deploy

.EXAMPLE
    .\deploy.ps1 -Uninstall
    Remove from cluster
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Build,

    [Parameter(Mandatory = $false)]
    [switch]$Push,

    [Parameter(Mandatory = $false)]
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

#region Configuration

$APP_NAME = "resource-wars-server"
$NAMESPACE = "resource-wars"
$IMAGE = "suparious/resource-wars:latest"
$K8S_DIR = "k8s"

# Color formatting
$colors = @{
    Header = 'Cyan'
    Success = 'Green'
    Warning = 'Yellow'
    Error = 'Red'
    Info = 'White'
}

#endregion

#region Functions

function Write-ColorOutput {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [string]$Color = 'White'
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-ColorOutput "===========================================" $colors.Header
    Write-ColorOutput " $Message" $colors.Header
    Write-ColorOutput "===========================================" $colors.Header
    Write-Host ""
}

#endregion

#region Main Script

# Handle uninstall
if ($Uninstall) {
    Write-Header "Uninstalling $APP_NAME from Kubernetes"

    Write-ColorOutput "Deleting Kubernetes resources..." $colors.Info
    kubectl delete -f "$K8S_DIR/03-service.yaml" --ignore-not-found
    kubectl delete -f "$K8S_DIR/02-deployment.yaml" --ignore-not-found
    kubectl delete -f "$K8S_DIR/01-namespace.yaml" --ignore-not-found

    Write-ColorOutput "✅ Uninstallation complete" $colors.Success
    exit 0
}

Write-Header "Deploying Resource Wars Game Server to Kubernetes"

# Build and push if requested
if ($Build) {
    Write-ColorOutput "Building Docker image..." $colors.Info

    if ($Push) {
        & .\build-and-push.ps1 -Push
    }
    else {
        & .\build-and-push.ps1
    }

    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "Build failed" $colors.Error
        exit 1
    }
    Write-Host ""
}

# Apply Kubernetes manifests
Write-ColorOutput "Applying Kubernetes manifests..." $colors.Header

Write-ColorOutput "  → Creating namespace..." $colors.Info
kubectl apply -f "$K8S_DIR/01-namespace.yaml"

Write-ColorOutput "  → Creating deployment..." $colors.Info
kubectl apply -f "$K8S_DIR/02-deployment.yaml"

Write-ColorOutput "  → Creating LoadBalancer service..." $colors.Info
kubectl apply -f "$K8S_DIR/03-service.yaml"

Write-ColorOutput "✅ Manifests applied" $colors.Success

# Force rollout restart if we pushed new images (using :latest tag)
if ($Push) {
    Write-Host ""
    Write-ColorOutput "Forcing rollout restart to pull new image..." $colors.Info
    kubectl rollout restart deployment/$APP_NAME -n $NAMESPACE
    Write-ColorOutput "✅ Rollout restart triggered" $colors.Success
}

# Wait for rollout
Write-Host ""
Write-ColorOutput "Waiting for deployment rollout..." $colors.Info
kubectl rollout status deployment/$APP_NAME -n $NAMESPACE --timeout=120s

if ($LASTEXITCODE -ne 0) {
    Write-ColorOutput "Deployment rollout failed" $colors.Error
    Write-Host ""
    Write-ColorOutput "Check logs with:" $colors.Info
    Write-Host "  kubectl logs -n $NAMESPACE -l app=resource-wars --tail=50"
    exit 1
}

Write-ColorOutput "✅ Deployment successful" $colors.Success

# Show status
Write-Header "Deployment Status"

Write-ColorOutput "Pods:" $colors.Info
kubectl get pods -n $NAMESPACE

Write-Host ""
Write-ColorOutput "Service (LoadBalancer):" $colors.Info
kubectl get svc -n $NAMESPACE

# Get LoadBalancer external IP
Write-Host ""
Write-ColorOutput "Waiting for LoadBalancer IP assignment..." $colors.Info
$maxAttempts = 30
$attempt = 0
$externalIP = ""

while ($attempt -lt $maxAttempts) {
    $svcInfo = kubectl get svc resource-wars-server -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>$null
    if ($svcInfo) {
        $externalIP = $svcInfo
        break
    }
    Start-Sleep -Seconds 2
    $attempt++
}

# Summary
Write-Host ""
if ($externalIP) {
    Write-ColorOutput "✅ Deployment complete!" $colors.Success
    Write-Host ""
    Write-ColorOutput "🎮 Game Server Details:" 'Yellow'
    Write-Host "  External IP: $externalIP" -ForegroundColor Green
    Write-Host "  Game Port (UDP): 9999" -ForegroundColor Green
    Write-Host "  Status Port (TCP): 9998" -ForegroundColor Green
    Write-Host ""
    Write-ColorOutput "Connect game clients to: ${externalIP}:9999" 'Cyan'
    Write-Host ""
}
else {
    Write-ColorOutput "✅ Deployment complete (LoadBalancer IP pending)" $colors.Success
    Write-Host ""
    Write-ColorOutput "LoadBalancer IP not yet assigned. Check with:" $colors.Warning
    Write-Host "  kubectl get svc -n $NAMESPACE"
    Write-Host ""
}

Write-ColorOutput "Useful commands:" $colors.Header
Write-Host "  kubectl get all -n $NAMESPACE"
Write-Host "  kubectl logs -n $NAMESPACE -l app=resource-wars -f"
Write-Host "  kubectl describe svc resource-wars-server -n $NAMESPACE"
Write-Host "  kubectl get svc -n $NAMESPACE -o wide"
Write-Host ""

#endregion
