#!/bin/bash
# prod_env_setup.sh
# This script sets up the production environment for a project.
# It exports environment variables, starts necessary services, and performs additional setup tasks.

# Set environment variables
export APP_ENV=production

# Navigate to the project directory
cd ~/projects/my_project

# Start services using Docker Compose
docker-compose up -d

# Additional setup tasks for production environment can be added here
echo "Production environment setup complete."
