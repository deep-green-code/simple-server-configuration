#! /bin/bash

green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

set -o allexport
source .env
set +o allexport

if [ "$LOG" ] then
    echo "---------------------------------------------------">>$LOGFILE
    echo "---------------------------">>$LOGFILE
    date>>$LOGFILE
    echo "---------------------------">>$LOGFILE
fi

if [ "$UPDATE" ] then
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} apt update...">>$LOGFILE
    fi
    sudo apt update
fi

if [ "$FULLUPGRADE" ] then
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} Running full-upgrade...">>$LOGFILE
    fi
    sudo apt full-upgrade -y
fi

if [ "$AUTOCLEAN" ] then
    if [ "$LOG" ] then
        echo "${green}==>${reset} Cleaning...">>$LOGFILE
    fi
    sudo apt autoclean -y
fi
if [ "$AUTOREMOVE" ] then
    if [ "$LOG" ] then
        echo "${green}==>${reset} Cleaning...">>$LOGFILE
    fi
    sudo apt autoremove -y
fi

# Antivirus
if [ "$VIRUSCAN" ] then
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} Start scan...">>$LOGFILE
    fi
    sudo clamscan --infected --remove --recursive $SCANFOLDER
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} Start scan...">>$LOGFILE
    fi
fi


if [ "$LOG" ] then
    echo "${green}==>${reset} All Updates & Cleanups Finished">>$LOGFILE
fi

exit 0