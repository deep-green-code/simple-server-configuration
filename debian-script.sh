#! /bin/bash

green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

# TODO check OS

set -o allexport
source .env
set +o allexport

if [ "$LOG" ] ; then
    echo "---------------------------------------------------">>$LOGFILE;
    echo "---------------------------">>$LOGFILE;
    date>>$LOGFILE;
    echo "---------------------------">>$LOGFILE;
fi

if [ "$UPDATE" ] ; then
    if [ "$LOG" ] ; then
        echo "${yellow}==>${reset} apt update...">>$LOGFILE;
    fi
    sudo apt update;
fi

if [ "$FULLUPGRADE" ] ; then
    if [ "$LOG" ] ; then
        echo "${yellow}==>${reset} Running full-upgrade...">>$LOGFILE;
    fi
    sudo apt full-upgrade -y;
fi

if [ "$AUTOCLEAN" ] ; then
    if [ "$LOG" ] ; then
        echo "${green}==>${reset} Cleaning (autoclean)...">>$LOGFILE;
    fi
    sudo apt autoclean -y;
fi
if [ "$AUTOREMOVE" ] ; then
    if [ "$LOG" ] ; then
        echo "${green}==>${reset} Cleaning (autoremove)...">>$LOGFILE;
    fi
    sudo apt autoremove -y;
fi

# Antivirus
if [ "$VIRUSCAN" ] ; then
    if [ "$LOG" ] ; then
        echo "${yellow}==>${reset} Start scan...">>$LOGFILE;
    fi
    sudo clamscan --infected --remove --recursive $SCANFOLDER;
    if [ "$LOG" ] ; then
        echo "${yellow}==>${reset} Scan finished !">>$LOGFILE;
    fi
fi

# Portainer Update
# docker stop portainer
# docker rm portainer
# docker pull portainer/portainer-ce:latest
# docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

if [ "$LOG" ] ; then
    echo "${green}==>${reset} All Updates & Cleanups Finished">>$LOGFILE;
fi

exit 0