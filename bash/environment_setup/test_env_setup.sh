#!/bin/bash
# test_env_setup.sh
# This script sets up the testing environment for a project.
# It exports environment variables, starts necessary services, and performs additional setup tasks.

# Set environment variables
export APP_ENV=testing

# Navigate to the project directory
cd ~/projects/my_project

# Start services using Docker Compose
docker-compose up -d

# Additional setup tasks for testing environment can be added here
echo "Testing environment setup complete."
