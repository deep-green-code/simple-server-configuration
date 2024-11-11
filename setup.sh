#!/bin/bash

# Script to set up the server base

# Install essential utilities
echo "Installing utilities..."
apt update
apt install -y screen mc bpytop inxi ncdu tmux neofetch

# Install and configure ClamAV for virus scanning
echo "Installing and configuring ClamAV..."
apt install -y clamav clamav-daemon
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam
systemctl enable clamav-freshclam

# Set up directories and permissions for the maintenance script
echo "Setting up directories and permissions..."

# Define default values for configuration
DEFAULT_REPO_DIR="/opt/simple-server-configuration"  # Default repository directory
DEFAULT_BASE_DIR="/usr/local/server_maintenance"  # Default installation directory

# Prompt user for repository directory
echo "Enter the path for your repository (default: $DEFAULT_REPO_DIR):"
read -r REPO_DIR
REPO_DIR="${REPO_DIR:-$DEFAULT_REPO_DIR}"  # Use default if empty

# Prompt user for base directory
echo "Enter the path for your maintenance script installation (default: $DEFAULT_BASE_DIR):"
read -r BASE_DIR
BASE_DIR="${BASE_DIR:-$DEFAULT_BASE_DIR}"  # Use default if empty

# Check if the provided directory exists, if not, create it
mkdir -p "$BASE_DIR"
mkdir -p "$(dirname "$BASE_DIR")"

# Create the .env.installer file with user inputs and default values
echo "Creating the installer .env file..."

cat <<EOL > "$REPO_DIR/.env.installer"
# Installer environment variables

# Path to the repository
REPO_DIR="$REPO_DIR"

# Path to the base directory where the script will be installed
BASE_DIR="$BASE_DIR"
EOL

# Set permissions for the .env.installer file
chmod 640 "$REPO_DIR/.env.installer"

# Copy the maintenance script to the base directory
cp "server_maintenance.sh" "$BASE_DIR/server_maintenance.sh"

# Set execute permissions on the maintenance script
chmod +x "$BASE_DIR/server_maintenance.sh"

# Create a symlink in /usr/local/bin for easy access
ln -sf "$BASE_DIR/server_maintenance.sh" /usr/local/bin/server_maintenance

# Create the log file and set permissions
LOG_FILE="/var/log/server_maintenance.log"
touch "$LOG_FILE"
chown root:adm "$LOG_FILE"
chmod 640 "$LOG_FILE"

# Set up logrotate for the maintenance script
echo "Configuring logrotate..."
cat <<EOL > /etc/logrotate.d/server_maintenance
$LOG_FILE {
    weekly
    rotate 4
    compress
    missingok
    notifempty
    create 640 root adm
}
EOL

echo "Setup complete! Remember to customize your .env file in $BASE_DIR."
