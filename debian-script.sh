#! /bin/bash

green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

set -o allexport
source .env
set +o allexport

if [ "$LOG" ] then
    echo "---------------------------------------------------">>${logfile}
    echo "---------------------------">>${logfile}
    date>>${logfile}
    echo "---------------------------">>${logfile}
fi

if [ "$UPDATE" ] then
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} apt update...">>${logfile}
    fi
    sudo apt update
fi

if [ "$FULLUPGRADE" ] then
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} Running full-upgrade...">>${logfile}
    fi
    sudo apt full-upgrade -y
fi

if [ "$AUTOCLEAN" ] then
    if [ "$LOG" ] then
        echo "${green}==>${reset} Cleaning...">>${logfile}
    fi
    sudo apt autoclean -y
fi
if [ "$AUTOREMOVE" ] then
    if [ "$LOG" ] then
        echo "${green}==>${reset} Cleaning...">>${logfile}
    fi
    sudo apt autoremove -y
fi

# Antivirus
if [ "$VIRUSCAN" ] then
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} Start scan...">>${logfile}
    fi
    sudo clamscan --infected --remove --recursive $SCANFOLDER
    if [ "$LOG" ] then
        echo "${yellow}==>${reset} Start scan...">>${logfile}
    fi
fi


if [ "$LOG" ] then
    echo "${green}==>${reset} All Updates & Cleanups Finished">>${logfile}
fi

exit 0