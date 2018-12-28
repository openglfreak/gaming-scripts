#!/bin/bash

. ./lib/pulseaudio.sh
. ./lib/deepin_wm.sh

# Stop pulseaudio
stop_pulseaudio
# Disable window manager in DDE (causes massive input lag)
disable_wm_deepin

# Run osu!
lutris lutris:rungame/osu

# Restore window manager in DDE
restore_wm_deepin
# Restore pulseaudio
restore_pulseaudio
