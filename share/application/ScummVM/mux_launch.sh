#!/bin/sh
# HELP: Script Creation Utility for Maniac Mansion Virtual Machine (ScummVM)
# ICON: scummvm
# GRID: ScummVM

. /opt/muos/script/var/func.sh

echo app >/tmp/act_go

GOV_GO="/tmp/gov_go"
[ -e "$GOV_GO" ] && cat "$GOV_GO" >"$(GET_VAR "device" "cpu/governor")"

SETUP_SDL_ENVIRONMENT

HOME="$(GET_VAR "device" "board/home")"
export HOME

SET_VAR "system" "foreground_process" "scummvm"

EMUDIR="$MUOS_SHARE_DIR/emulator/scummvm"
CONFIG="$EMUDIR/.config/scummvm/scummvm.ini"
LOGPATH="$(GET_VAR "device" "storage/rom/mount")/MUOS/log/scummvm.log"
SAVE="$MUOS_STORE_DIR/save/file/ScummVM-Ext"

RG_DPAD="/sys/class/power_supply/axp2202-battery/nds_pwrkey"
TUI_DPAD="/tmp/trimui_inputd/input_dpad_to_joystick"

mkdir -p "$SAVE"
chmod +x "$EMUDIR"/scummvm

cd "$EMUDIR" || exit

# Switch analogue<>dpad for stickless devices
[ "$(GET_VAR "device" "board/stick")" -eq 0 ] && STICK_ROT=2 || STICK_ROT=0
case "$(GET_VAR "device" "board/name")" in
	rg*) echo "$STICK_ROT" >"$RG_DPAD" ;;
	tui*) [ ! -f $TUI_DPAD ] && touch $TUI_DPAD ;;
	*) ;;
esac

HOME="$EMUDIR" ./scummvm --logfile="$LOGPATH" --joystick=0 --config="$CONFIG"

# Switch analogue<>dpad back so we can navigate muX
[ "$(GET_VAR "device" "board/stick")" -eq 0 ]
case "$(GET_VAR "device" "board/name")" in
	rg*) echo "0" >"$RG_DPAD" ;;
	tui*) [ -f $TUI_DPAD ] && rm $TUI_DPAD ;;
	*) ;;
esac

unset SDL_ASSERT SDL_HQ_SCALER SDL_ROTATION SDL_BLITTER_DISABLED
