#!/bin/bash

. ./lib/nvidia_oc.sh

# Overclock graphics card
enter_nvidia_oc

# Run Quake Champions
lutris lutris:rungame/overwatch

# Undo graphics card overclock
exit_nvidia_oc
