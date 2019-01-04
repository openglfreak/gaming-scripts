#!/bin/bash

. ./lib/pulseaudio.sh
. ./lib/nvidia_oc.sh

# Stop pulseaudio
stop_pulseaudio
# Overclock graphics card
enter_nvidia_oc

# Run osu!
lutris lutris:rungame/osu

# Undo graphics card overclock
exit_nvidia_oc
# Restore pulseaudio
restore_pulseaudio
