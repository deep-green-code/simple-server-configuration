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

# Define variables
SCRIPT_DIR="/usr/local/bin"
LOG_DIR="/var/log"
SCRIPT_NAME="server_maintenance.sh"
LOG_FILE="$LOG_DIR/server_maintenance.log"

# Ensure the script directory exists
mkdir -p "$SCRIPT_DIR"
mkdir -p "$LOG_DIR"

# Copy the maintenance script and .env.example file to the script directory
cp "$SCRIPT_NAME" "$SCRIPT_DIR/$SCRIPT_NAME"
cp .env.example "$SCRIPT_DIR/.env"

# Set execute permissions on the maintenance script
chmod +x "$SCRIPT_DIR/$SCRIPT_NAME"

# Create the log file and set permissions
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

echo "Setup complete! Remember to customize your .env file in $SCRIPT_DIR."
