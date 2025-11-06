# stop.ps1 — Safely shuts down Jenkins + kind cluster

Write-Host "Stopping Jenkins container..."
docker stop jenkins-ci 2>$null

Write-Host "Deleting kind Kubernetes cluster..."
kind delete cluster --name jenkins-demo

Write-Host "All services stopped and cleaned up!"
Write-Host "You can restart anytime using start.ps1"
