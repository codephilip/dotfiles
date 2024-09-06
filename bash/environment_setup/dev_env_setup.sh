#!/bin/bash
# dev_env_setup.sh
# This script sets up the development environment for a project.
# It exports environment variables, starts necessary services, and opens the project in VS Code.

# Set environment variables
export APP_ENV=development

# Navigate to the project directory
cd ~/projects/my_project

# Start services using Docker Compose
docker-compose up -d

# Open the project in Visual Studio Code
code .

echo "Development environment setup complete."
