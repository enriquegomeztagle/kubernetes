#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Kubernetes project setup..."

# 1. Ensure Minikube is running
echo "Checking if Minikube is running..."
minikube status &>/dev/null || minikube start

# 2. Set the Docker environment to point to Minikube's Docker daemon
echo "Setting Docker environment to Minikube's Docker daemon..."
eval $(minikube docker-env)

# 3. Build Docker images inside Minikube's Docker environment

echo "Building service-a Docker image..."
cd service-a
docker build -t service-a:latest .
cd ..

echo "Building service-b Docker image..."
cd service-b
docker build -t service-b:latest .
cd ..

# 4. Delete existing Kubernetes deployments and services (if any)
echo "Deleting existing deployments and services..."
kubectl delete -f service-a-deployment.yaml --ignore-not-found
kubectl delete -f service-b-deployment.yaml --ignore-not-found

# 5. Apply Kubernetes deployment configurations
echo "Applying Kubernetes deployment configurations..."
kubectl apply -f service-a-deployment.yaml
kubectl apply -f service-b-deployment.yaml

# 6. Wait for Pods to be in 'Running' state
echo "Waiting for service-a deployment to roll out..."
kubectl rollout status deployment/service-a

echo "Waiting for service-b deployment to roll out..."
kubectl rollout status deployment/service-b

# 7. Verify that Pods are running
echo "Verifying Pods are running..."
kubectl get pods

# 8. Accessing service-b via port-forward
echo "Accessing service-b via port-forward..."

# Port-forward from local port 8080 to service-b's port 3000
kubectl port-forward service/service-b 8080:3000 &

# Store the background process ID
PORT_FORWARD_PID=$!

# Give it a few seconds to establish
sleep 5

echo "Testing service-b..."

# Access the service via localhost:8080
curl http://localhost:8080

# Kill the port-forward process
kill $PORT_FORWARD_PID

echo "Kubernetes project setup completed successfully."
