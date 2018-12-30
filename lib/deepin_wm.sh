#!/hint/bash

# shellcheck source=lib/dbus.sh
. "${BASH_SOURCE%/*}/dbus.sh"

__deepin_wm_wait_for_WMChanged() {
	dbus_wait_for_signal /com/deepin/WMSwitcher com.deepin.WMSwitcher WMChanged
}

enable_wm_deepin() {
	if [ Deepin = "$XDG_CURRENT_DESKTOP" ]; then
		local current_wm
		current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
		case "$current_wm" in *deepin\ wm*) :;; *)
			dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call /com/deepin/WMSwitcher com.deepin.WMSwitcher.RequestSwitchWM
			__deepin_wm_wait_for_WMChanged
			deepin_wm_action=enabled;;
		esac
	fi
}
disable_wm_deepin() {
	if [ Deepin = "$XDG_CURRENT_DESKTOP" ]; then
		local current_wm
		current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
		case "$current_wm" in *deepin\ wm*)
			dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call /com/deepin/WMSwitcher com.deepin.WMSwitcher.RequestSwitchWM
			__deepin_wm_wait_for_WMChanged
			deepin_wm_action=disabled
		esac
	fi
}
restore_wm_deepin() {
	if [ Deepin = "$XDG_CURRENT_DESKTOP" ]; then
		case "$deepin_wm_action" in
			enabled)
				local current_wm
				current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
				case "$current_wm" in *deepin\ wm*)
					dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call /com/deepin/WMSwitcher com.deepin.WMSwitcher.RequestSwitchWM
					__deepin_wm_wait_for_WMChanged
				esac
				;;
			disabled)
				local current_wm
				current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
				case "$current_wm" in *deepin\ wm*) :;; *)
					dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call /com/deepin/WMSwitcher com.deepin.WMSwitcher.RequestSwitchWM
					__deepin_wm_wait_for_WMChanged;;
				esac
				;;
		esac
		unset deepin_wm_action
	fi
}
