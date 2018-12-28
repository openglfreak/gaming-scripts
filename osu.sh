#!/bin/bash

. ./lib/pulseaudio.sh

# Stop pulseaudio
stop_pulseaudio

# Run osu!
lutris lutris:rungame/osu

# Restore pulseaudio
restore_pulseaudio
