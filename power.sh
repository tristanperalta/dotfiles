!#/usr/bin/env bash

RET=$(echo "Shutdown\nReboot\nLock\nSuspend" | dmenu)

case $RET in
  Shutdown)
    poweroff
    ;;
  Reboot)
    reboot
    ;;
  Lock)
    i3lock -c 1e1e1e
    ;;
  Suspend)
    systemctl suspend
    ;;
  *) ;;
esac

