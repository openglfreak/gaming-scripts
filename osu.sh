#!/bin/bash

. ./lib/pulseaudio.sh
. ./lib/nvidia_oc.sh
. ./lib/deepin_wm.sh

# Stop pulseaudio
stop_pulseaudio
# Overclock graphics card
enter_nvidia_oc
# Disable window manager in DDE (causes massive input lag)
disable_wm_deepin

# Run osu!
lutris lutris:rungame/osu

# Restore window manager in DDE
restore_wm_deepin
# Undo graphics card overclock
exit_nvidia_oc
# Restore pulseaudio
restore_pulseaudio
