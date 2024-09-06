#!/bin/bash
# create_react_project.sh
# This script automates the creation of a new React project.

# Ensure a project name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <project_name>"
  exit 1
fi

PROJECT_NAME=$1

# Create the React project
npx create-react-app $PROJECT_NAME

# Navigate to the project directory
cd $PROJECT_NAME

# Install additional dependencies (optional)
npm install axios react-router-dom

# Initialize a Git repository
git init
git add .
git commit -m "Initial commit"

# Open the project in VS Code
code .

echo "React project '$PROJECT_NAME' created and setup successfully."
