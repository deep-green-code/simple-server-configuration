#!/bin/bash

green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

# Check if OS is Debian
os_name=$(grep "^NAME" /etc/os-release | cut -d'=' -f2 | tr -d '"')
if [ "$os_name" != "Debian GNU/Linux" ]; then
    echo "This script is optimized for Debian. Detected: $os_name" | tee -a "$LOGFILE"
    exit 1
fi

# Load environment variables from .env
set -o allexport
source .env
set +o allexport

# Initialize error logging function
log_error() {
    echo "Error on line $1" | tee -a "$LOGFILE"
}

# Enable error trapping
trap 'log_error $LINENO' ERR

# Start logging
if [ "$LOG" = true ]; then
    {
        echo "---------------------------------------------------"
        echo "---------------------------"
        date
        echo "---------------------------"
    } >> "$LOGFILE"
fi

# System Update
if [ "$UPDATE" = true ]; then
    echo "${yellow}==>${reset} apt update..." | tee -a "$LOGFILE"
    sudo apt update >> "$LOGFILE" 2>&1
fi

# Full Upgrade
if [ "$FULLUPGRADE" = true ]; then
    echo "${yellow}==>${reset} Running full-upgrade..." | tee -a "$LOGFILE"
    sudo apt full-upgrade -y >> "$LOGFILE" 2>&1
fi

# Autoclean
if [ "$AUTOCLEAN" = true ]; then
    echo "${green}==>${reset} Cleaning..." | tee -a "$LOGFILE"
    sudo apt autoclean -y >> "$LOGFILE" 2>&1
fi

# Autoremove
if [ "$AUTOREMOVE" = true ]; then
    echo "${green}==>${reset} Removing unnecessary packages..." | tee -a "$LOGFILE"
    sudo apt autoremove -y >> "$LOGFILE" 2>&1
fi

# Virus Scan
if [ "$VIRUSCAN" = true ]; then
    echo "${yellow}==>${reset} Start scan..." | tee -a "$LOGFILE"
    sudo clamscan --infected --remove --recursive "$SCANFOLDER" >> "$LOGFILE" 2>&1
    echo "${yellow}==>${reset} Scan finished!" | tee -a "$LOGFILE"
fi

# Automated Portainer Update with Version Check
if [ "$UPDATE_PORTAINER" = true ]; then
    echo "${yellow}==>${reset} Checking for Portainer updates..." | tee -a "$LOGFILE"
    
    # Pull the latest image version
    docker pull portainer/portainer-ce:latest >> "$LOGFILE" 2>&1

    # Get the current and latest image IDs
    current_image=$(docker inspect --format '{{.Image}}' portainer)
    latest_image=$(docker inspect --format '{{.Id}}' portainer/portainer-ce:latest)

    if [ "$current_image" != "$latest_image" ]; then
        echo "${yellow}==>${reset} Newer version of Portainer detected. Updating..." | tee -a "$LOGFILE"

        # Stop, remove, and start the updated Portainer container
        {
            docker stop portainer &&
            docker rm portainer &&
            docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always \
                -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
        } >> "$LOGFILE" 2>&1

        if [ $? -eq 0 ]; then
            echo "${green}==>${reset} Portainer updated successfully." | tee -a "$LOGFILE"
        else
            echo "${yellow}==>${reset} Portainer update encountered an error. Check log for details." | tee -a "$LOGFILE"
        fi
    else
        echo "${green}==>${reset} Portainer is already up-to-date." | tee -a "$LOGFILE"
    fi
fi

# Final log message
if [ "$LOG" = true ]; then
    echo "${green}==>${reset} All Updates & Cleanups Finished" | tee -a "$LOGFILE"
fi

exit 0
