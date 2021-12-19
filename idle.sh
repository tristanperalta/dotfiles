#!/usr/bin/env bash

killall xidlehook

xidlehook \
  --not-when-fullscreen \
  --time 120 \
    'xset dpms force off' \
    '' \
  --timer 300 \
    'i3lock -c 2f1e2e' \
    '' \
  --timer 3600 \
    'systemctl suspend' \
    ''
&
