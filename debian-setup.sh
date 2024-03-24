#! /bin/bash

# Script to setup the base of the servers

apt install screen mc bpytop inxi ncdu tmux neofetch


apt install clamav clamav-daemon
systemctl stop clamav-freshclam
freshclam
systemctl start clamav-freshclam
systemctl enable clamav-freshclam