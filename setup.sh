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
BASE_DIR="/usr/local/server_maintenance"
SCRIPT_NAME="server_maintenance.sh"
SCRIPT_PATH="$BASE_DIR/$SCRIPT_NAME"
LOG_FILE="/var/log/server_maintenance.log"
ENV_FILE=".env.example"

# Create the base directory
mkdir -p "$BASE_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Copy the maintenance script and .env.example file to the script directory
cp "$SCRIPT_NAME" "$SCRIPT_PATH"
cp "$ENV_FILE" "$BASE_DIR/.env"

# Set execute permissions on the maintenance script
chmod +x "$SCRIPT_PATH"

# Create a symlink in /usr/local/bin for easy access
ln -sf "$SCRIPT_PATH" /usr/local/bin/server_maintenance

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

echo "Setup complete! Remember to customize your .env file in $BASE_DIR."
