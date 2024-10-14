#!/bin/sh

# Global user input 
export OpenFOAMversion=2.4.0   

# Read the startTime value from the controlDict file
controlDictFile="system/controlDict"
if [ -f "$controlDictFile" ]; then
    # Use awk to find the line with 'startTime' and extract the value
    startTime=$(awk '/startTime/ {for (i=1; i<=NF; i++) if ($i == "startTime") {gsub(";", "", $(i+1)); print $(i+1)}}' "$controlDictFile")
    
    # Convert startTime to an integer
    startTimeInt=$(printf "%.0f" "$startTime")  # This converts to integer
    
    # Export the value as a global variable
    if [ -n "$startTimeInt" ]; then
        export startTime=$startTimeInt  # Export the integer version
    else
        echo "Error: startTime not found in controlDict file."
    fi

    # Use awk to find the line with 'endTime' and extract the value
    endTime=$(awk '/endTime/ {for (i=1; i<=NF; i++) if ($i == "endTime") {gsub(";", "", $(i+1)); print $(i+1)}}' "$controlDictFile")
    
    # Convert endTime to an integer
    endTimeInt=$(printf "%.0f" "$endTime")  # This converts to integer
    
    # Export the value as a global variable
    if [ -n "$endTimeInt" ]; then
        export endTime=$endTimeInt  # Export the integer version
    else
        echo "Error: endTime not found in controlDict file."
    fi
else
    echo "Error: controlDict file not found."
fi
#export startTime=0 
#export endTime=200

# Read the nCores value from the setUp file
if [ -f setUp ]; then
    nCores=$(awk '/nCores/ {print $2}' setUp | tr -d ';')
    
    # Export the value as a global variable
    if [ -n "$nCores" ]; then
        export cores=$nCores
    else
        echo "Error: nCores not found in setUp file."
    fi
else
    echo "Error: setUp file not found."
fi
# export cores=12     


# Read inflow direction from the setUp file
if [ -f setUp ]; then
    # Extract the wind direction, looking for the exact "dir   " with spaces
    windDirection=$(awk '/dir   / {print $2}' setUp | tr -d ';')

    # Ensure the value is a valid number (check for digits and optional decimal point)
    if [[ -n "$windDirection" && "$windDirection" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        # Convert windDirection to an integer for comparison
        windDirectionInt=$(printf "%.0f" "$windDirection")

        # Determine and export the compass direction based on wind direction
        if [ "$windDirectionInt" -eq 0 ] || [ "$windDirectionInt" -eq 360 ]; then
            export inflowDir="north"
        elif [ "$windDirectionInt" -gt 0 ] && [ "$windDirectionInt" -lt 90 ]; then
            export inflowDir="northeast"
        elif [ "$windDirectionInt" -eq 90 ]; then
            export inflowDir="east"
        elif [ "$windDirectionInt" -gt 90 ] && [ "$windDirectionInt" -lt 180 ]; then
            export inflowDir="southeast"
        elif [ "$windDirectionInt" -eq 180 ]; then
            export inflowDir="south"
        elif [ "$windDirectionInt" -gt 180 ] && [ "$windDirectionInt" -lt 270 ]; then
            export inflowDir="southwest"
        elif [ "$windDirectionInt" -eq 270 ]; then
            export inflowDir="west"
        elif [ "$windDirectionInt" -gt 270 ] && [ "$windDirectionInt" -lt 360 ]; then
            export inflowDir="northwest"
        else
            echo "Error: Invalid wind direction value $windDirectionInt."
        fi
    else
        echo "Error: Invalid inflow direction value in setUp file: $windDirection."
    fi
else
    echo "Error: setUp file not found."
fi
