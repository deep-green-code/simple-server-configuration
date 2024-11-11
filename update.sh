#!/bin/bash

# Load the installer environment variables
INSTALLER_ENV_FILE="./.env.installer"

# Source the installer .env file
if [ -f "$INSTALLER_ENV_FILE" ]; then
    source "$INSTALLER_ENV_FILE"
else
    echo "Error: Installer .env file not found!"
    exit 1
fi

# Variables from the installer .env
REPO_DIR="${REPO_DIR:-/opt/simple-server-configuration}"  # Default to /path/to/your/repo if not set

# Navigate to the Git repository directory
cd "$REPO_DIR" || { echo "Repository directory not found! Exiting."; exit 1; }

# Pull the latest changes from the remote repository
echo "Pulling the latest changes..."
git pull origin main || { echo "Git pull failed! Exiting."; exit 1; }

# Copy the updated files to the proper location
echo "Copying updated files..."
cp "$REPO_DIR/server_maintenance.sh" "$BASE_DIR/server_maintenance.sh"
# TODO find a way to check if there is new lines in the .env.exemple and warn user
#cp "$REPO_DIR/.env.example" "$BASE_DIR/.env"

# Set proper permissions
chmod +x "$BASE_DIR/server_maintenance.sh"

# Optionally, restart cron to apply any cron-related changes (if needed)
# sudo systemctl restart cron

echo "Update complete!"
