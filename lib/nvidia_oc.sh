#!/hint/sh

enter_nvidia_oc() {
	if [ -z "$__nvidia_oc_user_context_pid" ]; then
		# Create a fifo
		__nvidia_oc_fifo_dir="$(mktemp -d)"
		__nvidia_oc_fifo="$(TMPDIR="$__nvidia_oc_fifo_dir" mktemp -u)"
		mkfifo -m 600 "$__nvidia_oc_fifo"
		
		# User context:
		# 1. Execute a script with the fifo as stdout:
		#      - Set the process name to nv-oc-user-ctx
		#      - Setup a trap that runs when the shell exits,
		#        that prints a newline.
		#      - Wait forever.
		#        Note: Sleep is not interruptible by a trap, but wait is.
		/bin/sh -c 'printf "%s" nv-oc-user-ctx > /proc/self/comm; trap "echo" EXIT; sleep infinity & wait' nvidia-oc-user-context > "$__nvidia_oc_fifo" &
		__nvidia_oc_user_context_pid=$!
		
		# Root context:
		# 1. Close all standard file descriptors.
		# 2. Execute as root, while preserving DISPLAY and XAUTHORITY
		# 3. Execute a script a root, with the fifo as the first parameter:
		#      - Open the fifo as soon as possible.
		#      - Set the process name to nv-oc-root-ctx
		#      - Run nvidia-oc.
		#      - Fork a subshell:
		#          - Wait for one byte from the fifo.
		#          - Close the fifo.
		#          - Run nvidia-oc --reset.
		# shellcheck disable=SC2016
		<&- >&- 2>&- \
		pkexec /usr/bin/env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" \
		/bin/sh -c 'exec 32<"$1"; printf "%s" nv-oc-root-ctx > /proc/self/comm; /usr/local/bin/nvidia-oc 32<&-; { /usr/bin/dd of=/dev/null bs=1 count=1 status=none <&32; exec 32<&-; /usr/local/bin/nvidia-oc --reset; } &' nvidia-oc-root-context "$__nvidia_oc_fifo"
		
		# Remove the fifo
		unlink "$__nvidia_oc_fifo"
		unset __nvidia_oc_fifo
		rmdir "$__nvidia_oc_fifo_dir"
		unset __nvidia_oc_fifo_dir
	fi
}
exit_nvidia_oc() {
	if [ -n "$__nvidia_oc_user_context_pid" ]; then
		kill $((__nvidia_oc_user_context_pid))
		unset __nvidia_oc_user_context_pid
	else
		pkexec /usr/bin/env DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" /usr/local/bin/nvidia-oc --reset
	fi
}
