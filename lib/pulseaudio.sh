#!/hint/bash

start_pulseaudio() {
	if ! [ active = "$(systemctl --user is-active pulseaudio.service)" ]; then
		systemctl --user start pulseaudio.service
		pulseaudio_service_action=started
	fi
	if ! [ active = "$(systemctl --user is-active pulseaudio.socket)" ]; then
		systemctl --user start pulseaudio.socket
		pulseaudio_socket_action=started
	fi
}
stop_pulseaudio() {
	if [ active = "$(systemctl --user is-active pulseaudio.socket)" ]; then
		systemctl --user stop pulseaudio.socket
		pulseaudio_socket_action=stopped
	fi
	if [ active = "$(systemctl --user is-active pulseaudio.service)" ]; then
		systemctl --user stop pulseaudio.service
		pulseaudio_service_action=stopped
	fi
}
restore_pulseaudio() {
	case "$pulseaudio_service_action" in
		started)
			systemctl --user stop pulseaudio.service
			;;
		stopped)
			systemctl --user start pulseaudio.service
			;;
	esac
	unset pulseaudio_service_action
	case "$pulseaudio_socket_action" in
		started)
			systemctl --user stop pulseaudio.socket
			;;
		stopped)
			systemctl --user start pulseaudio.socket
			;;
	esac
	unset pulseaudio_socket_action
}
