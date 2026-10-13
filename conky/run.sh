#!/bin/sh
# Keep the conky widget alive on COSMIC.
# When the screens are reconfigured (right after login, or when a monitor is plugged in or out),
# conky's desktop surface is closed. Conky then logs "received termination signal" but hangs
# instead of exiting, so the widget silently disappears. Restart it whenever that happens.
# Waiting on conky's log output costs no CPU (no polling).

sleep 3
while true; do
    conky 2>&1 | while read -r line; do
        case "$line" in
        *"received termination signal"*) pkill -9 -x conky ;;
        esac
    done
    sleep 3 # let the new screen setup settle before drawing again
done
