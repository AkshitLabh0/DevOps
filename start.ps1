# start.ps1 — Starts Jenkins + kind cluster + re-applies deployments and services

Write-Host "Starting system..."

# Check if Docker is running
if (-Not (docker info 2>$null)) {
  Write-Host "Docker is not running. Please launch Docker Desktop!"
  Exit
}

Write-Host "Starting Jenkins container..."
docker start jenkins-ci 2>$null

if ($LASTEXITCODE -ne 0) {
  Write-Host "Jenkins container not found. Run docker run command to recreate it."
  Exit
}

Write-Host "Creating kind Kubernetes cluster..."
kind create cluster --name jenkins-demo --config kind-config.yaml

Write-Host "Re-applying Kubernetes deployments and services..."
kubectl apply -f k8s/bg/

Write-Host "Setup complete!"
Write-Host "Jenkins: http://localhost:8080"
Write-Host "To access the app: kubectl port-forward -n happy-paws-bg svc/happy-paws-svc 9090:80"
