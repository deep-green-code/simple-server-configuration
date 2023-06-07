#! /bin/bash

green=$(tput setaf 2)
yellow=$(tput setaf 3)
reset=$(tput sgr0)

set -o allexport
source .env
set +o allexport

if [ "$LOG" = "y" ]
    echo "---------------------------------------------------">>${logfile}
    echo "---------------------------">>${logfile}
    date>>${logfile}
    echo "---------------------------">>${logfile}
fi

if [ "$UPDATE" = "y" ]
    if [ "$LOG" = "y" ]
        echo "${yellow}==>${reset} apt update...">>${logfile}
    fi
    sudo apt update
fi

if [ "$FULLUPGRADE" = "y" ]
    if [ "$LOG" = "y" ]
        echo "${yellow}==>${reset} Running full-upgrade...">>${logfile}
    fi
    sudo apt full-upgrade -y
fi

if [ "$AUTOCLEAN" = "y" ]
    if [ "$LOG" = "y" ]
        echo "${green}==>${reset} Cleaning...">>${logfile}
    fi
    sudo apt autoclean -y
fi
if [ "$AUTOREMOVE" = "y" ]
    if [ "$LOG" = "y" ]
        echo "${green}==>${reset} Cleaning...">>${logfile}
    fi
    sudo apt autoremove -y
fi

if [ "$LOG" = "y" ]
    echo "${green}==>${reset} All Updates & Cleanups Finished">>${logfile}
fi
exit 0