#!/hint/sh

# Waits for a dbus signal
#
# params: path interface member
#	string path
#		The path of the signal.
#	string interface
#		The interface of the signal.
#	string member
#		The signal name.
dbus_wait_for_signal() {
	sh -c 'printf "%s\\n" "$$"; LINES= COLUMNS= LC_ALL=C exec dbus-monitor --session --profile "type=signal,path=$1,interface=$2,member=$3"' "$0" "$1" "$2" "$3" 2>/dev/null |\
		{
			# Read dbus-monitor pid
			IFS= read -r __dbus_wait_for_signal_mpid

			# Skip table header
			IFS= read -r
			IFS= read -r

			# Wait for one matching line
			while IFS= read -r line; do
				case "$line" in *[[:space:]]"$1"[[:space:]]"$2"[[:space:]]"$3")
					break
				esac
			done

			# Kill dbus-monitor
			kill "$__dbus_wait_for_signal_mpid"
		}
}
