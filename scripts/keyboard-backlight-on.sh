#!/bin/bash

# This script combines automatic and manual keyboard backlight device detection.
# It ensures the selected device's backlight stays on by checking its brightness every 0.1 seconds.
# Usage: keyboard-backlight-on.sh [auto|manual]
#   - If no argument or 'auto' is passed, it attempts automatic detection.
#   - If 'manual' is passed, it guides the user to manually select the device.

# Function for automatic detection logic
auto_detect_keyboard_led() {
    echo "Attempting automatic keyboard backlight detection..."

    mapfile -t candidate_devices < <(brightnessctl -l | grep 'scrolllock' | sed -n "s/.*Device '\([^']*\)'.*/\1/p")

    if [ ${#candidate_devices[@]} -eq 0 ]; then
        echo "Error: No keyboard backlight devices with 'scrolllock' found for automatic detection." >&2
        return 1
    fi

    local keyboardled=""

    # Heuristic 1: Prioritize devices with "kbd" or "backlight" in the name.
    for device in "${candidate_devices[@]}"; do
        if [[ "$device" == *"kbd"* || "$device" == *"backlight"* ]]; then
            keyboardled="$device"
            echo "Auto-detected likely device based on name: $keyboardled"
            break
        fi
    done

    # Heuristic 2: If no name matched, check for a unique device with variable brightness.
    if [ -z "$keyboardled" ]; then
        echo "No device name matched. Checking for unique device with variable brightness..."
        declare -a bright_devices
        for device in "${candidate_devices[@]}"; do
            max_bright=$(brightnessctl --device="$device" max)
            if [ "$max_bright" -gt 1 ]; then
                bright_devices+=("$device")
            fi
        done

        if [ ${#bright_devices[@]} -eq 1 ]; then
            keyboardled="${bright_devices[0]}"
            echo "Auto-detected unique device with variable brightness: $keyboardled"
        fi
    fi

    # Heuristic 3: If still ambiguous, use `udevadm` to find the USB device.
    if [ -z "$keyboardled" ] && [ ${#candidate_devices[@]} -gt 1 ]; then
        echo "Ambiguous devices found. Checking for a USB keyboard with udevadm..."
        for candidate in "${candidate_devices[@]}"; do
            base_name=${candidate%%::*}
            if [ -d "/sys/class/input/${base_name}" ]; then
                if udevadm info --query=property --path="/sys/class/input/${base_name}" | grep -q 'ID_BUS=usb'; then
                    keyboardled="$candidate"
                    echo "Auto-detected USB keyboard device via udevadm: $keyboardled"
                    break
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

    if [ -z "$keyboardled" ]; then
        echo "Error: Could not automatically determine the correct keyboard backlight device." >&2
        echo "Found multiple ambiguous devices: ${candidate_devices[*]}" >&2
        return 1
    else
        echo "$keyboardled" # Return the found device
        return 0
    fi
}

# Function for manual detection logic
manual_select_keyboard_led() {
    echo "Starting manual keyboard backlight device selection..."

    local outstring=$(brightnessctl -l)
    declare -a devices_all
    local i=0
    local prev_device=""

    # Parse all unique device names
    while [[ "$outstring" == *"Device '"* ]]; do
        current_device=${outstring#*"Device '"}
        current_device=${current_device%%"' of"*}

        if [[ "$current_device" != "$prev_device" ]]; then
            devices_all[$i]="$current_device"
            prev_device="$current_device"
            ((i++))
        fi
        outstring=${outstring#*"Device '"} # Move to the next "Device '" for the next iteration
    done

    declare -a scrlckdevices # array to store scrolllock device names only
    local j=0
    for device in "${devices_all[@]}"; do
        if [[ "${device#*"::"}" == "scrolllock" ]]; then
            scrlckdevices[$j]="$device"
            echo "Candidate device: $device"
            ((j++))
        fi
    done

    if [ ${#scrlckdevices[@]} -eq 0 ]; then
        echo "Error: No 'scrolllock' devices found for manual selection." >&2
        return 1
    fi

    local keyboardled_selected=""
    local scrlck_index=0
    for device in "${scrlckdevices[@]}"; do
        bright=$(brightnessctl get -d "${device}")
        if [ "$bright" -eq 0 ]; then
            brightnessctl -d "${device}" set 1
            echo "Did the keyboard LED turn on/blink for a second with device '${device}'? (y/n):"
            read -r lightconfirmation
            if [ "$lightconfirmation" == "y" ]; then
                echo -e "Keyboard LED device confirmed: ${device}!\nIf accidentally chose another device, stop this process and start another one!"
                keyboardled_selected="$device"
                break
            else
                brightnessctl -d "${device}" set 0 # Turn off if not confirmed
            fi
        else
            echo "Device '${device}' is already on. Did the keyboard LED turn on/blink for a second? (y/n):"
            read -r lightconfirmation
            if [ "$lightconfirmation" == "y" ]; then
                echo -e "Keyboard LED device confirmed: ${device}!\nIf accidentally chose another device, stop this process and start another one!"
                keyboardled_selected="$device"
                break
            fi
        fi
        ((scrlck_index++))
    done

    if [ -z "$keyboardled_selected" ]; then
        echo "Error: Manual selection failed. No keyboard LED device confirmed." >&2
        return 1
    else
        echo "$keyboardled_selected" # Return the found device
        return 0
    fi
}

# --- Main script logic ---

MODE=${1:-auto} # Default to 'auto' if no argument is passed
KEYBOARD_LED_DEVICE=""

if [[ "$MODE" == "auto" ]]; then
    KEYBOARD_LED_DEVICE=$(auto_detect_keyboard_led)
    if [ $? -ne 0 ]; then
        echo "Automatic detection failed. Exiting."
        exit 1
    fi
elif [[ "$MODE" == "manual" ]]; then
    KEYBOARD_LED_DEVICE=$(manual_select_keyboard_led)
    if [ $? -ne 0 ]; then
        echo "Manual selection failed. Exiting."
        exit 1
    fi
else
    echo "Usage: $0 [auto|manual]"
    echo "Invalid argument: '$MODE'. Defaulting to 'auto'."
    KEYBOARD_LED_DEVICE=$(auto_detect_keyboard_led)
    if [ $? -ne 0 ]; then
        echo "Automatic detection also failed after invalid argument. Exiting."
        exit 1
    fi
fi

if [ -z "$KEYBOARD_LED_DEVICE" ]; then
    echo "Fatal Error: No keyboard backlight device could be determined. Exiting." >&2
    exit 1
fi

echo "Monitoring keyboard backlight on device: '$KEYBOARD_LED_DEVICE'. Press Ctrl+C to stop."

# Ensure the light is on when the script starts.
brightnessctl --device="$KEYBOARD_LED_DEVICE" set 1

# Start an infinite loop to continuously monitor the backlight.
while true; do
    bright=$(brightnessctl --device="$KEYBOARD_LED_DEVICE" get)

    if [ "$bright" -eq 0 ]; then
        brightnessctl --device="$KEYBOARD_LED_DEVICE" set 1
    fi

    sleep 0.1
done

exit 0
