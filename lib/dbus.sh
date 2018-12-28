#!/hint/sh

# Waits for a dbus signal
# params: path interface member
dbus_wait_for_signal() {
	dbus-monitor --session --profile "type=signal,path=$1,interface=$2,member=$3" |\
		{
			# Skip table header
			IFS= read -r
			IFS= read -r

			# Skip NameAcquired signal
			IFS= read -r

			# Wait for one line
			IFS= read -r
		}
}
