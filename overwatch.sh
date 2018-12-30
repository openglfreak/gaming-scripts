#!/bin/bash

. ./lib/nvidia_oc.sh
. ./lib/deepin_wm.sh

# Overclock graphics card
enter_nvidia_oc
# Disable window manager in DDE (causes massive input lag)
disable_wm_deepin

# Run Quake Champions
lutris lutris:rungame/overwatch

# Restore window manager in DDE
restore_wm_deepin
# Undo graphics card overclock
exit_nvidia_oc
