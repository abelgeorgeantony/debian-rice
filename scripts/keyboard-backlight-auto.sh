#!/bin/bash

# This script automatically finds the correct keyboard backlight device
# and ensures it stays on by checking its brightness every 0.1 seconds.
# It uses a series of heuristics to avoid asking the user for input.

# --- Step 1: Find all potential 'scrolllock' devices ---

# Use a clean pipeline to find all devices containing 'scrolllock' in their name
# and store them in the `candidate_devices` array.
mapfile -t candidate_devices < <(brightnessctl -l | grep 'scrolllock' | sed -n "s/.*Device '\([^']*\)'.*/\1/p")

# If no potential devices are found, exit with an error.
if [ ${#candidate_devices[@]} -eq 0 ]; then
    echo "Error: No keyboard backlight devices with 'scrolllock' found." >&2
    exit 1
fi

# --- Step 2: Automatically select the correct device using heuristics ---

keyboardled="" # This variable will store the final, correct device name.

# Heuristic 1: Prioritize devices with "kbd" or "backlight" in the name.
# This is the most reliable indicator.
for device in "${candidate_devices[@]}"; do
    if [[ "$device" == *"kbd"* || "$device" == *"backlight"* ]]; then
        keyboardled="$device"
        echo "Found likely device based on name: $keyboardled"
        break # Exit the loop as we've found a very strong match.
    fi
done

# Heuristic 2: If no name matched, check for a unique device with variable brightness.
# A backlight can dim (max > 1), but an indicator light is usually just on/off (max = 1).
if [ -z "$keyboardled" ]; then
    echo "No device name matched. Checking for unique device with variable brightness..."
    declare -a bright_devices
    for device in "${candidate_devices[@]}"; do
        # Get the maximum brightness for the device.
        max_bright=$(brightnessctl --device="$device" max)
        if [ "$max_bright" -gt 1 ]; then
            bright_devices+=("$device")
        fi
    done

    # If exactly one device has variable brightness, we've found our target.
    if [ ${#bright_devices[@]} -eq 1 ]; then
        keyboardled="${bright_devices[0]}"
        echo "Found unique device with variable brightness: $keyboardled"
    fi
fi

# Heuristic 3 (IMPROVED): If still ambiguous, use `udevadm` to find the USB device.
# This is the most robust way to identify an external keyboard.
if [ -z "$keyboardled" ] && [ ${#candidate_devices[@]} -gt 1 ]; then
    echo "Ambiguous devices found. Checking for a USB keyboard with udevadm..."
    for candidate in "${candidate_devices[@]}"; do
        # Extract the base device name (e.g., "input41" from "input41::scrolllock").
        base_name=${candidate%%::*}

        # Check if a corresponding sysfs path exists.
        if [ -d "/sys/class/input/${base_name}" ]; then
            # Use udevadm to query device properties and check if it's a USB device.
            if udevadm info --query=property --path="/sys/class/input/${base_name}" | grep -q 'ID_BUS=usb'; then
                keyboardled="$candidate"
                echo "Found USB keyboard device via udevadm: $keyboardled"
                break # Found it, so we can exit the loop.
            fi
        fi
    done
fi


# Heuristic 4: If we still haven't found the device, but there is only one
# candidate left from the initial scan, it's safe to assume that's the one we want.
if [ -z "$keyboardled" ] && [ ${#candidate_devices[@]} -eq 1 ]; then
    keyboardled="${candidate_devices[0]}"
    echo "Only one 'scrolllock' device found. Assuming it's the correct one: $keyboardled"
fi

# --- Step 3: Start the monitoring loop if a device was found ---

# If `keyboardled` is still empty, it means we couldn't safely determine
# the correct device. Exit with an error.
if [ -z "$keyboardled" ]; then
    echo "Error: Could not automatically determine the correct keyboard backlight device." >&2
    echo "Found multiple ambiguous devices: ${candidate_devices[*]}" >&2
    exit 1
fi

echo "Monitoring keyboard backlight on device: '$keyboardled'. Press Ctrl+C to stop."

# Ensure the light is on when the script starts.
brightnessctl --device="$keyboardled" set 1

# Start an infinite loop to continuously monitor the backlight.
while true; do
    # Get the current brightness of the confirmed device.
    bright=$(brightnessctl --device="$keyboardled" get)

    # If the brightness is 0, it means something turned it off.
    if [ "$bright" -eq 0 ]; then
        # Turn it back on immediately.
        brightnessctl --device="$keyboardled" set 1
    fi

    # Wait for a tenth of a second before checking again to avoid high CPU usage.
    sleep 0.1
done

exit 0

