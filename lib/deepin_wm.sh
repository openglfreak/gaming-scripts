#!/hint/bash

__deepin_wm_wait_for_WMChanged() {
	dbus-monitor --session --profile 'type=signal,path=/com/deepin/WMSwitcher,interface=com.deepin.WMSwitcher,member=WMChanged' |\
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

enable_wm_deepin() {
	if [ Deepin = "$XDG_CURRENT_DESKTOP" ]; then
		local current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
		case "$current_wm" in *deepin\ wm*) :;; *)
			dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call /com/deepin/WMSwitcher com.deepin.WMSwitcher.RequestSwitchWM
			__deepin_wm_wait_for_WMChanged
			deepin_wm_action=enabled;;
		esac
	fi
}
disable_wm_deepin() {
	if [ Deepin = "$XDG_CURRENT_DESKTOP" ]; then
		local current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
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
				local current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
				case "$current_wm" in *deepin\ wm*)
					dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call /com/deepin/WMSwitcher com.deepin.WMSwitcher.RequestSwitchWM
					__deepin_wm_wait_for_WMChanged
				esac
				;;
			disabled)
				local current_wm="$(dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call --print-reply=literal /com/deepin/WMSwitcher com.deepin.WMSwitcher.CurrentWM)"
				case "$current_wm" in *deepin\ wm*) :;; *)
					dbus-send --session --dest=com.deepin.WMSwitcher --type=method_call /com/deepin/WMSwitcher com.deepin.WMSwitcher.RequestSwitchWM
					__deepin_wm_wait_for_WMChanged;;
				esac
				;;
		esac
		unset deepin_wm_action
	fi
}
